//
//  ActivityDetailView.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 03.04.26.
//

import SwiftUI
import MeerkatAPI
import EasyErrorHandling

struct ActivityDetailView: View {
    
    let activity: Activity
    
    var body: some View {
        List {
            Text(activity.title)
        }
    }
}

#Preview {
    NavigationStack {
        ActivityDetailView(activity: .mock)
    }
    .withErrorHandling()
    .environment(ConnectionHandler.mock)
}
