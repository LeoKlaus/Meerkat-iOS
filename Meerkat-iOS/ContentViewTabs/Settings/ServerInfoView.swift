//
//  ServerInfoView.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 22.04.26.
//

import SwiftUI
import EasyErrorHandling
import MeerkatAPI

struct ServerInfoView: View {
    
    @EnvironmentObject var errorHandler: ErrorHandler
    @Environment(ConnectionHandler.self) var connectionHandler
    
    @State var hasTriedLoad: Bool = false
    @State var serverInfo: HealthStatus?
    
    var body: some View {
        List {
            if let serverInfo {
                Section {
                    HStack {
                        Label("Version: ", systemImage: "clock.arrow.trianglehead.2.counterclockwise.rotate.90")
                        Spacer()
                        Text(serverInfo.version)
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Label("Status: ", systemImage: "heart")
                        Spacer()
                        Text(serverInfo.status.localizedRepresentation)
                            .foregroundStyle(serverInfo.status == .healthy ? .green.mix(with: .secondary, by: 0.25) : .red.mix(with: .secondary, by: 0.25))
                    }
                } footer: {
                    HStack {
                        Spacer()
                        Text("\(serverInfo.timestamp, style: .relative) ago")
                    }
                }
                
                Section("Database") {
                    HStack {
                        Label("Response Time", systemImage: "timer")
                        Spacer()
                        Text("\(serverInfo.database.responseTimeMs)ms")
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Label("Status: ", systemImage: "heart")
                        Spacer()
                        Text(serverInfo.database.status.localizedRepresentation)
                            .foregroundStyle(serverInfo.database.status == .healthy ? .green.mix(with: .secondary, by: 0.25) : .red.mix(with: .secondary, by: 0.25))
                    }
                }
                
            } else if self.hasTriedLoad {
                ContentUnavailableView("Couldn't get server health status", systemImage: "exclamationmark.triangle.fill")
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .listRowBackground(EmptyView())
                    .task(self.getServerStatus)
            }
        }
        .navigationTitle("Server Status")
        .throwingRefreshable(taskDescription: "reloading health status", self.getServerStatus)
    }
    
    func getServerStatus() async {
        do {
            let status = try await self.connectionHandler.checkHealth()
            withAnimation {
                self.serverInfo = status
            }
        } catch {
            self.errorHandler.handle(error, while: "getting server health status")
        }
        self.hasTriedLoad = true
    }
}

#Preview {
    NavigationStack {
        ServerInfoView()
    }
    .withErrorHandling()
    .environment(ConnectionHandler.mock)
}

#Preview("Unhealthy") {
    NavigationStack {
        ServerInfoView(serverInfo: .mockUnhealthy)
    }
    .withErrorHandling()
    .environment(ConnectionHandler.mock)
}
