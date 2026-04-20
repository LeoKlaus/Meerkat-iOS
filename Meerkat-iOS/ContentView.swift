//
//  ContentView.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 29.03.26.
//

import SwiftUI
import EasyErrorHandling

struct ContentView: View {
    
    @EnvironmentObject var errorHandler: ErrorHandler
    @Environment(NavigationHandler.self) var navigationHandler
    @Environment(ConnectionHandler.self) var connectionHandler
    
    var body: some View {
        @Bindable var navigationHandler = self.navigationHandler
        
        TabView(selection: $navigationHandler.currentTab) {
            Tab("Dashboard", systemImage: "text.rectangle.page", value: ContentViewTab.dashboard) {
                DashboardView()
            }
            
            Tab("Contacts", systemImage: "person.crop.circle.fill", value: ContentViewTab.contacts) {
                ContactList()
            }
            
            Tab("Notes", systemImage: "list.clipboard", value: ContentViewTab.notes) {
                NoteList()
            }
            
            Tab("Settings", systemImage: "gear", value: ContentViewTab.settings) {
                SettingsView()
            }
            
            Tab("Search", systemImage: "magnifyingglass", value: ContentViewTab.search, role: .search) {
                ContactList(isSearchContext: true)
            }
        }
        .onOpenURL(perform: self.handleURL)
        //.id(self.connectionHandler?.currentInstance.id)
    }
    
    func handleURL(_ url: URL) {
        self.navigationHandler.handleURL(url, with: self.connectionHandler)
    }
}

#Preview {
    ContentView()
        .withErrorHandling()
        .environment(ConnectionHandler.mock)
        .environment(NavigationHandler.shared)
}
