//
//  StorableColorScheme.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 22.04.26.
//


import SwiftUI

enum StorableColorScheme: String {
    
    case dark, light, system
    
    var colorScheme: ColorScheme? {
        switch self {
        case .dark:
            return .dark
        case .light:
            return .light
        case .system:
            return .none
        }
    }
}