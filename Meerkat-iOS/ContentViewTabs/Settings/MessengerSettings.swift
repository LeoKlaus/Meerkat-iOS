//
//  MessengerSettings.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 05.04.26.
//

import SwiftUI

struct MessengerSettings: View {
    
    @AppStorage(.userDefaults(.supportedMessengers), store: .meerkat) var supportedMessengers: [SupportedMessenger] = SupportedMessenger.standard
    
    func removeMessenger(_ indexSet: IndexSet) {
        self.supportedMessengers.remove(atOffsets: indexSet)
    }
    
    var body: some View {
        List {
            ForEach(self.supportedMessengers) { messenger in
                VStack(alignment: .leading) {
                    HStack {
                        if let imgData = messenger.imageData, let img = Image(data: imgData) {
                            img
                                .resizable()
                                .scaledToFit()
                                .padding(8)
                                .background(messenger.color)
                                .clipShape(.circle)
                                .frame(maxWidth: 30)
                        }
                        Text(messenger.name)
                            .bold()
                    }
                    VStack(alignment: .leading) {
                        Text("Field Name:")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(messenger.fieldId)
                            .font(.system(size: 13).monospaced())
                    }
                    VStack(alignment: .leading) {
                        Text("Link Format:")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(messenger.linkFormat)
                            .font(.system(size: 13).monospaced())
                    }
                }
            }
            .onDelete(perform: self.removeMessenger)
        }
    }
}

#Preview {
    MessengerSettings()
}
