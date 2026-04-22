//
//  Meerkat_iOSApp.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 29.03.26.
//

import SwiftUI
import EasyErrorHandling

@main
struct Meerkat_iOSApp: App {
    
    @AppStorage(.userDefaults(.colorScheme), store: .meerkat) var colorScheme: StorableColorScheme = .system
    
    @State private var connectionHandler: ConnectionHandler? = ConnectionHandler()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if let connectionHandler {
                    ContentView()
                        .environment(connectionHandler)
                        .environment(NavigationHandler.shared)
                } else {
                    LoginView(connectionHandler: self.$connectionHandler)
                }
            }
            .preferredColorScheme(colorScheme.colorScheme)
            .customTint()
            .withErrorHandling(onTap: self.handleErrorToast)
        }
    }
    
    func handleErrorToast(_ toast: ErrorToast) {
        print(toast.errorDescription)
    }
}
