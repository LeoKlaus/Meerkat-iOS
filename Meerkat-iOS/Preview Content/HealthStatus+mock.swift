//
//  HealthStatus+mock.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 30.03.26.
//

import Foundation
import MeerkatAPI

extension HealthStatus {
    nonisolated static let mock = HealthStatus(
        status: .healthy,
        timestamp: .now,
        database: DatabaseHealthStatus(
            status: .healthy,
            responseTimeMs: 2
        ),
        version: "0.1.0"
    )
    
    nonisolated static let mockUnhealthy = HealthStatus(
        status: .unhealthy,
        timestamp: .now,
        database: DatabaseHealthStatus(
            status: .unhealthy,
            responseTimeMs: 183
        ),
        version: "0.1.0"
    )
}
