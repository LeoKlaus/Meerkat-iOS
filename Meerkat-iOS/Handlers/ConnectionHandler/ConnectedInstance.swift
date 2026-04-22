//
//  ConnectedInstance.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 04.04.26.
//

import Foundation
import WidgetKit

enum ConnectedInstanceError: LocalizedError {
    case couldntAccessUserdefaults
    case instanceNotFound
    case tokenDataNotFound
    case couldntDecodeToken
    
    public var errorDescription: String? {
        switch self {
        case .couldntAccessUserdefaults:
            String(localized: "Couldn't access UserDefaults")
        case .instanceNotFound:
            String(localized: "No matching instance found")
        case .tokenDataNotFound:
            String(localized: "Couldn't find token data")
        case .couldntDecodeToken:
            String(localized: "Couldn't decode token data")
        }
    }
}


nonisolated struct ConnectedInstance: Codable, Identifiable, Sendable {
    
    let id: UUID
    let serverURL: URL
    let username: String
    var accentColor: StorableAccentColor?
    
    var displayName: String {
        "\(self.username)@\(self.serverURL.host() ?? "Unknown Host)")"
    }
    
    init(serverURL: URL, username: String, accentColor: StorableAccentColor? = nil) {
        self.id = UUID()
        self.serverURL = serverURL
        self.username = username
        self.accentColor = accentColor
    }
    
    /**
     Get the currently active instance
     - Returns: The currently active instance
     - Throws: `ConnectedInstanceError.instanceNotFound` if no instance is stored
     */
    static func getActiveInstance() throws -> ConnectedInstance {
        guard let defaults = UserDefaults.meerkat else {
            throw ConnectedInstanceError.couldntAccessUserdefaults
        }
        
        guard let instanceString = defaults.string(forKey: .userDefaults(.activeInstance)) else {
            throw ConnectedInstanceError.instanceNotFound
        }
        
        return try JSONDecoder().decode(ConnectedInstance.self, from: Data(instanceString.utf8))
    }
    
    /**
     Get all stored instances
     - Returns: List of all connected instances
     */
    static func getConnectedInstances() throws -> [ConnectedInstance] {
        guard let defaults = UserDefaults.meerkat else {
            throw ConnectedInstanceError.couldntAccessUserdefaults
        }
        
        guard let instancesString = defaults.string(forKey: .userDefaults(.connectedInstances)) else {
            throw ConnectedInstanceError.instanceNotFound
        }
        
        return try JSONDecoder().decode([ConnectedInstance].self, from: Data(instancesString.utf8))
    }
    
    /**
     Save this instance to userdefaults
     - Parameter token: Auth token for this instance
     */
    @MainActor
    func save(token: String) throws {
        guard let defaults = UserDefaults.meerkat else {
            throw ConnectedInstanceError.couldntAccessUserdefaults
        }
        
        var connectedInstances: [ConnectedInstance] = []
        
        if let instancesData = defaults.string(forKey: .userDefaults(.connectedInstances)) {
            connectedInstances = try JSONDecoder().decode([ConnectedInstance].self, from: Data(instancesData.utf8))
        }
        
        try KeychainHandler.standard.save(Data(token.utf8), service: self.serverURL.absoluteString, account: self.username)
        
        connectedInstances.append(self)
        
        defaults.set(connectedInstances.rawValue, forKey: .userDefaults(.connectedInstances))
    }
    
    /**
     Get the auth token for this instance
     - Returns: The auth token
     */
    @MainActor
    func getToken() throws -> String {
        guard let tokenData = KeychainHandler.standard.read(service: self.serverURL.absoluteString, account: self.username) else {
            throw ConnectedInstanceError.tokenDataNotFound
        }
        
        guard let token = String(data: tokenData, encoding: .utf8) else {
            throw ConnectedInstanceError.couldntDecodeToken
        }
        
        return token
    }
    
    /**
     Removes this instance and its stored token
     */
    @MainActor
    func removeInstance() throws {
        guard let defaults = UserDefaults.meerkat else {
            throw ConnectedInstanceError.couldntAccessUserdefaults
        }
        
        var connectedInstances = try Self.getConnectedInstances()
        var activeInstance: ConnectedInstance? = try Self.getActiveInstance()
        
        connectedInstances.removeAll(where: { $0.id == self.id})
        KeychainHandler.standard.delete(service: self.serverURL.absoluteString, account: self.username)
        
        if activeInstance?.id == self.id {
            activeInstance = connectedInstances.first
        }
        
        defaults.set(activeInstance.rawValue, forKey: .userDefaults(.activeInstance))
        defaults.set(connectedInstances.rawValue, forKey: .userDefaults(.connectedInstances))
    }
    
    @MainActor
    func markActive() throws {
        guard let defaults = UserDefaults.meerkat else {
            throw ConnectedInstanceError.couldntAccessUserdefaults
        }
        WidgetCenter.shared.invalidateConfigurationRecommendations()
        WidgetCenter.shared.reloadAllTimelines()
        defaults.set((self as ConnectedInstance?).rawValue, forKey: .userDefaults(.activeInstance))
    }
}
