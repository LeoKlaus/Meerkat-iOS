//
//  EditContactMessengerSection.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 12.04.26.
//

import SwiftUI
import MeerkatAPI
import EasyErrorHandling

struct EditContactMessengerSection: View {
    
    @Environment(ConnectionHandler.self) var connectionHandler
    @EnvironmentObject var errorHandler: ErrorHandler
    
    @AppStorage(.userDefaults(.supportedMessengers), store: .meerkat) var supportedMessengers: [SupportedMessenger] = SupportedMessenger.standard
    
    @Binding var contact: Contact
    
    var availableMessengers: [SupportedMessenger] {
        self.supportedMessengers.filter {
            !(self.contact.customFields.map(\.keys)?.contains($0.fieldId) ?? false)
        }
    }
    
    @State private var showEditMessengerAlert: Bool = false
    @State private var messengerToEdit: SupportedMessenger?
    @State private var newUserId: String = ""
    
    var body: some View {
        Section("Contact Information") {
            NullableTextField("Email", text: self.$contact.email)
            NullableTextField("Phone", text: self.$contact.phone)
            MultiLineTextField(
                "Address",
                text: Binding(
                    get: {
                        self.contact.address ?? ""
                    },
                    set: { newValue in
                        if !newValue.isEmpty {
                            self.contact.address = newValue
                        } else {
                            self.contact.address = nil
                        }
                    })
            )
            
            ForEach(self.contact.getMatchingMessengers(self.supportedMessengers), id: \.id) { messengerLink in
                Menu {
                    Button("Remove \(messengerLink.messenger.name)", systemImage: "trash", role: .destructive) {
                        self.contact.customFields?.removeValue(forKey: messengerLink.messenger.fieldId)
                    }
                    Button("Edit ID for \(messengerLink.messenger.name)", systemImage: "pencil") {
                        self.messengerToEdit = messengerLink.messenger
                        self.showEditMessengerAlert = true
                    }
                } label: {
                    MessengerLinkListItem(messengerLink: messengerLink)
                }
                .foregroundStyle(.primary)
            }
            
            if !self.availableMessengers.isEmpty {
                Menu {
                    ForEach(self.availableMessengers) { messenger in
                        Button(messenger.name) {
                            if var customFields = self.contact.customFields {
                                customFields[messenger.fieldId] = ""
                            } else {
                                self.contact.customFields = [messenger.fieldId: ""]
                            }
                            self.messengerToEdit = messenger
                            self.showEditMessengerAlert = true
                        }
                    }
                } label: {
                    Label("Add Messenger", systemImage: "plus")
                }
            }
        }
        .alert("User ID for \(self.messengerToEdit?.name ?? "Messenger")", isPresented: self.$showEditMessengerAlert, presenting: self.messengerToEdit) { messenger in
            TextField("User ID", text: self.$newUserId)
            if let phone = self.contact.phone, !phone.isEmpty {
                Button("Use Phone Number") {
                    self.updateMessengerId(newId: phone.replacingOccurrences(of: " ", with: ""), messengerField: messenger.fieldId)
                    self.newUserId = ""
                }
            }
            if let mail = self.contact.email, !mail.isEmpty {
                Button("Use Mail Address") {
                    self.updateMessengerId(newId: mail, messengerField: messenger.fieldId)
                    self.newUserId = ""
                }
            }
            
            Button("Done") {
                self.updateMessengerId(newId: self.newUserId, messengerField: messenger.fieldId)
                self.newUserId = ""
            }
        }
    }
    
    func updateMessengerId(newId: String, messengerField: String) {
        self.contact.customFields?[messengerField] = newId
    }
}

#Preview {
    @Previewable @State var contact: Contact = .mock
    List {
        EditContactMessengerSection(contact: $contact)
    }
    .environment(ConnectionHandler.mock)
    .withErrorHandling()
}
