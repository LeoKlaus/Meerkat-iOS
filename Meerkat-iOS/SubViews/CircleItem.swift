//
//  CircleItem.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 30.03.26.
//

import SwiftUI
import EasyErrorHandling

struct CircleItem: View {
    
    let circle: String
    
    var body: some View {
        Text(circle)
            .padding(.horizontal, 10)
            .foregroundStyle(.secondary)
            .overlay(
                RoundedRectangle(cornerRadius: .infinity)
                    .stroke(.tertiary)
            )
    }
}

#Preview {
    CircleItem(circle: "Family")
}

#Preview("ContactItem") {
    List {
        ContactListItem(contact: .mock)
            .frame(maxHeight: 50)
    }
    .withErrorHandling()
    .environment(ConnectionHandler.mock)
}
