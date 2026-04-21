//
//  Reminder+AppEntity.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 20.04.26.
//

import AppIntents
import MeerkatAPI

nonisolated extension Reminder: @retroactive AppEntity {
    
    public static var defaultQuery: ReminderQuery = ReminderQuery()
    
    public var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(stringLiteral: message)
    }
    
    public static var typeDisplayRepresentation: TypeDisplayRepresentation = TypeDisplayRepresentation(stringLiteral: "Reminder")
    
    public struct ReminderQuery: EntityQuery {
        public init() { }
        
        @IntentParameterDependency<CompleteReminderIntent>(
            \.$instance
        )
        var completeReminderIntent
        
        func defaultResult() async throws -> Reminder? {
            try await self.suggestedEntities().first
        }
        
        // Provide the list of options you want to show the user, when they select the Entity in the shortcut. You probably want to show all items you have from your array.
        public func suggestedEntities() async throws -> [Reminder] {
            guard let instance = self.completeReminderIntent?.instance else {
                throw AppIntentError.UserActionRequired.accountSetup
            }
            
            let token = try await instance.getToken()
            
            let apiHandler = ApiHandler(serverURL: instance.serverURL, token: token)
            
            let reminders = try await apiHandler.getReminders()
            
            return reminders
        }
        
        // Find Entity by id to bridge the Shortcuts Entity to your App
        public func entities(for identifiers: [Int]) async throws -> [Reminder] {
            let reminders = try await self.suggestedEntities()
            
            return reminders.filter {
                identifiers.contains($0.id)
            }
        }
    }
}
