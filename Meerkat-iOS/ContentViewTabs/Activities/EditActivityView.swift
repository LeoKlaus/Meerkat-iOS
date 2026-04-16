//
//  EditActivityView.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 16.04.26.
//

import SwiftUI
import MeerkatAPI
import EasyErrorHandling

struct EditActivityView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Environment(ConnectionHandler.self) var connectionHandler
    @EnvironmentObject var errorHandler: ErrorHandler
    
    @State var activity: Activity
    
    let isNewActivity: Bool
    
    @State private var isSaving: Bool = false
    
    init(prefilledContacts: [Contact] = []) {
        self.activity = .empty(with: prefilledContacts)
        self.isNewActivity = true
    }
    
    init(activity: Activity) {
        self.activity = activity
        self.isNewActivity = false
    }
    
    var body: some View {
        List {
            Section {
                TextField("Title", text: self.$activity.title)
                
                MultiLineTextField(
                    "Description",
                    text: Binding {
                        self.activity.description ?? ""
                    } set: { newValue in
                        if newValue.isEmpty {
                            self.activity.description = nil
                        } else {
                            self.activity.description = newValue
                        }
                    }
                )
                DatePicker("Date: ", selection: self.$activity.date, displayedComponents: [.date])
            }
            
            Section("Location") {
                NullableTextField("Location", text: self.$activity.location)
            }

            
            Section("Contacts") {
                NavigationLink(destination: SelectContactsView(selectedContacts: self.$activity.contacts)) {
                    if let contacts = activity.contacts, !contacts.isEmpty {
                        Text(contacts.map(\.firstAndLastName).joined(separator: ", "))
                    } else {
                        Text("No contacts")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            Section {
                Button(action: self.saveActivity) {
                    if self.isSaving {
                        ProgressView()
                    } else {
                        Text("Save")
                    }
                }
                .disabled(self.activity.title.isEmpty || self.isSaving)
                
                Button("Cancel", role: .destructive) {
                    self.dismiss()
                }
            }
        }
    }
    
    func saveActivity() {
        withAnimation {
            self.isSaving = true
        }
        Task {
            do {
                if self.isNewActivity {
                    _ = try await self.connectionHandler.createActivity(self.activity)
                } else {
                    _ = try await self.connectionHandler.updateActivity(self.activity)
                }
                self.errorHandler.showInfo(self.isNewActivity ? "Activity created!" : "Activity saved!")
                
                self.dismiss()
            } catch {
                self.errorHandler.handle(error, while: "saving activity")
            }
            
            withAnimation {
                self.isSaving = false
            }
        }
    }
}

#Preview {
    NavigationStack {
        EditActivityView(activity: .mock)
    }
    .withErrorHandling()
    .environment(ConnectionHandler.mock)
}


#Preview("No Description") {
    NavigationStack {
        EditActivityView(
            activity: Activity(
                id: 4,
                createdAt: .now,
                title: "Some short name",
                date: .now
            )
        )
    }
    .withErrorHandling()
    .environment(ConnectionHandler.mock)
}
