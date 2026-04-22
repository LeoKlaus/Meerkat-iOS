//
//  ChangeAccentColorView.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 22.04.26.
//

import SwiftUI

struct ChangeAccentColorView: View {
    
    @AppStorage(.userDefaults(.colorScheme), store: .meerkat) var colorScheme: StorableColorScheme = .system
    
    @AppStorage(.userDefaults(.globalAccentColor), store: .meerkat) var globalAccentColor: StorableAccentColor? = nil
    @AppStorage(.userDefaults(.connectedInstances), store: .meerkat) var connectedInstances: [ConnectedInstance] = []
    @AppStorage(.userDefaults(.activeInstance), store: .meerkat) var activeInstance: ConnectedInstance? = nil
    
    @AppStorage(.userDefaults(.usePerInstanceAccentColors), store: .meerkat) var usePerInstanceAccentColors: Bool = false
    
    @State private var tempColor: Color = .accentColor
    
    var body: some View {
        List {
            Section {
                Picker("Color Scheme", selection: $colorScheme) {
                    Text("Light").tag(StorableColorScheme.light)
                    Text("Dark").tag(StorableColorScheme.dark)
                    Text("System").tag(StorableColorScheme.system)
                }
                
                
                Toggle("Use Per-Instance Accent Colors", isOn: self.$usePerInstanceAccentColors)
            }
            
            if self.usePerInstanceAccentColors {
                ForEach(self.connectedInstances) { instance in
                    self.accentColorSelection(instance)
                }
            } else {
                self.accentColorSelection()
            }
        }
    }
    
    func accentColorSelection(_ instance: ConnectedInstance? = nil) -> some View {
        Group {
            Section {
                ForEach(StorableAccentColor.allCases) { accentColor in
                    Button {
                        self.setAccentColor(color: accentColor, instance: instance)
                    } label: {
                        HStack {
                            switch accentColor {
                            case .meerkatBlue:
                                Text("Meerkat Blue")
                            case .paperparrotPurple:
                                Text("Paperparrot Purple")
                            case .paperlessGreen:
                                Text("Paperless Green")
                            case .plappaOrange:
                                Text("Plappa Orange")
                            default:
                                Text("Custom Color")
                            }
                            Spacer()
                            if instance?.accentColor ?? self.globalAccentColor == accentColor || (accentColor == .meerkatBlue && instance?.accentColor ?? self.globalAccentColor == nil) {
                                Image(systemName: "checkmark")
                            }
                        }.foregroundStyle(accentColor.color)
                    }
                    .disabled(instance?.accentColor ?? self.globalAccentColor == accentColor)
                }
            } header: {
                if let instance {
                    Text(instance.displayName)
                }
            }
            
            
            Section {
                HStack {
                    ColorPicker("Custom Accent Color", selection: $tempColor)
                    if case .custom = instance?.accentColor ?? self.globalAccentColor {
                        Image(systemName: "checkmark")
                    }
                }
                .onChange(of: self.tempColor) {
                    self.setAccentColor(color: StorableAccentColor(rawValue: self.tempColor.toHex()), instance: instance)
                }
            } footer: {
                Text("Warning: Changing the accent color can reduce contrast or make certain elements of the UI illegible.")
            }
        }
    }
    
    func setAccentColor(color: StorableAccentColor, instance: ConnectedInstance? = nil) {
        if var instance {
            instance.accentColor = color
            if let index = self.connectedInstances.firstIndex(where: {
                $0.id == instance.id
            }) {
                self.connectedInstances[index] = instance
            }
            if instance.id == self.activeInstance?.id {
                self.activeInstance?.accentColor = color
            }
        } else {
            self.globalAccentColor = color
        }
    }
}

#Preview {
    NavigationStack {
        ChangeAccentColorView(connectedInstances: [.mock, .mockLongUsername])
    }
}
