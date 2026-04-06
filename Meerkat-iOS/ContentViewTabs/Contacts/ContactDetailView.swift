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
                    Text(contact.fullName)
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
                        ReminderListItem(reminder: reminder)
                    }
                }
            case .timeline:
                Section("Timeline") {
                    ForEach(self.timelineEntries.sorted(by: {$0.time ?? .distantPast > $1.time ?? .distantPast}), id: \.uuid) { timelineEntry in
                        TimelineEntryListItem(entry: timelineEntry)
                    }
                }
            }
        }
        .throwingTask(taskDescription: "loading relationships for \(contact.firstname)", self.loadDetails)
        .toolbar {
            
            ToolbarItemGroup(placement: .confirmationAction) {
                Button("Stay in touch", systemImage: "repeat") {
                    // TODO: Implement this
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
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Edit", systemImage: "pencil") {
                    self.supportedMessengers = SupportedMessenger.standard
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    func loadDetails() async throws {
        self.outgoingRelationships = try await self.connectionHandler.apiHandler.getOutgoingRelationships(self.contact)
        self.incomingRelationships = try await self.connectionHandler.apiHandler.getIncomingRelationships(self.contact)
        
        self.reminders = try await self.connectionHandler.apiHandler.getContactReminders(self.contact)
        self.completedReminders = try await self.connectionHandler.apiHandler.getCompletedReminders(for: self.contact)
        
        self.timelineEntries.append(contentsOf: self.completedReminders)
        
        self.notes = try await self.connectionHandler.apiHandler.getContactNotes(self.contact)
        self.timelineEntries.append(contentsOf: self.notes)
        
        self.activities = try await self.connectionHandler.apiHandler.getContactActivities(self.contact)
        
        self.timelineEntries.append(contentsOf: self.activities)
    }
    
    func archiveContact() {
        Task {
            do {
                self.contact = try await self.connectionHandler.apiHandler.archiveContact(self.contact)
            } catch {
                self.errorHandler.handle(error, while: "archiving contact")
            }
        }
    }
    
    func unArchiveContact() {
        Task {
            do {
                self.contact = try await self.connectionHandler.apiHandler.unarchiveContact(self.contact)
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
