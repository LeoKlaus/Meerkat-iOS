//
//  Healthiness+localizedRepresentation.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 22.04.26.
//

import Foundation
import MeerkatAPI

extension Healthiness {
    var localizedRepresentation: String {
        switch self {
        case .healthy:
            String(localized: "Healthy")
        case .unhealthy:
            String(localized: "Unhealthy")
        case .unknown(let status):
            String(localized: "Unexpected: \(status)")
        }
    }
}
