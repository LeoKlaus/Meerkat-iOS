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
    
    @State private var connectionHandler: ConnectionHandler? = ConnectionHandler()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if let connectionHandler {
                    ContentView()
                        .environment(connectionHandler)
                } else {
                    LoginView(connectionHandler: self.$connectionHandler)
                }
            }
            .withErrorHandling(onTap: self.handleErrorToast)
        }
    }
    
    func handleErrorToast(_ toast: ErrorToast) {
        print(toast.errorDescription)
    }
}
