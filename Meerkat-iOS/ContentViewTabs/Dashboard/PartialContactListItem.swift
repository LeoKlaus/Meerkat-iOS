//
//  PartialContactListItem.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 05.04.26.
//

import SwiftUI
import MeerkatAPI
import EasyErrorHandling

struct PartialContactListItem: View {
    
    @Environment(ConnectionHandler.self) var connectionHandler
    
    @State var contact: Contact
    
    @State private var isContactLoaded: Bool = false
    
    init(contact: Contact) {
        self.contact = contact
    }
    
    var body: some View {
        if self.isContactLoaded {
            NavigationLink(value: self.contact) {
                ContactListItem(contact: self.contact)
            }
        } else {
            ContactListItem(contact: self.contact)
                .throwingTask(taskDescription: "loading data for contact \(contact.firstAndLastName)") {
                    let contact = try await self.connectionHandler.getContact(id: self.contact.id)
                    withAnimation {
                        self.contact = contact
                        self.isContactLoaded = true
                    }
            }
        }
    }
}

#Preview("With Contact") {
    NavigationStack {
        List {
            BirthdayListItem(birthday: .mock)
                .frame(maxHeight: 50)
        }
    }
    .withErrorHandling()
    .environment(ConnectionHandler.mock)
}
