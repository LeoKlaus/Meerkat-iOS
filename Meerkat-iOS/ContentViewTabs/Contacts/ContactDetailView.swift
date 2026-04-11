//
//  ContactDetailView.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 03.04.26.
//

import SwiftUI
import MeerkatAPI
import EasyErrorHandling
import Flow

enum ContactDetailViewTab {
    case about
    case relationships
    case timeline
    case reminders
}

struct ContactDetailView: View {
    
    @Environment(ConnectionHandler.self) var connectionHandler
    @EnvironmentObject var errorHandler: ErrorHandler
    
    @AppStorage(.userDefaults(.supportedMessengers), store: .meerkat) var supportedMessengers: [SupportedMessenger] = SupportedMessenger.standard
    
    @State var contact: Contact
    
    @State private var currentTab: ContactDetailViewTab = .about
    
    @State private var incomingRelationships: [Relationship] = []
    @State private var outgoingRelationships: [Relationship] = []
    
    @State private var notes: [Note] = []
    @State private var reminders: [Reminder] = []
    @State private var completedReminders: [ReminderCompletion] = []
    @State private var activities: [Activity] = []
    
    @State private var timelineEntries: [any TimelineEntry] = []
    
    @State private var showArchivalConfirmation: Bool = false
    
    @State private var reminderToAdd: Reminder? = nil
    
    @State private var isEditing: Bool = false
    
    var contactHeader: some View {
        Group {
            if self.contact.archived {
                Label("Archived", systemImage: "tray.and.arrow.down")
                    .font(.caption)
                    .foregroundStyle(.white)
                    .padding(10)
                    .background(.orange)
                    .clipShape(.capsule)
            }
            HStack {
                ContactImage(contact: self.contact)
                    .clipShape(Circle())
                    .frame(maxWidth: 75)
                
                VStack(alignment: .leading) {
                    Text(contact.displayName)
                        .font(.title)
                    if let gender = contact.gender {
                        Text(gender.localizedRepresentation)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            HFlow {
                ForEach(self.contact.circles ?? [], id: \.self) { circle in
                    CircleItem(circle: circle)
                }
                
                if (self.contact.circles?.isEmpty ?? true) {
                    Spacer()
                }
            }
        }
    }
    
    var messengerList: some View {
        HFlow {
            if let phone = contact.phone, !phone.isEmpty {
                if let url = URL(string: "tel:\(phone)") {
                    Link(destination: url) {
                        Image(systemName: "phone")
                            .frame(width: 30, height: 20)
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                if let url = URL(string: "sms:\(phone)") {
                    Link(destination: url) {
                        Image(systemName: "message")
                            .frame(maxWidth: 30, maxHeight: 20)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            
            if let email = contact.email, !email.isEmpty {
                if let url = URL(string: "mailto:\(email)") {
                    Link(destination: url) {
                        Image(systemName: "envelope")
                            .frame(maxWidth: 30, maxHeight: 20)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            
            ForEach(self.contact.getMatchingMessengers(self.supportedMessengers)) { messengerLink in
                
                if let url = messengerLink.url {
                    Link(destination: url) {
                        if let imageData = messengerLink.messenger.imageData, let img = Image(data: imageData) {
                            img
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 30, maxHeight: 20)
                        } else {
                            Text(messengerLink.messenger.name)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(messengerLink.messenger.color)
                }
            }
        }
    }
    
    var body: some View {
        Group {
            if self.isEditing {
                EditContactView(contact: self.contact) {
                    withAnimation {
                        self.isEditing = false
                    }
                    
                    let updatedContact = try await self.connectionHandler.getContact(id: self.contact.id)
                    
                    withAnimation {
                        self.contact = updatedContact
                    }
                }
            } else {
                List {
                    Section {
                        VStack(alignment: .leading) {
                            self.contactHeader
                            
                            self.messengerList
                            
                            Picker("About", selection: self.$currentTab) {
                                Label("About", systemImage: "house")
                                    .tag(ContactDetailViewTab.about)
                                    .labelStyle(.iconOnly)
                                
                                Label("Relationships", systemImage: "point.3.connected.trianglepath.dotted")
                                    .tag(ContactDetailViewTab.relationships)
                                    .labelStyle(.iconOnly)
                                
                                Label("Timeline", systemImage: "calendar.day.timeline.left")
                                    .tag(ContactDetailViewTab.timeline)
                                    .labelStyle(.iconOnly)
                                
                                Label("Reminders", systemImage: "bell")
                                    .tag(ContactDetailViewTab.reminders)
                                    .labelStyle(.iconOnly)
                            }
                            .padding(.top)
                            .pickerStyle(.segmented)
                        }
                        
                    }
                    
                    switch self.currentTab {
                    case .about:
                        ContactDetailAboutSection(contact: self.contact)
                    case .relationships:
                        Section("Relationships") {
                            ForEach(self.outgoingRelationships) { relationship in
                                RelationShipListItem(relationShip: relationship)
                            }
                        }
                        
                        if !self.incomingRelationships.isEmpty {
                            Section("Incoming Relationships") {
                                ForEach(self.incomingRelationships) { relationship in
                                    RelationShipListItem(relationShip: relationship, isIncoming: true)
                                }
                            }
                        }
                    case .reminders:
                        Section("Reminders") {
                            ForEach(self.reminders) { reminder in
                                ReminderListItem(reminder: reminder, refreshParent: self.loadDetails)
                            }
                        }
                        Button("Add reminder", systemImage: "plus") {
                            self.reminderToAdd = .empty
                        }
                    case .timeline:
                        Section("Timeline") {
                            ForEach(self.timelineEntries.sorted(by: {$0.time ?? .distantPast > $1.time ?? .distantPast}), id: \.uuid) { timelineEntry in
                                TimelineEntryListItem(entry: timelineEntry)
                            }
                        }
                    }
                }
            }
        }
        .sheet(item: self.$reminderToAdd, onDismiss: self.loadDetailsWrapped) { reminder in
            EditReminderView(contactId: self.contact.id, reminder: reminder, isNewReminder: true)
        }
        .throwingTask(taskDescription: "loading details for \(contact.firstname)", self.loadDetails)
        .throwingRefreshable(taskDescription: "reloading details for \(contact.firstname)", self.loadDetails)
        .toolbar {
            if !self.isEditing {
                ToolbarItemGroup(placement: .confirmationAction) {
                    Button("Stay in touch", systemImage: "repeat") {
                        let stayInTouchSuggestion = Reminder(
                            id: 0,
                            createdAt: .now,
                            message: String(localized: "Catch-up with \(self.contact.firstAndLastName)"),
                            byMail: true,
                            remindAt: Calendar.current.date(byAdding: .month, value: 3, to: Date()) ?? .now,
                            recurrence: .quarterly,
                            reoccurFromCompletion: true,
                            completed: false,
                            emailSent: false,
                            contactId: self.contact.id
                        )
                        self.reminderToAdd = stayInTouchSuggestion
                    }
                    
                    if self.contact.archived {
                        Button("Unarchive \(self.contact.firstname)", systemImage: "tray.and.arrow.up", role: .destructive) {
                            self.unArchiveContact()
                        }
                    } else {
                        Button("Archive \(self.contact.firstname)", systemImage: "tray.and.arrow.down", role: .destructive) {
                            self.showArchivalConfirmation = true
                        }
                        .tint(.orange)
                        .confirmationDialog("Archive \(self.contact.firstname)?", isPresented: self.$showArchivalConfirmation) {
                            Button("Yes", role: .destructive) {
                                self.archiveContact()
                            }
                            Button("Cancel", role: .cancel) {
                                self.showArchivalConfirmation = false
                            }
                        } message: {
                            Text("Are you sure you want to archive this contact? All reminders will be deleted. You can unarchive later, but reminders won't be restored.")
                        }
                    }
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                /*if self.isEditing {
                    Button("Done", systemImage: "checkmark") {
                        Task {
                            do {
                                let updated = try await self.connectionHandler.updateContact(self.contact)
                                
                                withAnimation {
                                    self.contact = updated
                                    self.isEditing = false
                                }
                            } catch {
                                self.errorHandler.handle(error, while: "updating \(self.contact.firstname)")
                            }
                        }
                    }
                 } else*/ if !self.isEditing {
                    Button("Edit", systemImage: "pencil") {
                        withAnimation {
                            self.isEditing = true
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    func loadDetails() async throws {
        async let outgoingRelationships = try await self.connectionHandler.getOutgoingRelationships(self.contact)
        async let incomingRelationships = try await self.connectionHandler.getIncomingRelationships(self.contact)
        
        
        async let reminders = try await self.connectionHandler.getContactReminders(self.contact)
        async let completedReminders = try await self.connectionHandler.getCompletedReminders(for: self.contact)
        
        
        async let notes = try await self.connectionHandler.getContactNotes(self.contact)
        
        async let activities = try await self.connectionHandler.getContactActivities(self.contact)
        
        self.outgoingRelationships = try await outgoingRelationships
        self.incomingRelationships = try await incomingRelationships
        self.reminders = try await reminders
        self.completedReminders = try await completedReminders
        self.notes = try await notes
        self.activities = try await activities
        
        self.timelineEntries = self.notes + self.completedReminders + self.activities
    }
    
    func loadDetailsWrapped() {
        Task {
            do {
                try await self.loadDetails()
            } catch {
                self.errorHandler.handle(error, while: "reloading details for \(contact.firstname)")
            }
        }
    }
    
    func archiveContact() {
        Task {
            do {
                let contact = try await self.connectionHandler.archiveContact(self.contact)
                
                withAnimation {
                    self.contact = contact
                }
            } catch {
                self.errorHandler.handle(error, while: "archiving contact")
            }
        }
    }
    
    func unArchiveContact() {
        Task {
            do {
                let contact = try await self.connectionHandler.unarchiveContact(self.contact)
                
                withAnimation {
                    self.contact = contact
                }
            } catch {
                self.errorHandler.handle(error, while: "archiving contact")
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
