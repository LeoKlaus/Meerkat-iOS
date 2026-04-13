//
//  ReminderListItem.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 03.04.26.
//

import SwiftUI
import MeerkatAPI
import EasyErrorHandling

struct ReminderListItem: View {
    
    @Environment(ConnectionHandler.self) var connectionHandler
    @EnvironmentObject var errorHandler: ErrorHandler
    
    @State var reminder: Reminder
    @State private var associatedContact: Contact?
    
    var isPlaceholder: Bool = false
    
    @State private var showEditSheet: Bool = false
    
    var refreshParent: () async throws -> Void = { }
    
    var body: some View {
        Menu {
            Button("Mark as completed", systemImage: "checkmark", action: self.markCompleted)
            
            Button("Skip", systemImage: "arrow.right.to.line", action: self.skip)
            
            if let contact = self.associatedContact {
                NavigationLink(value: contact) {
                    Label("View \(contact.firstname)",systemImage: "person")
                }
            }
            
            Divider()
            
            Button("Edit", systemImage: "pencil") {
                self.showEditSheet = true
            }
            
            Button("Delete", systemImage: "trash", role: .destructive, action: self.deleteReminder)
            
        } label: {
            VStack(alignment: .leading) {
                Text(self.reminder.message)
                    .multilineTextAlignment(.leading)
                HStack {
                    Text(self.reminder.remindAt, style: .date)
                    
                    if self.reminder.byMail {
                        Image(systemName: "envelope")
                    }
                    
                    ReminderRecurrenceItem(reminder: self.reminder)
                    
                    if self.reminder.reoccurFromCompletion {
                        Text("Flexible")
                            .padding(.horizontal, 10)
                            .foregroundStyle(.tint)
                            .overlay(
                                RoundedRectangle(cornerRadius: .infinity)
                                    .stroke(.tertiary)
                            )
                    }
                    Spacer()
                }
                .foregroundStyle(.secondary)
                .font(.caption)
            }
            .contentShape(.rect)
        }
        .foregroundStyle(.primary)
        .sheet(isPresented: self.$showEditSheet, onDismiss: self.reloadReminder) {
            EditReminderView(contactId: self.reminder.contactId, reminder: self.reminder)
        }
        .throwingTask(taskDescription: "loading associated contact for reminder \(self.reminder.message)", self.loadAssociatedContact)
    }
    
    private func loadAssociatedContact() async throws {
        if self.isPlaceholder {
            return
        }
        let contact = try await self.connectionHandler.getContact(id: self.reminder.contactId)
        withAnimation {
            self.associatedContact = contact
        }
    }
    
    private func reloadReminder() {
        Task {
            do {
                let reminder = try await self.connectionHandler.getReminder(self.reminder.id)
                withAnimation {
                    self.reminder = reminder
                }
            } catch {
                self.errorHandler.handle(error, while: "reloading reminder \(self.reminder.id)")
            }
        }
    }
    
    private func markCompleted() {
        Task {
            do {
                try await self.connectionHandler.completeReminder(self.reminder)
                try await self.refreshParent()
            } catch {
                self.errorHandler.handle(error, while: "marking reminder \(self.reminder.id) as completed")
            }
        }
    }
    
    private func skip() {
        Task {
            do {
                try await self.connectionHandler.completeReminder(self.reminder)
                try await self.refreshParent()
            } catch {
                self.errorHandler.handle(error, while: "skipping reminder \(self.reminder.id)")
            }
        }
    }
    
    private func deleteReminder() {
        Task {
            do {
                try await self.connectionHandler.deleteReminder(self.reminder)
                try await self.refreshParent()
            } catch {
                self.errorHandler.handle(error, while: "deleting reminder \(self.reminder.id)")
            }
        }
    }
}

#Preview {
    List {
        ReminderListItem(reminder: .mock2) {
            
        }
    }
    .withErrorHandling()
    .environment(ConnectionHandler.mock)
}
