//
//  ApiHandler+mock.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 29.03.26.
//

import Foundation
import MeerkatAPI
import UIKit

class MockApiHandler: ApiHandler {
    
    convenience init(mock: Bool = true) {
        self.init(serverURL: URL(string: "https://meerkat-crm-demo.fly.dev")!)
    }
    
    override func sendRequest(to endpoint: ApiEndpoint, method: HTTPMethod = .GET, body: Data? = nil, multipartBoundary: String? = nil, parameters: [URLQueryItem] = []) async throws -> Data {
        try await Task.sleep(for: .milliseconds(Int.random(in: 250...500)))
        switch endpoint {
        case .register, .login, .logout, .requestPasswordReset, .confirmPasswordReset:
            return Data()
        case .health:
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            return try encoder.encode(HealthStatus.mock)
        default:
            throw ApiError.forbidden
        }
    }
    
    override func get<T: Decodable>(from endpoint: ApiEndpoint, parameters: [URLQueryItem] = []) async throws -> T {
        try await Task.sleep(for: .milliseconds(Int.random(in: 250...500)))
        switch endpoint {
        case .me:
            return User.mock as! T
        case .contacts:
            return PaginatedResponse<Contact>.getContactsMock() as! T
        default:
            throw ApiError.forbidden
        }
    }
    
    override func getData(from endpoint: ApiEndpoint) async throws -> Data {
        switch endpoint {
        case .contactImage(_):
            return await UIImage(resource: .mockUser).jpegData(compressionQuality: 1) ?? Data()
        default:
            throw ApiError.notFound
        }
    }
}

extension ApiHandler {
    static let mock: ApiHandler = MockApiHandler()
}
