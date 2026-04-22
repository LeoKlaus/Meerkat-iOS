//
//  SendMailButton.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 22.04.26.
//


import SwiftUI
import EasyErrorHandling
#if canImport(MessageUI)
import MessageUI
import MeerkatAPI
#endif

struct SendMailButton: View {
    
    @Environment(ConnectionHandler.self) var connectionHandler
    @EnvironmentObject var errorHandler: ErrorHandler
    
    @State private var gatheringInfo: Bool = false
    @State private var showMailSelection: Bool = false
    @State private var showServerLogDialog: Bool = false
    
    @State private var showMailView: Bool = false
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    
    @State private var serverVersion: String?
    @State private var debugLogs: [String] = []
    @State private var serverLogs: [String] = []
    
    var forceIncludeLogs: Bool = false
    
    func gatherDebugInfo(includeDebugLogs: Bool = false) {
        withAnimation {
            self.gatheringInfo = true
        }
        
        self.serverVersion = nil
        self.debugLogs = []
        
        Task {
            self.serverVersion = try? await self.connectionHandler.checkHealth().version
            
            if includeDebugLogs {
                do {
                    self.debugLogs = try self.errorHandler.exportLogs()
                } catch {
                    self.errorHandler.handle(error, while: "exporting debug logs")
                }
            }
            
            withAnimation {
                self.gatheringInfo = false
            }
            
            #if canImport(MessageUI)
            if MFMailComposeViewController.canSendMail() {
                self.showMailView = true
            } else {
                self.errorHandler.handle("Couldn't open mail view", while: "preparing mail", blockUserInteraction: true)
            }
            #else
            self.sendMail()
            #endif
        }
    }
    
    #if os(macOS)
    func sendMail() {
        let sharingService = NSSharingService(named: NSSharingService.Name.composeEmail)
        
        sharingService?.recipients = ["contact@wehrfritz.me"]
        
        var body: String = ""
        
        if let appVersion {
            body += " \n\n\(Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "Meerkat-iOS") Version:\t\(appVersion) (\(build ?? "Unknown"), macOS)\n"
        }
        
        if let serverVersion {
            body += " Meerkat Version:\t\(serverVersion)\n"
        }
        
        var fileURLs: [URL] = []
        
        do {
            if !debugLogs.isEmpty, let data = debugLogs.joined(separator: "\n").data(using: .utf8) {
                fileURLs.append(try data.toTempFile(fileName: "logs.txt"))
            }
        } catch {
            self.errorHandler.handle(error, while: "attaching files", blockUserInteraction: false)
        }
        
        sharingService?.perform(withItems: [body] + fileURLs)
    }
    #endif
    
    var body: some View {
        Button {
            if forceIncludeLogs {
                self.gatherDebugInfo(includeDebugLogs: true)
            } else {
                self.showMailSelection = true
            }
        } label: {
            if gatheringInfo {
                Label {
                    Text("Gathering Debug Info")
                } icon: {
                    ProgressView()
                }
            } else {
                Label("Send an email", systemImage: "paperplane")
            }
        }
        .buttonStyle(.plain)
        .foregroundStyle(.primary)
        .disabled(self.gatheringInfo)
        .confirmationDialog("Do you want to include debug logs from \(Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "Meerkat-iOS")?", isPresented: $showMailSelection, titleVisibility: .visible) {
            Button("Yes") {
                self.gatherDebugInfo(includeDebugLogs: true)
            }
            Button("No") {
                self.gatherDebugInfo(includeDebugLogs: false)
            }
        } message: {
            Text("Warning: Logs may contain personal information like names of contacts")
        }
        #if canImport(MessageUI)
        .sheet(isPresented: $showMailView) {
            MailView(appVersion: self.appVersion, build: self.build, serverVersion: self.serverVersion, logs: self.debugLogs)
        }
        #endif
    }
}

#Preview {
    HelpView()
        .withErrorHandling()
}
