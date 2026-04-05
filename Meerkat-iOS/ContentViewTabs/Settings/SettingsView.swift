//
//  SettingsView.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 30.03.26.
//

import SwiftUI
import EasyErrorHandling
import MeerkatAPI

struct SettingsView: View {
    
    @Environment(ConnectionHandler.self) var connectionHandler
    @EnvironmentObject var errorHandler: ErrorHandler
    
    var body: some View {
        NavigationStack {
            List {
                InstanceMenu()
                
                Button("Log out") {
                    Task {
                        do {
                            try await self.connectionHandler.apiHandler.logout()
                        } catch {
                            self.errorHandler.handle(error, while: "logging out")
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
        .withErrorHandling()
        .environment(ConnectionHandler.mock)
}
