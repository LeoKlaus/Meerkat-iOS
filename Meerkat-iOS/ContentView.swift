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
            
            Tab("Notes", systemImage: "list.clipboard") {
                NoteList()
            }
            
            Tab("Settings", systemImage: "gear") {
                SettingsView()
            }
            
            Tab("Search", systemImage: "magnifyingglass", role: .search) {
                ContactList(isSearchContext: true)
            }
        }
        //.id(self.connectionHandler?.currentInstance.id)
    }
}

#Preview {
    ContentView()
        .withErrorHandling()
        .environment(ConnectionHandler.mock)
}
