//
//  AsyncContactDetailView.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 20.04.26.
//

import SwiftUI
import MeerkatAPI
import EasyErrorHandling

struct AsyncContactDetailView: View {

    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var errorHandler: ErrorHandler
    @Environment(ConnectionHandler.self) var connectionHandler
    
    let contactId: Int
    @State private var loadedContact: Contact?
    
    @State private var loadingFailed: Bool = false
    
    var body: some View {
        if let loadedContact {
            ContactDetailView(contact: loadedContact)
        } else if loadingFailed {
            ContentUnavailableView {
                Label("Couldn't load contact with ID \(self.contactId)", systemImage: "exclamationmark.triangle")
            } actions: {
                Button("Go back") {
                    self.dismiss()
                }
                .glassProminentButtonStyleIfAvailable()
            }
        } else {
            VStack {
                ProgressView()
                Text("Loading contact...")
                    .foregroundStyle(.secondary)
            }
            .throwingTask(taskDescription: "loading contact \(contactId)") {
                do {
                    let contact = try await self.connectionHandler.getContact(id: self.contactId)
                    withAnimation {
                        self.loadedContact = contact
                    }
                } catch {
                    withAnimation {
                        self.loadingFailed = true
                    }
                    throw error
                }
            }
        }
    }
}

#Preview("Regular") {
    AsyncContactDetailView(contactId: 1)
        .withErrorHandling()
        .environment(ConnectionHandler.mock)
}

#Preview("Failure") {
    AsyncContactDetailView(contactId: 10)
        .withErrorHandling()
        .environment(ConnectionHandler.mock)
}
