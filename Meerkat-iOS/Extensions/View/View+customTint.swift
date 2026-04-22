//
//  View+customTint.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 22.04.26.
//

import SwiftUI

struct CustomTintModifier: ViewModifier {

    @AppStorage(.userDefaults(.globalAccentColor), store: .meerkat) var globalAccentColor: StorableAccentColor? = nil
    @AppStorage(.userDefaults(.activeInstance), store: .meerkat) var activeInstance: ConnectedInstance? = nil
    @AppStorage(.userDefaults(.usePerInstanceAccentColors), store: .meerkat) var usePerInstanceAccentColors: Bool = false
    
    var overrideActiveInstance: ConnectedInstance?
    
    var accentColor: Color {
        if self.usePerInstanceAccentColors {
            return self.activeInstance?.accentColor?.color ?? .accent
        } else {
            return self.globalAccentColor?.color ?? .accent
        }
    }
    
    func body(content: Content) -> some View {
        content
            .tint(self.accentColor)
    }
}

extension View {
    func customTint(overrideActiveInstance: ConnectedInstance? = nil) -> some View {
        modifier(CustomTintModifier(overrideActiveInstance: overrideActiveInstance))
    }
}
