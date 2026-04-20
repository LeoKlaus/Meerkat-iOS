//
//  ContactList.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 29.03.26.
//

import SwiftUI
import MeerkatAPI
import EasyErrorHandling

struct ContactList: View {
    
    @EnvironmentObject var errorHandler: ErrorHandler
    @Environment(ConnectionHandler.self) var connectionHandler
    @Environment(NavigationHandler.self) var navigationHandler
    
    var isSearchContext: Bool = false
    
    @State private var page: Int = 1
    
    @StateObject private var searchText = DebouncedText(delay: .milliseconds(250))
    
    @State private var sortBy: Contact.CodingKeys = .id
    @State private var sortOrder: SortOrder = .reverse
    @State private var includeArchived: Bool = false
    @State private var circleFilter: String? = nil
    
    var placeholder: some View {
        Group {
            ContactListItem(contact: .placeholder)
                .frame(maxHeight: 50)
            ContactListItem(contact: .placeholder)
                .frame(maxHeight: 50)
            ContactListItem(contact: .placeholder)
                .frame(maxHeight: 50)
        }
        .shimmerEffect()
        .redacted(reason: .placeholder)
        .throwingTask(id: self.page, taskDescription: "loading contacts") {
            try await self.loadContacts()
        }
    }
    
    var body: some View {
        @Bindable var navigationHandler = self.navigationHandler
        NavigationStack(path: $navigationHandler.contactsTabPath) {
            Group {
                if !self.connectionHandler.hasRemainingContacts && self.connectionHandler.contacts.isEmpty {
                    if self.isSearchContext {
                        ContentUnavailableView("No matching contacts found", systemImage: "person.fill.questionmark")
                        
                    } else {
                        ContentUnavailableView {
                            Label("You don't have any contacts", systemImage: "person.circle.fill")
                        } actions: {
                            NavigationLink(destination: EditContactView() {
                                try await self.loadContacts(isRefresh: true)
                            }) {
                                Label("Create a Contact", systemImage: "plus")
                            }
                            .glassProminentButtonStyleIfAvailable()
                        }
                    }
                } else {
                    List {
                        ForEach(self.connectionHandler.contacts) { contact in
                            NavigationLink(value: contact) {
                                ContactListItem(contact: contact)
                            }
                            .frame(maxHeight: 50)
                        }
                        
                        if self.connectionHandler.hasRemainingContacts {
                            self.placeholder
                        }
                    }
                    .throwingRefreshable(taskDescription: "reloading contacts") {
                        try await self.loadContacts(isRefresh: true)
                    }
                }
            }
            .searchable(text: self.$searchText.inputText)
            .onChange(of: self.searchText.debouncedText) {
                Task {
                    try await self.loadContacts(isRefresh: true)
                }
            }
            .onChange(of: self.connectionHandler.currentInstance.id) {
                self.page = 1
            }
            .navigationTitle(self.isSearchContext ? "Search" : "Contacts")
            .navigationDestination(for: Contact.self) { contact in
                ContactDetailView(contact: contact)
            }
            .navigationDestination(for: Int.self) { contactId in
                AsyncContactDetailView(contactId: contactId)
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Menu {
                        SortButton(title: "Created", systemImage: "calendar") {
                            self.sortBy == .id
                        } action: {
                            self.sortBy = .id
                            self.loadContactsWrapped()
                        }
                        
                        SortButton(title: "First Name", systemImage: "person.wave.2") {
                            self.sortBy == .firstname
                        } action: {
                            self.sortBy = .firstname
                            self.loadContactsWrapped()
                        }
                        
                        SortButton(title: "Last Name", systemImage: "person.text.rectangle") {
                            self.sortBy == .lastname
                        } action: {
                            self.sortBy = .lastname
                            self.loadContactsWrapped()
                        }
                        
                        Divider()
                        
                        SortButton(title: "Ascending", systemImage: "arrow.up.to.line") {
                            self.sortOrder == .forward
                        } action: {
                            self.sortOrder = .forward
                            self.loadContactsWrapped()
                        }
                        
                        SortButton(title: "Descending", systemImage: "arrow.down.to.line") {
                            self.sortOrder == .reverse
                        } action: {
                            self.sortOrder = .reverse
                            self.loadContactsWrapped()
                        }
                        
                        Divider()
                        
                        
                        Button(
                            self.includeArchived ? "Exclude Archived": "Include Archived",
                            systemImage: self.includeArchived ? "archivebox.fill" : "archivebox"
                        ) {
                            self.includeArchived.toggle()
                            self.loadContactsWrapped()
                        }
                    } label: {
                        Label("Sort options", systemImage: "arrow.up.arrow.down")
                    }
                }
                
                ToolbarItem(placement: .navigation) {
                    Menu {
                        Button("All") {
                            self.circleFilter = nil
                            self.loadContactsWrapped()
                        }.disabled(self.circleFilter == nil)
                        
                        Divider()
                        
                        ForEach(self.connectionHandler.circles, id: \.self) { circle in
                            Button(circle) {
                                self.circleFilter = circle
                                self.loadContactsWrapped()
                            }.disabled(self.circleFilter == circle)
                        }
                    } label: {
                        Label("Filter by Circles", systemImage: self.circleFilter == nil ? "person.2.badge.gearshape" : "person.2.badge.gearshape.fill")
                    }
                }
                
                if !self.isSearchContext {
                    ToolbarItem(placement: .primaryAction) {
                        NavigationLink(destination: EditContactView() {
                            try await self.loadContacts(isRefresh: true)
                        }) {
                            Label("Add Contact", systemImage: "plus")
                        }
                    }
                }
            }
        }
    }
    
    func loadContactsWrapped() {
        Task {
            do {
                try await self.loadContacts(isRefresh: true)
            } catch {
                self.errorHandler.handle(error, while: "refreshing contacts")
            }
        }
    }
    
    func loadContacts(isRefresh: Bool = false) async throws {
        if isRefresh {
            self.page = 1
        }
        
        try await self.connectionHandler.getCircles()
        
        if self.searchText.debouncedText.isEmpty {
            try await self.connectionHandler.getContacts(limit: 50, page: self.page, sortBy: self.sortBy, sortOrder: self.sortOrder, includeArchived: self.includeArchived, circleFilter: self.circleFilter)
        } else {
            try await self.connectionHandler.getContacts(limit: 50, page: self.page, searchText: self.searchText.debouncedText, sortBy: self.sortBy, sortOrder: self.sortOrder, includeArchived: self.includeArchived, circleFilter: self.circleFilter)
        }
        
        if !isRefresh {
            self.page += 1
        }
    }
}

struct SortButton: View {
    
    let title: LocalizedStringKey
    let systemImage: String
    let condition: () -> Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: self.action) {
            Label(self.title, systemImage: self.condition() ? "checkmark" : self.systemImage)
        }
        .disabled(self.condition())
    }
}

#Preview {
    ContactList()
        .withErrorHandling()
        .environment(ConnectionHandler.mock)
}
