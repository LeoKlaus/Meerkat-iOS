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
    
    convenience init() {
        self.init(serverURL: URL(string: "https://google.com")!)
    }
    
    override func get<T: Decodable>(from endpoint: ApiEndpoint, parameters: [URLQueryItem] = []) async throws -> T {
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
