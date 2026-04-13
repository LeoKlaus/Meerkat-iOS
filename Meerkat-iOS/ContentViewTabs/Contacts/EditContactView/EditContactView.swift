//
//  EditContactView.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 08.04.26.
//

import SwiftUI
import MeerkatAPI
import EasyErrorHandling

struct EditContactView: View {
    
    
    @Environment(\.dismiss) var dismiss
    
    @Environment(ConnectionHandler.self) var connectionHandler
    @EnvironmentObject var errorHandler: ErrorHandler
    
    @State private var contact: Contact
    
    let isNewContact: Bool
    let updateParent: () async throws -> Void
    
    init(updateParent: @escaping () async throws -> Void) {
        self.contact = Contact.empty
        self.isNewContact = true
        self.updateParent = updateParent
    }
    
    init(contact: Contact, updateParent: @escaping () async throws -> Void) {
        self.contact = contact
        self.isNewContact = false
        self.updateParent = updateParent
    }
    
    var body: some View {
        List {
            Section {
                if !self.isNewContact {
                    Menu {
                        Button("Upload from Photos", systemImage: "photo") {
                            //TODO: Implement
                        }
                        
                        Button("Upload from Files", systemImage: "folder") {
                            //TODO: Implement
                        }
                        
                        Button("Take a Photo", systemImage: "camera.fill") {
                            // TODO: Implement
                        }
                    } label: {
                        VStack(alignment: .center) {
                            ContactImage(contact: self.contact)
                                .frame(maxHeight: 100)
                                .clipShape(.circle)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .alignmentGuide(.listRowSeparatorLeading) { _ in
                        return 0
                    }
                }
                TextField("First Name", text: self.$contact.firstname)
                
                NullableTextField("Last Name", text: self.$contact.lastname)
                
                NullableTextField("Nickname", text: self.$contact.nickname)
                
                Picker("Gender", selection: self.$contact.gender) {
                    Text("Female").tag(Gender.female)
                    Text("Male").tag(Gender.male)
                    Text("Other").tag(Gender.other)
                    Text("Prefer not to say").tag(Gender.preferNotToSay)
                    Text("Unknown").tag(nil as Gender?)
                }
            }
            
            EditContactCircleSection(contact: self.$contact)
            
            Section("Birthday") {
                NullableDatePickerWithOptionalYear(dateComponents: self.$contact.birthday)
            }
            
            EditContactMessengerSection(contact: self.$contact)
            
            Section("Additional Information") {
                NullableTextField("Work Information", text: self.$contact.workInformation)
                
                NullableTextField("Food Preferences", text: self.$contact.foodPreference)
                
                NullableTextField("How We Met", text: self.$contact.howWeMet)
                
                NullableTextField("Additional Information", text: self.$contact.contactInformation)
            }
            
            EditContactCustomFieldsSection(contact: self.$contact)
        }
        .throwingTask(taskDescription: "loading custom fields", self.connectionHandler.getCustomFields)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save", systemImage: "checkmark") {
                    Task {
                        do {
                            if self.isNewContact {
                                _ = try await self.connectionHandler.createContact(self.contact)
                            } else {
                                _ = try await  self.connectionHandler.updateContact(self.contact)
                            }
                            
                            try await self.updateParent()
                            if self.isNewContact {
                                self.dismiss()
                            }
                            self.errorHandler.showInfo("Contact saved!")
                        } catch {
                            self.errorHandler.handle(error, while: "updating contact")
                        }
                    }
                }
            }
        }
    }
}

#Preview("New Contact") {
    NavigationStack {
        EditContactView() { }
    }
    .withErrorHandling()
    .environment(ConnectionHandler.mock)
}

#Preview("Existing Contact") {
    NavigationStack {
        EditContactView(contact: .mock) { }
    }
    .withErrorHandling()
    .environment(ConnectionHandler.mock)
}
