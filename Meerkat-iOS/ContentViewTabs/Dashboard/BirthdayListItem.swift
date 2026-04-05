//
//  BirthdayListItem.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 03.04.26.
//

import SwiftUI
import MeerkatAPI
import EasyErrorHandling

struct BirthdayListItem: View {
    
    @Environment(ConnectionHandler.self) var connectionHandler
    
    let birthday: Birthday
    
    @State private var associatedContact: Contact?
    
    var body: some View {
        if let associatedContact {
            NavigationLink(value: associatedContact) {
                HStack {
                    ContactImage(contact: associatedContact)
                        .clipShape(.circle)
                    VStack(alignment: .leading) {
                        Text(birthday.name)
                        Text(birthday.birthday)
                            .foregroundStyle(.secondary)
                            .font(.caption)
                    }
                }
            }
        } else {
            HStack {
                VStack(alignment: .leading) {
                    Text(birthday.name)
                    Text(birthday.birthday)
                        .foregroundStyle(.secondary)
                        .font(.caption)
                }
            }
            .throwingTask(taskDescription: "loading associated contact for birthday \(birthday.name)") {
                if let contactId = birthday.contactId {
                    let contact = try await self.connectionHandler.apiHandler.getContact(id: contactId)
                    withAnimation {
                        self.associatedContact = contact
                    }
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
