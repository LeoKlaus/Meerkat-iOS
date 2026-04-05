//
//  ApiError+localizedError.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 03.04.26.
//

import Foundation
import MeerkatAPI

extension ApiError: @retroactive LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unauthorized:
            String(localized: "Unauthorized")
        case .forbidden:
            String(localized: "Forbidden")
        case .notFound:
            String(localized: "Not found")
        case .invalidResponse(_,_):
            String(localized: "Received invalid response")
        case .unexpectedHTTPStatus(_,_):
            String(localized: "Received unexpected response")
        }
    }
}
