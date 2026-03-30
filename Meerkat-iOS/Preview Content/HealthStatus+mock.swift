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
        status: "healthy",
        timestamp: .now,
        database: DatabaseHealthStatus(
            status: "healthy",
            responseTimeMs: 0
        ),
        version: "0.1.0"
    )
}
