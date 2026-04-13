//
//  MessengerLinkListItem.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 11.04.26.
//

import SwiftUI
import MeerkatAPI

struct MessengerLinkListItem: View {
    
    let messengerLink: MessengerLink
    
    var body: some View {
        HStack {
            if let imageData = self.messengerLink.messenger.imageData, let img = Image(data: imageData) {
                img
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 16, maxHeight: 16)
                    .padding(8)
                    .background {
                        Circle()
                            .fill(messengerLink.messenger.color ?? .accent)
                    }
            } else {
                Image(systemName: "bubble")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white)
                    .frame(maxWidth: 16, maxHeight: 16)
                    .padding(8)
                    .background {
                        Circle()
                            .fill(messengerLink.messenger.color ?? .accent)
                    }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(messengerLink.messenger.name)
                    .bold()
                Text(messengerLink.userId)
                    .font(.system(size: 12).monospaced())
            }
            Spacer()
        }
    }
}

#Preview {
    List {
        MessengerLinkListItem(messengerLink: .mock)
        MessengerLinkListItem(messengerLink: MessengerLink(
            messenger: SupportedMessenger(name: "Telegram", imageData: nil, color: nil, fieldId: "Telegram-ID", linkFormat: ""),
            userId: "+49 123 987654"
        ))
    }
}
