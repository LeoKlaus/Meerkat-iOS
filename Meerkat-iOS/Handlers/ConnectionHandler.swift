//
//  ConnectionHandler.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 29.03.26.
//

import Foundation
import MeerkatAPI

@Observable
class ConnectionHandler {
    
    let apiHandler: ApiHandler
    
    init(serverUrl: URL) {
        self.apiHandler = ApiHandler(serverURL: serverUrl)
    }
    
    init(apiHandler: ApiHandler) {
        self.apiHandler = apiHandler
    }
    
    func getContacts() async throws -> [Contact] {
        return try await self.apiHandler.getContacts()
    }
    
    func getContactImage(contactId: Int) async throws -> Data {
        return try await self.apiHandler.getContactImage(contactId: contactId)
    }
}


extension ConnectionHandler {
    static let mock = ConnectionHandler(apiHandler: .mock)
}
