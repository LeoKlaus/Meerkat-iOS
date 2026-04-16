//
//  ActivityDetailView.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 03.04.26.
//

import SwiftUI
import MeerkatAPI
import EasyErrorHandling

struct ActivityDetailView: View {
    
    let activity: Activity
    
    var body: some View {
        List {
            if let description = activity.description {
                Text(description)
                    .multilineTextAlignment(.leading)
            } else {
                Text("No description")
                    .foregroundStyle(.secondary)
            }
            
            Section("Location") {
                if let location = activity.location {
                    Text(location)
                        .multilineTextAlignment(.leading)
                } else {
                    Text("No location")
                        .foregroundStyle(.secondary)
                }
            }
            
            Section("Date") {
                Text(activity.date, style: .date)
            }
            
            Section("Contacts") {
                if let contacts = activity.contacts {
                    Text(contacts.map(\.firstAndLastName).joined(separator: ", "))
                } else {
                    Text("No contacts")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle(self.activity.title)
    }
}

#Preview {
    NavigationStack {
        ActivityDetailView(activity: .mock)
    }
    .withErrorHandling()
    .environment(ConnectionHandler.mock)
}


#Preview("No Description") {
    NavigationStack {
        ActivityDetailView(
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
