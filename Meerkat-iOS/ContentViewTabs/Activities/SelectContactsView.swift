//
//  SelectContactsView.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 16.04.26.
//

import SwiftUI
import MeerkatAPI
import EasyErrorHandling

struct SelectContactsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Environment(ConnectionHandler.self) var connectionHandler
    @EnvironmentObject var errorHandler: ErrorHandler

    @Binding var selectedContacts: [Contact]?

    @State private var page = 1
    
    @StateObject private var searchText = DebouncedText(delay: .milliseconds(250))
    
    let isSingleSelect: Bool
    
    init(selectedContacts: Binding<[Contact]?>) {
        self._selectedContacts = selectedContacts
        self.isSingleSelect = false
    }
    
    init(selectedContact: Binding<Contact?>) {
        self._selectedContacts = Binding {
            if let safe = selectedContact.wrappedValue {
                [safe]
            } else {
                nil
            }
        } set: { newValue in
            selectedContact.wrappedValue = newValue?.last
        }
        self.isSingleSelect = true
    }
    
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
        List {
            if let selectedContacts, !selectedContacts.isEmpty {
                Section("Selected") {
                    ForEach(selectedContacts) { contact in
                        Button {
                            withAnimation {
                                self.selectedContacts?.removeAll(where: {
                                    $0 == contact
                                })
                            }
                        } label: {
                            ContactListItem(contact: contact)
                                .frame(maxHeight: 50)
                        }
                        .foregroundStyle(.primary)
                    }
                }
            }
            
            Section("Available") {
                ForEach(self.connectionHandler.contacts.filter{ !(self.selectedContacts?.contains($0) ?? false) }) { contact in
                    Button {
                        withAnimation {
                            if self.isSingleSelect {
                                self.selectedContacts = [contact]
                                self.dismiss()
                            } else {
                                if self.selectedContacts == nil {
                                    self.selectedContacts = [contact]
                                } else {
                                    self.selectedContacts?.append(contact)
                                }
                            }
                        }
                    } label: {
                        ContactListItem(contact: contact)
                            .frame(maxHeight: 50)
                    }
                    .foregroundStyle(.primary)
                }
                
                if self.connectionHandler.hasRemainingContacts {
                    self.placeholder
                }
            }
        }
        .searchable(text: self.$searchText.inputText)
        .onChange(of: self.searchText.debouncedText) {
            Task {
                try await self.loadContacts(isRefresh: true)
            }
        }
        .throwingRefreshable(taskDescription: "reloading contacts") {
            try await self.loadContacts(isRefresh: true)
        }
    }
    
    func loadContacts(isRefresh: Bool = false) async throws {
        if isRefresh {
            self.page = 1
        }
        
        try await self.connectionHandler.getCircles()
        
        if self.searchText.debouncedText.isEmpty {
            try await self.connectionHandler.getContacts(limit: 50, page: self.page)
        } else {
            try await self.connectionHandler.getContacts(limit: 50, page: self.page, searchText: self.searchText.debouncedText)
        }
        
        if !isRefresh {
            self.page += 1
        }
    }
}

#Preview {
    @Previewable @State var selectedContacts: [Contact]? = nil
    
    NavigationStack {
        SelectContactsView(selectedContacts: $selectedContacts)
    }
    .environment(ConnectionHandler.mock)
    .withErrorHandling()
}

#Preview {
    @Previewable @State var selectedContact: Contact? = nil
    
    NavigationStack {
        SelectContactsView(selectedContact: $selectedContact)
    }
    .environment(ConnectionHandler.mock)
    .withErrorHandling()
}
