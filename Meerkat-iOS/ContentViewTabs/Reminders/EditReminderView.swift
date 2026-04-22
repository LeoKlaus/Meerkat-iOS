//
//  EditReminderView.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 07.04.26.
//

import SwiftUI
import MeerkatAPI
import EasyErrorHandling

struct EditReminderView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Environment(ConnectionHandler.self) var connectionHandler
    @EnvironmentObject var errorHandler: ErrorHandler
    
    @State private var reminder: Reminder
    
    @State var contact: Contact?
    let isNewReminder: Bool
    
    @State private var isSaving: Bool = false
    
    @FocusState var isTextFieldFocused
    
    init(contact: Contact? = nil) {
        self.reminder = Reminder.empty
        self.contact = contact
        self.isNewReminder = true
    }
    
    init(contact: Contact? = nil, reminder: Reminder, isNewReminder: Bool = false) {
        self.reminder = reminder
        self.contact = contact
        self.isNewReminder = isNewReminder
    }
    
    var body: some View {
        List {
            MultiLineTextField("Message", text: self.$reminder.message)
            
            Picker("Recurrence", selection: self.$reminder.recurrence) {
                Text("Once").tag(ReminderRecurrence.once)
                Text("Weekly").tag(ReminderRecurrence.weekly)
                Text("Monthly").tag(ReminderRecurrence.monthly)
                Text("Quarterly").tag(ReminderRecurrence.quarterly)
                Text("Every six months").tag(ReminderRecurrence.sixMonths)
                Text("Yearly").tag(ReminderRecurrence.yearly)
            }
            
            DatePicker("Date", selection: self.$reminder.remindAt, displayedComponents: [.date])
            
            if self.isNewReminder {
                NavigationLink(destination:  SelectContactsView(selectedContact: self.$contact)){
                    if let contact {
                        Text(contact.firstAndLastName)
                    } else {
                        Text("Select")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            if self.reminder.recurrence != .once {
                Section {
                    Toggle("Reschedule from completion date", isOn: self.$reminder.reoccurFromCompletion)
                }
            }
            
            Section {
                Toggle("Send email notification", isOn: self.$reminder.byMail)
            }
            
            Button(action: self.save) {
                if self.isSaving {
                    ProgressView()
                } else {
                    Text("Save")
                }
            }
            .disabled(self.reminder.message.isEmpty || self.isSaving || self.contact == nil)
            
            Button("Cancel", role: .destructive) {
                self.dismiss()
            }
        }
    }
    
    func save() {
        guard let contact else {
            self.errorHandler.handle("Select a contact first", while: "saving reminder")
            return
        }
        
        withAnimation {
            self.isSaving = true
        }
        Task {
            do {
                if self.isNewReminder {
                    _ = try await self.connectionHandler.createContactReminder(contactId: contact.id, reminder: self.reminder)
                } else {
                    _ = try await self.connectionHandler.updateReminder(self.reminder)
                }
                self.errorHandler.showInfo(self.isNewReminder ? "Reminder created!" : "Reminder saved!")
                self.dismiss()
            } catch {
                self.errorHandler.handle(error, while: "saving reminder")
            }
            
            withAnimation {
                self.isSaving = false
            }
        }
    }
}

#Preview("New Reminder") {
    NavigationStack {
        EditReminderView()
    }
    .withErrorHandling()
    .environment(ConnectionHandler.mock)
}

#Preview("New Reminder (with preselected contact)") {
    NavigationStack {
        EditReminderView(contact: .mock)
    }
    .withErrorHandling()
    .environment(ConnectionHandler.mock)
}

#Preview("Existing Reminder") {
    NavigationStack {
        EditReminderView(contact: .mock, reminder: .mock2)
    }
    .withErrorHandling()
    .environment(ConnectionHandler.mock)
}
