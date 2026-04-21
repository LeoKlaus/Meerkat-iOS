//
//  CompleteReminderIntent.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 20.04.26.
//

import AppIntents
import WidgetKit
import MeerkatAPI

struct CompleteReminderIntent: AppIntent {
    
    static let title: LocalizedStringResource = "Complete Reminder"
    static let description: IntentDescription? = "Mark the selected reminder as completed."
    
    static let isDiscoverable: Bool = true
    
    @Parameter(title: "Instance")
    var instance: ConnectedInstance
    
    @Parameter(title: "Reminder", description: "The reminder to complete")
    var reminder: Reminder
    
    func perform() async throws -> some IntentResult {
        // Updates widget state
        UserDefaults.meerkat?.set("\(instance.id)+\(reminder.id)", forKey: .userDefaults(.widgetCompletedReminder))
        
        do {
            let token = try await instance.getToken()
            
            let apiHandler = ApiHandler(serverURL: instance.serverURL, token: token)
                
            try await apiHandler.completeReminder(reminder)
        } catch {
            UserDefaults.meerkat?.set(nil, forKey: .userDefaults(.widgetCompletedReminder))
            
            switch error {
            case ApiError.notFound:
                throw AppIntentError.Unrecoverable.entityNotFound
            case ApiError.forbidden, ApiError.unauthorized:
                throw AppIntentError.UserActionRequired.signin
            default:
                throw AppIntentError.Unrecoverable.partialFailure
            }
        }
        
        WidgetCenter.shared.reloadTimelines(ofKind: "UpcomingReminders")
        
        return .result()
    }
    
    init() { }
    
    init(instance: ConnectedInstance, reminder: Reminder) {
        self.instance = instance
        self.reminder = reminder
    }
}
