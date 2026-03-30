//
//  ContentView.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 29.03.26.
//

import SwiftUI
import EasyErrorHandling

struct ContentView: View {
    
    @State private var connectionHandler: ConnectionHandler?
    
    var body: some View {
        TabView {
            Tab("Dashboard", systemImage: "text.rectangle.page") {
                DashboardView()
            }
            
            Tab("Contacts", systemImage: "person.crop.circle.fill") {
                ContactList()
            }
            
            Tab("Activities", systemImage: "calendar") {
                ActivityList()
            }
            
            Tab("Notes", systemImage: "list.clipboard") {
                NoteList()
            }
            
            Tab("Settings", systemImage: "gear") {
                SettingsView()
            }
        }
    }
}

#Preview {
    ContentView()
        .withErrorHandling()
        .environment(ConnectionHandler.mock)
}
