//
//  ContactDetailAboutSection.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 06.04.26.
//

import SwiftUI
import MeerkatAPI
import EasyErrorHandling

struct ContactDetailAboutSection: View {
    
    let contact: Contact
    
    @AppStorage(.userDefaults(.supportedMessengers), store: .meerkat) var supportedMessengers: [SupportedMessenger] = SupportedMessenger.standard
    
    var body: some View {
        Section("About \(self.contact.firstname)") {
            if let birthday = contact.birthday {
                Label(birthday.toAgeString(), systemImage: "birthday.cake")
            }
            if let address = contact.address, !address.isEmpty {
                Label(address, systemImage: "house")
            }
            
            if let workInformation = contact.workInformation, !workInformation.isEmpty {
                Label(workInformation, systemImage: "suitcase")
            }
            
            if let foodPreference = contact.foodPreference, !foodPreference.isEmpty {
                Label(foodPreference, systemImage: "fork.knife")
            }
            
            if let howWeMet = contact.howWeMet, !howWeMet.isEmpty {
                Label(howWeMet, systemImage: "person.2")
            }
            
            if let contactInfo = contact.contactInformation, !contactInfo.isEmpty {
                Label(contactInfo, systemImage: "list.clipboard")
            }
            
            ForEach(self.contact.nonMessengerFields(self.supportedMessengers).sorted(by: >), id: \.key) { label, value in
                if !value.isEmpty {
                    Label {
                        VStack(alignment: .leading) {
                            Text(label)
                                .foregroundStyle(.secondary)
                                .font(.caption)
                            Text(value)
                        }
                    } icon: {
                        Image(systemName: "pencil")
                    }
                }
            }
        }
    }
}

#Preview {
    ContactDetailAboutSection(contact: .mock)
}
