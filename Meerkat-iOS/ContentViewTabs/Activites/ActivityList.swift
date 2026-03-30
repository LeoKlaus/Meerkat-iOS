//
//  ActivityList.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 30.03.26.
//


import SwiftUI
import EasyErrorHandling

struct ActivityList: View {
    var body: some View {
        ContentUnavailableView("Not implemented yet", systemImage: "calendar")
    }
}

#Preview {
    ActivityList()
        .withErrorHandling()
        .environment(ConnectionHandler.mock)
}
