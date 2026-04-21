//
//  UpcomingRemindersProvider.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 20.04.26.
//

import WidgetKit
import MeerkatAPI
import SwiftUI

extension WidgetFamily {
    var maxDisplayableReminders: Int {
        switch self {
        case .systemSmall:
            2
        case .systemMedium:
            2
        case .systemLarge:
            6
        case .systemExtraLarge:
            6
        case .systemExtraLargePortrait:
            6
        case .accessoryCorner:
            1
        case .accessoryCircular:
            1
        case .accessoryRectangular:
            1
        case .accessoryInline:
            1
        @unknown default:
            6
        }
    }
}

struct UpcomingRemindersProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> ReminderEntry {
        ReminderEntry.placeholder
    }
    
    func snapshot(for configuration: InstanceSelectionConfigurationAppIntent, in context: Context) async -> ReminderEntry {
        if context.isPreview {
            return ReminderEntry.placeholder
        }
        
        guard let instance = configuration.instance else {
            do {
                let activeInstance = try ConnectedInstance.getActiveInstance()
                return await self.createEntry(with: activeInstance)
            } catch {
                return ReminderEntry(error: String(localized: "Please configure the widget and select an instance."))
            }
        }
        
        return await self.createEntry(with: instance)
    }
    
    private func createEntry(with instance: ConnectedInstance) async -> ReminderEntry {
        do {
            let token = try await instance.getToken()
            let apiHandler = ApiHandler(serverURL: instance.serverURL, token: token)
            
            let upcomingReminders = try await apiHandler.getUpcomingReminders()
            
            return ReminderEntry(date: .now, reminders: upcomingReminders, instance: instance)
        } catch {
            return ReminderEntry(error: String(localized: "Error loading reminders: \(error.localizedDescription)"))
        }
    }
    
    func timeline(for configuration: InstanceSelectionConfigurationAppIntent, in context: Context) async -> Timeline<ReminderEntry> {
        
        let entry = await self.snapshot(for: configuration, in: context)
        
        return Timeline(entries: [entry], policy: .after(.now.addingTimeInterval(3600)))
    }
    
    func recommendations() -> [AppIntentRecommendation<InstanceSelectionConfigurationAppIntent>] {
        guard let userDefaults = UserDefaults.meerkat,
              let rawString = userDefaults.string(forKey: .userDefaults(.connectedInstances)),
              let connectedInstances = [ConnectedInstance](rawValue: rawString) else {
            return []
        }
        
        return connectedInstances.map { instance in
            AppIntentRecommendation(intent: InstanceSelectionConfigurationAppIntent(instance: instance), description: instance.displayName)
        }
    }
    
    //    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
    //        // Generate a list containing the contexts this widget is relevant in.
    //    }
}
