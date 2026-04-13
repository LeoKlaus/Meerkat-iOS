//
//  EditContactCustomFieldsSection.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 12.04.26.
//

import SwiftUI
import MeerkatAPI
import EasyErrorHandling

struct EditContactCustomFieldsSection: View {
    
    @Environment(ConnectionHandler.self) var connectionHandler
    @EnvironmentObject var errorHandler: ErrorHandler
    
    @AppStorage(.userDefaults(.supportedMessengers), store: .meerkat) var supportedMessengers: [SupportedMessenger] = SupportedMessenger.standard
    
    @Binding var contact: Contact
    
    var nonMessengerFields: [String] {
        self.connectionHandler.customFields.filter { key in
            !self.supportedMessengers.map{ $0.fieldId }.contains(key)
        }
    }
    
    @State private var showAddFieldAlert: Bool = false
    @State private var newFieldName: String = ""
    
    var body: some View {
        Section("Custom Fields") {
            ForEach(self.nonMessengerFields, id: \.self) { fieldName in
                TextField(
                    fieldName,
                    text: Binding(
                        get: {
                            self.contact.customFields?[fieldName] ?? ""
                        },
                        set: { newValue in
                            if newValue.isEmpty {
                                self.contact.customFields?.removeValue(forKey: fieldName)
                            } else {
                                if self.contact.customFields == nil {
                                    self.contact.customFields = [:]
                                }
                                self.contact.customFields?[fieldName] = newValue
                            }
                        }
                    )
                )
            }
            Button("Create Custom Field", systemImage: "plus") {
                self.showAddFieldAlert = true
            }
        }
        .alert("Create a Custom Field", isPresented: self.$showAddFieldAlert) {
            TextField("Field Name", text: self.$newFieldName)
                .onSubmit {
                    if !self.newFieldName.isEmpty {
                        self.addField()
                    }
                }
            Button("Cancel", role: .cancel) {
                self.showAddFieldAlert = false
                self.newFieldName = ""
            }
            Button("OK", action: self.addField)
                .disabled(self.newFieldName.isEmpty)
        }
    }
    
    func addField() {
        Task {
            do {
                try await self.connectionHandler.getCustomFields()
                var currentFields = self.connectionHandler.customFields
                currentFields.append(newFieldName)
                try await self.connectionHandler.updateCustomFields(CustomFields(customFieldNames: currentFields))
                if var customFields = contact.customFields {
                    customFields[newFieldName] = ""
                } else {
                    self.contact.customFields = [newFieldName:""]
                }
                self.newFieldName = ""
            } catch {
                self.errorHandler.handle(error, while: "creating custom field")
            }
        }
    }
}

#Preview {
    @Previewable @State var contact: Contact = .mock
    
    List {
        EditContactCustomFieldsSection(contact: $contact)
    }
    .environment(ConnectionHandler.mock)
    .withErrorHandling()
}
