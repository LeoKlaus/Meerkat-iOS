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
    
    @Environment(ConnectionHandler.self) var connectionHandler
    
    @State private var contacts: [Contact] = []
    
    var body: some View {
        List {
            ForEach(contacts) { contact in
                ContactListItem(contact: contact)
                    .frame(maxHeight: 50)
            }
        }
        .throwingTask(taskDescription: "loading contacts") {
            self.contacts = try await self.connectionHandler.getContacts()
        }
    }
}

#Preview {
    ContactList()
        .withErrorHandling()
        .environment(ConnectionHandler.mock)
}
