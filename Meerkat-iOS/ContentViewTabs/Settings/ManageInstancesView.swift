//
//  ManageInstancesView.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 22.04.26.
//

import SwiftUI
import EasyErrorHandling

struct ManageInstancesView: View {
    
    @Environment(ConnectionHandler.self) var connectionHandler
    @EnvironmentObject var errorHandler: ErrorHandler
    
    @AppStorage(.userDefaults(.connectedInstances), store: .meerkat) var connectedInstances: [ConnectedInstance] = []
    @AppStorage(.userDefaults(.activeInstance), store: .meerkat) var activeInstance: ConnectedInstance? = nil
    
    @State private var showInstanceRemovalAlert: Bool = false
    @State private var instanceToRemove: ConnectedInstance?
    
    var body: some View {
        List {
            ForEach(self.connectedInstances) { instance in
                ConnectedInstanceListItem(instance: instance, showRemovalButton: self.connectedInstances.count > 1) {
                    self.instanceToRemove = instance
                    self.showInstanceRemovalAlert = true
                }
                .alert("Remove \(instanceToRemove?.displayName ?? "Instance")?", isPresented: self.$showInstanceRemovalAlert, presenting: self.instanceToRemove) { instance in
                    Button("Remove", role: .destructive) {
                        self.removeInstance(instance)
                    }
                    
                    Button("Cancel", role: .cancel) {
                        self.instanceToRemove = nil
                        self.showInstanceRemovalAlert = false
                    }
                } message: { connectedInstance in
                    Text("This will only remove this server from the app, your data on the server will not be deleted.")
                }
            }
            
            Section {
                NavigationLink(destination: LoginView(connectionHandler: .constant(self.connectionHandler), isInitialSetup: false)) {
                    Label("Add Instance", systemImage: "plus")
                }
            }
        }
    }
    
    func removeInstance(_ instance: ConnectedInstance) {
        self.connectedInstances.removeAll(where: {
            $0.id == instance.id
        })
        
        if self.activeInstance?.id == instance.id {
            print("Removing active instance, switching...")
            if let nextInstance = self.connectedInstances.first {
                do {
                    try self.connectionHandler.switchInstance(to: nextInstance)
                } catch {
                    self.errorHandler.handle(error, while: "switching instance")
                }
            }
        } else {
            print("Removed inactive instance, nothing to do...")
        }
    }
}

#Preview {
    NavigationStack {
        ManageInstancesView(connectedInstances: [.mock, .mockLongUsername])
    }
    .withErrorHandling()
    .environment(ConnectionHandler.mock)
}
