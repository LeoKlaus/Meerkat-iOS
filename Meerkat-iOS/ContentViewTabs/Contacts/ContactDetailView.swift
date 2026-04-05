//
//  ContactDetailView.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 03.04.26.
//

import SwiftUI
import MeerkatAPI
import EasyErrorHandling

struct ContactDetailView: View {
    
    let contact: Contact
    
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading) {
                    HStack {
                        ContactImage(contact: self.contact)
                            .clipShape(Circle())
                            .frame(maxWidth: 75)
                        
                        VStack(alignment: .leading) {
                            Text(contact.fullName)
                                .font(.title)
                            if let gender = contact.gender {
                                Text(gender.localizedRepresentation)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    
                    HStack {
                        ForEach(contact.circles ?? [], id: \.self) { circle in
                            CircleItem(circle: circle)
                        }
                    }
                }
            }
            
            Section {
                Text(contact.address ?? "")
            }
        }
    }
}

#Preview {
    NavigationStack {
        ContactDetailView(contact: .mock)
    }
    .withErrorHandling()
    .environment(ConnectionHandler.mock)
}
