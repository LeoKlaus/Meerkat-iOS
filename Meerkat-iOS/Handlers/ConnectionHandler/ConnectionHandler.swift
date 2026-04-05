//
//  ConnectionHandler.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 29.03.26.
//

import Foundation
import MeerkatAPI
import EasyErrorHandling

@Observable
class ConnectionHandler {
    
    var apiHandler: ApiHandler
    
    var contacts: [Contact] = []
    var hasRemainingContacts: Bool = true
    
    var notes: [Note] = []
    var hasRemainingNotes: Bool = true
    
    var activites: [Activity] = []
    var hasRemainingActivities: Bool = true
    
    var currentInstance: ConnectedInstance
    
    init(serverURL: URL, username: String, token: String) throws {
        let apiHandler = ApiHandler(serverURL: serverURL, token: token)
        
        let instance = ConnectedInstance(serverURL: serverURL, username: username)
        
        try instance.save(token: token)
        
        try instance.markActive()
        
        self.currentInstance = instance
        
        self.apiHandler = apiHandler
    }
    
    init(apiHandler: ApiHandler, instance: ConnectedInstance) {
        self.apiHandler = apiHandler
        self.currentInstance = instance
    }
    
    init(instance: ConnectedInstance) throws {
        let token = try instance.getToken()
        
        self.currentInstance = instance
        self.apiHandler = ApiHandler(serverURL: instance.serverURL, token: token)
    }
    
    convenience init?() {
        do {
            let instance = try ConnectedInstance.getActiveInstance()
            try self.init(instance: instance)
        } catch {
            switch error {
            case ConnectedInstanceError.instanceNotFound:
                return nil
            default:
                ErrorHandler.shared.handle(error, while: "setting up ApiHandler")
                return nil
            }
        }
    }
    
    func switchInstance(to newInstance: ConnectedInstance) throws {
        self.apiHandler = ApiHandler(serverURL: newInstance.serverURL, token: try newInstance.getToken())
        
        self.contacts = []
        self.hasRemainingContacts = true
        
        self.notes = []
        self.hasRemainingNotes = true
        
        self.activites = []
        self.hasRemainingActivities = true
        
        try newInstance.markActive()
    }
    
    func getContacts(limit: Int = 50, page: Int = 1) async throws {
        if page == 1 {
            self.hasRemainingContacts = true
            self.contacts = []
        }
        
        let contactResponse = try await self.apiHandler.getContacts(limit: limit, page: page)
        
        self.contacts += contactResponse.results
        
        if let total = contactResponse.total {
            self.hasRemainingContacts = self.contacts.count < total
        }
    }
    
    func getContactImage(_ contact: Contact) async throws -> Data {
        return try await self.apiHandler.getContactImage(contact)
    }
    
    func getNotes(limit: Int = 50, page: Int = 1) async throws {
        if page == 1 {
            self.hasRemainingNotes = true
            self.notes = []
        }
        
        let noteResponse = try await self.apiHandler.getUnassignedNotes(limit: limit, page: page)
        
        self.notes += noteResponse.results
        
        if let total = noteResponse.total {
            self.hasRemainingNotes = self.notes.count < total
        }
    }
    
    func getActivities(limit: Int = 50, page: Int = 1) async throws {
        if page == 1 {
            self.hasRemainingActivities = true
            self.activites = []
        }
        
        let response = try await self.apiHandler.getActivities(limit: limit, page: page)
        
        self.activites += response.results
        
        if let total = response.total {
            self.hasRemainingActivities = self.activites.count < total
        }
    }
}


extension ConnectionHandler {
    static let mock = ConnectionHandler(apiHandler: .mock, instance: .mock)
}
