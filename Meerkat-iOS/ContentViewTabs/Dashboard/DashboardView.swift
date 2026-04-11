//
//  DashboardView.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 30.03.26.
//

import SwiftUI
import EasyErrorHandling
import MeerkatAPI

struct DashboardView: View {
    
    @EnvironmentObject var errorHandler: ErrorHandler
    @Environment(ConnectionHandler.self) var connectionHandler
    
    @State private var upcomingBirthdays: [Birthday] = []
    @State private var upcomingReminders: [Reminder] = []
    @State private var randomContacts: [Contact] = []
    
    @State private var doneLoading: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Upcoming Birthdays") {
                    ForEach(self.upcomingBirthdays, id:\.self) { birthday in
                        BirthdayListItem(birthday: birthday)
                            .frame(maxHeight: 40)
                    }
                    
                    if !self.doneLoading && self.upcomingBirthdays.isEmpty {
                        Group {
                            BirthdayListItem(birthday: .placeholder)
                                .frame(maxHeight: 40)
                            BirthdayListItem(birthday: .placeholder)
                                .frame(maxHeight: 40)
                            BirthdayListItem(birthday: .placeholder)
                                .frame(maxHeight: 40)
                        }
                        .redacted(reason: .placeholder)
                        .shimmerEffect()
                    } else if self.upcomingBirthdays.isEmpty {
                        ContentUnavailableView("No upcoming birthdays", systemImage: "birthday.cake.fill")
                    }
                }
                
                Section("Upcoming Reminders") {
                    ForEach(self.upcomingReminders) { reminder in
                        ReminderListItem(reminder: reminder, refreshParent: self.loadDashboard)
                    }
                    
                    if !self.doneLoading && self.upcomingReminders.isEmpty {
                        Group {
                            ReminderListItem(reminder: .mock)
                            ReminderListItem(reminder: .mock2)
                            ReminderListItem(reminder: .mock3)
                        }
                        .redacted(reason: .placeholder)
                        .shimmerEffect()
                    } else if self.upcomingReminders.isEmpty {
                        ContentUnavailableView("No upcoming reminders", systemImage: "bell.fill")
                    }
                }
                
                if !self.randomContacts.isEmpty {
                    Section("Stay in Touch") {
                        ForEach(self.randomContacts.prefix(5)) { contact in
                            // TODO: This is kinda ugly, maybe come up with a better solution
                            PartialContactListItem(contact: contact)
                                .frame(maxHeight: 40)
                        }
                    }
                }
            }
            .throwingTask(taskDescription: "loading dashboard", self.loadDashboard)
            .throwingRefreshable(taskDescription: "reloading dashboard", self.loadDashboard)
            .navigationTitle("Dashboard")
            .navigationDestination(for: Contact.self) { contact in
                ContactDetailView(contact: contact)
            }
        }
    }
    
    private func loadDashboard() async throws {
        async let asyncUpcomingBirthdays = try await self.connectionHandler.getUpcomingBirthdays()
        async let asyncUpcomingReminders = try await self.connectionHandler.getUpcomingReminders()
        async let asyncRandomContacts = try await self.connectionHandler.getRandomContacts()
        
        let upcomingBirthdays = try await asyncUpcomingBirthdays
        let upcomingReminders = try await asyncUpcomingReminders
        let randomContacts = try await asyncRandomContacts
        
        withAnimation {
            self.upcomingBirthdays = upcomingBirthdays
            self.upcomingReminders = upcomingReminders
            self.randomContacts = randomContacts
        }
        withAnimation {
            self.doneLoading = true
        }
    }
}

#Preview {
    DashboardView()
        .withErrorHandling()
        .environment(ConnectionHandler.mock)
}
