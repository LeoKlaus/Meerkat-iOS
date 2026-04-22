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
    
    
    @AppStorage(.userDefaults(.activeInstance), store: .meerkat) var activeInstance: ConnectedInstance? = nil
    
    var body: some View {
        NavigationStack {
            List {
                
                Section {
                    InstanceMenu()
                    NavigationLink(destination: ManageInstancesView()) {
                        Label("Manage Instances", systemImage: "arrow.left.arrow.right.square")
                    }
                    
                    NavigationLink(destination: ServerInfoView()) {
                        Label("Server Information", systemImage: "server.rack")
                    }
                }
                
                Section {
                    NavigationLink(destination: MessengerSettings()) {
                        Label("Configure Messengers", systemImage: "bubble")
                    }
                }
                
                Section("Additional Information") {
                    /*if let appStoreLink = URL(string: "https://itunes.apple.com/app/id6762053843?action=write-review") {
                        Link(destination: appStoreLink, label: {
                            Label {
                                Text("Rate \(Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "Meerkat-iOS") on the AppStore")
                                    .lineLimit(1)
                            } icon: {
                                Image(systemName: "star.bubble")
                                    .foregroundStyle(.tint)
                            }
                        })
                        .foregroundStyle(.primary)
                    }*/
                    
                    NavigationLink (destination: AboutView()) {
                        Label("About \(Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "Meerkat-iOS")", systemImage: "info.circle")
                    }
                    
                    NavigationLink(destination: HelpView()) {
                        Label("Help", systemImage: "questionmark.circle.fill")
                    }
                    
                    ExportLogsButton("Export Debug Logs")
                        .buttonStyle(.plain)
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
