//
//  ActivityListItem.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 03.04.26.
//

import SwiftUI
import MeerkatAPI
import EasyErrorHandling

struct ActivityListItem: View {
    
    let activity: Activity
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(activity.title)
                
                Text(activity.date, style: .date)
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
        }
    }
}

#Preview {
    List {
        ActivityListItem(activity: .mock)
            .frame(maxHeight: 50)
    }
    .withErrorHandling()
    .environment(ConnectionHandler.mock)
}
