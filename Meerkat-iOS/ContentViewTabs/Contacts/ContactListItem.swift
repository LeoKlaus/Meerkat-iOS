//
//  ContactListItem.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 29.03.26.
//

import SwiftUI
import MeerkatAPI
import EasyErrorHandling

struct ContactListItem: View {
    
    let contact: Contact
    
    var body: some View {
        HStack {
            ContactImage(contact: self.contact)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(self.contact.fullName)
                
                if let circles = self.contact.circles, !circles.isEmpty {
                    HStack {
                        ForEach(circles, id: \.self) { circle in
                            CircleItem(circle: circle)
                                .font(.caption)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    List {
        ContactListItem(contact: .mock)
            .frame(height: 50)
        ContactListItem(
            contact: Contact(
                id: 4,
                createdAt: .now,
                updatedAt: nil,
                deletedAt: nil,
                firstname: "Max",
                lastname: "Mustermann",
                nickname: "Maxi",
                gender: .male,
                email: nil,
                phone: nil,
                birthday: nil,
                photo: nil,
                relationships: nil,
                address: nil,
                howWeMet: nil,
                foodPreference: nil,
                workInformation: nil,
                contactInformation: nil,
                circles: nil,
                customFields: nil,
                archived: false,
                photoThumbnail: nil
            )
        )
        .frame(maxHeight: 50)
    }
    .withErrorHandling()
    .environment(ConnectionHandler.mock)
}
