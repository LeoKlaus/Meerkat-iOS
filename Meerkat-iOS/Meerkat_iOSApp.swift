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
    @AppStorage(.userDefaults(.globalAccentColor), store: .meerkat) var globalAccentColor: StorableAccentColor? = nil
    @AppStorage(.userDefaults(.activeInstance), store: .meerkat) var activeInstance: ConnectedInstance? = nil
    @AppStorage(.userDefaults(.usePerInstanceAccentColors), store: .meerkat) var usePerInstanceAccentColors: Bool = false
    
    @State private var connectionHandler: ConnectionHandler? = ConnectionHandler()
    
    var accentColor: Color {
        if self.usePerInstanceAccentColors {
            return self.activeInstance?.accentColor?.color ?? .accent
        } else {
            return self.globalAccentColor?.color ?? .accent
        }
    }
    
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
            .tint(self.accentColor)
            .withErrorHandling(onTap: self.handleErrorToast)
        }
    }
    
    func handleErrorToast(_ toast: ErrorToast) {
        print(toast.errorDescription)
    }
}
