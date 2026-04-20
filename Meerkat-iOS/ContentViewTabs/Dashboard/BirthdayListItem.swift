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
    
    var nameAndBirthday: some View {
        VStack(alignment: .leading) {
            Text(birthday.name)
            HStack(spacing: 1) {
                if self.birthday.birthday.isToday {
                    Image(systemName: "birthday.cake")
                        .foregroundStyle(.tint)
                }
                Text(birthday.birthday.toBirthdayStringWithAge())
                    .font(.caption)
                    .bold(birthday.birthday.isToday)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    var body: some View {
        if let associatedContact {
            NavigationLink(value: associatedContact) {
                HStack {
                    ContactImage(contact: associatedContact)
                        .clipShape(.circle)
                    
                    self.nameAndBirthday
                }
            }
        } else {
            HStack {
                self.nameAndBirthday
            }
            .throwingTask(taskDescription: "loading associated contact for birthday \(birthday.name)") {
                if let contactId = birthday.contactId {
                    let contact = try await self.connectionHandler.getContact(id: contactId)
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

#Preview("Today") {
    NavigationStack {
        List {
            BirthdayListItem(birthday: Birthday(type: .contact, name: "Gustav Gans", birthday: .init(todayMinusYears: 21), contactId: 1))
                .frame(maxHeight: 50)
        }
    }
    .withErrorHandling()
    .environment(ConnectionHandler.mock)
}
