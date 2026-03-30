//
//  ContentView.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 29.03.26.
//

import SwiftUI
import EasyErrorHandling

struct ContentView: View {
    
    @State private var connectionHandler: ConnectionHandler?
    
    var body: some View {
        Group {
            if let connectionHandler {
                ContactList()
                    .environment(connectionHandler)
            } else {
                LoginView(connectionHandler: self.$connectionHandler)
            }
        }
        .withErrorHandling()
    }
}

#Preview {
    ContentView()
}
