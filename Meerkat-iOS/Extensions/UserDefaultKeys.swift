//
//  UserDefaultKeys.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 30.03.26.
//

import Foundation

enum UserDefaultKey: String, CaseIterable {
    case connectedInstances
    case activeInstance
    case supportedMessengers
    case widgetCompletedReminder
    case lastSeenPatchNote
    case showPatchNotes
    case colorScheme
    case globalAccentColor
    case usePerInstanceAccentColors
}

extension String {
    nonisolated static func userDefaults(_ key: UserDefaultKey) -> String {
        key.rawValue
    }
}

extension UserDefaults {
    nonisolated static let meerkat = UserDefaults(suiteName: "group.me.wehrfritz.meerkat-ios")
}
