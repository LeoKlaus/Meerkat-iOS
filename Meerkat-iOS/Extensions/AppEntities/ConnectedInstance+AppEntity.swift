//
//  ConnectedInstance+IntentParameter.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 20.04.26.
//

import AppIntents

nonisolated extension ConnectedInstance: AppEntity {
    static var defaultQuery: InstanceQuery = InstanceQuery()
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(stringLiteral: displayName)
    }
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Instance"
    
    struct InstanceQuery: EntityQuery {
        func defaultResult() async throws -> ConnectedInstance? {
            try await self.suggestedEntities().first
        }
        
        // Provide the list of options you want to show the user, when they select the Entity in the shortcut. You probably want to show all items you have from your array.
        func suggestedEntities() async throws -> [ConnectedInstance] {
            guard let userDefaults = UserDefaults.meerkat,
                  let rawString = userDefaults.string(forKey: .userDefaults(.connectedInstances)),
                  let connectedInstances = [ConnectedInstance](rawValue: rawString) else {
                return []
            }
            return connectedInstances
        }
        
        // Find Entity by id to bridge the Shortcuts Entity to your App
        func entities(for identifiers: [UUID]) async throws -> [ConnectedInstance] {
            guard let userDefaults = UserDefaults.meerkat,
                  let rawString = userDefaults.string(forKey: .userDefaults(.connectedInstances)),
                  let connectedInstances = [ConnectedInstance](rawValue: rawString) else {
                return []
            }
            
            var instances: [ConnectedInstance] = []
            
            for identifier in identifiers {
                if let instance = connectedInstances.first(where: { $0.id == identifier }) {
                    instances.append(instance)
                }
            }
            
            return instances
        }
    }
}
