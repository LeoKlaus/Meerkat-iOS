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
    
    @State private var page: Int = 1
    
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
            try await self.connectionHandler.getContacts(limit: 50, page: self.page)
            self.page += 1
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if !self.connectionHandler.hasRemainingContacts && self.connectionHandler.contacts.isEmpty {
                    ContentUnavailableView {
                        Label("You don't have any contacts", systemImage: "person.circle.fill")
                    } actions: {
                        Button {
                            
                        } label: {
                            Label("Create a Contact", systemImage: "plus")
                        }
                        .glassProminentButtonStyleIfAvailable()
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
                        try await self.connectionHandler.getContacts()
                        self.page = 1
                    }
                }
            }
            .navigationTitle("Contacts")
            .navigationDestination(for: Contact.self) { contact in
                ContactDetailView(contact: contact)
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Add Contact", systemImage: "plus") {
                        
                    }
                }
            }
        }
    }
}

#Preview {
    ContactList()
        .withErrorHandling()
        .environment(ConnectionHandler.mock)
}
