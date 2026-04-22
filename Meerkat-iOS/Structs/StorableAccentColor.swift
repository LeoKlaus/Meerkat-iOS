//
//  StorableAccentColor.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 22.04.26.
//

import SwiftUI

enum StorableAccentColor: RawRepresentable, CaseIterable, Identifiable, Equatable, Codable {
    
    var id: String {
        self.rawValue
    }
    
    case meerkatBlue
    case paperparrotPurple
    case paperlessGreen
    case plappaOrange
    case custom(hex: String)
    
    static var allCases: [StorableAccentColor] {
        return [
            .meerkatBlue,
            .paperparrotPurple,
            .paperlessGreen,
            .plappaOrange
        ]
    }
    
    var rawValue: String {
        switch self {
        case .meerkatBlue:
            "#2564EB"
        case .paperparrotPurple:
            "#725BFF"
        case .paperlessGreen:
            "#2A5326"
        case .plappaOrange:
            "#ED892E"
        case .custom(let hex):
            hex
        }
    }
    
    init(rawValue: String) {
        switch rawValue {
        case "#2564EB":
            self = .meerkatBlue
        case "#725BFF":
            self = .paperparrotPurple
        case "#2A5326":
            self = .paperlessGreen
        case "#ED892E":
            self = .plappaOrange
        default:
            self = .custom(hex: rawValue)
        }
    }
    
    var color: Color {
        switch self {
        case .meerkatBlue:
            Color.accent
        case .paperparrotPurple:
            Color.paperparrotPurple
        case .paperlessGreen:
            Color.paperlessGreenAccent
        case .plappaOrange:
            Color.plappaOrangeAccent
        case .custom(let hex):
            Color(hex: hex)
        }
    }
}
