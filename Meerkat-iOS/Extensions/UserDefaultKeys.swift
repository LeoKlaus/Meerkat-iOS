//
//  UserDefaultKeys.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 30.03.26.
//

import Foundation

enum UserDefaultKey: String, CaseIterable {
    case serverURL
}

extension String {
    static func userDefaults(_ key: UserDefaultKey) -> String {
        key.rawValue
    }
}

extension UserDefaults {
    static let meerkat = UserDefaults(suiteName: "group.me.wehrfritz.meerkat-ios")
}
