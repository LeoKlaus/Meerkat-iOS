//
//  SettingsView.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 30.03.26.
//

import SwiftUI
import EasyErrorHandling

struct SettingsView: View {
    var body: some View {
        ContentUnavailableView("Not implemented yet", systemImage: "gear")
    }
}

#Preview {
    SettingsView()
        .withErrorHandling()
        .environment(ConnectionHandler.mock)
}
