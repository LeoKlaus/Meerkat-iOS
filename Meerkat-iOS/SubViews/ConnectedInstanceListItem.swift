//
//  ConnectedInstanceListItem.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 22.04.26.
//

import SwiftUI

struct ConnectedInstanceListItem: View {
    
    let instance: ConnectedInstance
    
    var showRemovalButton: Bool = false
    
    let onDisconnectButtonTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(self.instance.username)
                    .bold()
                if showRemovalButton {
                    HStack {
                        Spacer()
                        Button("Disconnect", role: .destructive, action: self.onDisconnectButtonTap)
                            .foregroundStyle(.red)
                            .buttonStyle(.plain)
                    }
                }
            }
            Text(self.instance.serverURL.absoluteString)
                .font(.callout.monospaced())
                .lineLimit(1)
                .minimumScaleFactor(0.75)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    List {
        ConnectedInstanceListItem(instance: .mock, showRemovalButton: true) {
            
        }
        ConnectedInstanceListItem(instance: .mockLongUsername, showRemovalButton: true) {
            
        }
    }
}
