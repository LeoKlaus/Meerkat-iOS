//
//  DashboardView.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 30.03.26.
//

import SwiftUI
import EasyErrorHandling

struct DashboardView: View {
    var body: some View {
        ContentUnavailableView("Not implemented yet", systemImage: "text.rectangle.page")
    }
}

#Preview {
    DashboardView()
        .withErrorHandling()
        .environment(ConnectionHandler.mock)
}
