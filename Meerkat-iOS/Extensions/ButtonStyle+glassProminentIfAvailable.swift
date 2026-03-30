//
//  ButtonStyle+glassProminentIfAvailable.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 30.03.26.
//

import SwiftUI

extension View {
    @ViewBuilder func glassProminentButtonStyleIfAvailable() -> some View {
        if #available(iOS 26, macOS 26, *) {
            self
                .buttonStyle(.glassProminent)
        } else {
            self
                .buttonStyle(.borderedProminent)
        }
    }
}
