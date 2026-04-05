//
//  Gender+localizedRepresentation.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 03.04.26.
//

import Foundation
import MeerkatAPI

extension Gender {
    var localizedRepresentation: String {
        switch self {
        case .male:
            String(localized: "Male")
        case .female:
            String(localized: "Female")
        case .other:
            String(localized: "Other")
        case .preferNotToSay:
            String(localized: "Prefer not to say")
        case .unknown:
            String(localized: "Unknown")
        }
    }
}
