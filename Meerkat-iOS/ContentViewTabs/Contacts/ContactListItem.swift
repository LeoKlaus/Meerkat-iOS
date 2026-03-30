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
            VStack(alignment: .leading) {
                Text(contact.fullName)
                HStack {
                    ForEach(contact.circles ?? [], id: \.self) { circle in
                        CircleItem(circle: circle)
                            .font(.caption)
                    }
                }
            }
        }
    }
}

#Preview {
    List {
        ContactListItem(contact: .mock)
            .frame(maxHeight: 50)
    }
    .withErrorHandling()
    .environment(ConnectionHandler.mock)
}
