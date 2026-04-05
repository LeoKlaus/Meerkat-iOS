//
//  ReminderOccurence+localizedRepresentation.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 03.04.26.
//

import Foundation
import MeerkatAPI

extension ReminderRecurrence {
    var localizedRepresentation: String {
        switch self {
        case .once:
            return String(localized: "Once")
        case .weekly:
            return String(localized: "Weekly")
        case .monthly:
            return String(localized: "Monthly")
        case .quarterly:
            return String(localized: "Quarterly")
        case .sixMonths:
            return String(localized: "Every six months")
        case .yearly:
            return String(localized: "Yearly")
        }
    }
}
