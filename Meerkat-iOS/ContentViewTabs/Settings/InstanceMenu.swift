//
//  InstanceMenu.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 04.04.26.
//

import SwiftUI
import EasyErrorHandling

struct InstanceMenu: View {
    
    @Environment(ConnectionHandler.self) var connectionHandler
    @EnvironmentObject var errorHandler: ErrorHandler
    
    @AppStorage(.userDefaults(.connectedInstances), store: .meerkat) var connectedInstances: [ConnectedInstance] = []
    @AppStorage(.userDefaults(.activeInstance), store: .meerkat) var activeInstance: ConnectedInstance? = nil
    
    var systemImage: String = "externaldrive.connected.to.line.below"
    
    var body: some View {
        Menu {
            ForEach(connectedInstances) { instance in
                Button {
                    do {
                        try self.connectionHandler.switchInstance(to: instance)
                    } catch {
                        self.errorHandler.handle(error, while: "switching to \(instance.displayName)")
                    }
                } label: {
                    if instance == activeInstance {
                        Label(instance.displayName, systemImage: "checkmark")
                            .labelStyle(.titleAndIcon)
                    } else {
                        Text(instance.displayName)
                    }
                }
                .disabled(activeInstance == instance)
            }
            Divider()
            
            NavigationLink(destination: LoginView(connectionHandler: .constant(self.connectionHandler), isInitialSetup: false)) {
                Label("Add Instance", systemImage: "plus")
            }
        } label: {
            Label(self.activeInstance?.displayName ?? "Switch Instance", systemImage: self.systemImage)
        }
    }
}


#Preview {
    InstanceMenu()
        .withErrorHandling()
        .environment(ConnectionHandler.mock)
}
