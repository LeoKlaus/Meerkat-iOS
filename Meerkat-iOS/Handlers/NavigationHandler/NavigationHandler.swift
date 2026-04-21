//
//  NavigationHandler.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 20.04.26.
//

import Foundation
import SwiftUI
import OSLog
import EasyErrorHandling

@Observable
class NavigationHandler {
    
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: NavigationHandler.self)
    )
    
    static let shared = NavigationHandler()
    
    var currentTab: ContentViewTab = .dashboard
    
    var dashboardTabPath: NavigationPath = NavigationPath()
    var contactsTabPath: NavigationPath = NavigationPath()
    var notesTabPath: NavigationPath = NavigationPath()
    
    init() {
        
    }
    
    func handleURL(_ url: URL, with connectionHandler: ConnectionHandler) {
        Self.logger.debug("Handling URL: \(url.absoluteString)")
        guard url.scheme == "meerkat" else {
            ErrorHandler.shared.handle("Unsupported URL scheme: \(url.scheme ?? url.absoluteString)", while: "opening through URL")
            return
        }
        
        switch url.host() {
        case "contact":
            let components = url.pathComponents
            guard components.count > 1 else {
                ErrorHandler.shared.handle("URL is missing contact ID", while: "opening through URL")
                return
            }
            if let id = Int(components[1]) {
                withAnimation {
                    self.currentTab = .contacts
                    self.contactsTabPath.append(id)
                }
            } else {
                ErrorHandler.shared.handle("Contact ID seems malformed: \(components[1])", while: "opening through URL")
            }
        // TODO: Build reminder detail view and support this?
        /*case "reminder":
            let components = url.pathComponents
            guard components.count > 1 else {
                ErrorHandler.shared.handle("URL is missing reminder ID", while: "opening through URL")
                return
            }
            
            
            if let id = Int(components[1]) {
                Task {
                    do {
                        let reminder = try await connectionHandler.getReminder(id)
                        withAnimation {
                            self.currentTab = .dashboard
                            self.dashboardTabPath.append(reminder)
                        }
                    } catch {
                        ErrorHandler.shared.handle(error, while: "loading reminder")
                    }
                }
            } else {
                ErrorHandler.shared.handle("Reminder ID seems malformed: \(components[1])", while: "opening through URL")
            }*/
        default:
            ErrorHandler.shared.handle("Unsupported URL path \(url.absoluteString)", while: "opening through URL")
        }
    }
}
