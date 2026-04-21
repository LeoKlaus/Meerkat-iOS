//
//  UpcomingBirthdaysProvider.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 20.04.26.
//

import WidgetKit
import MeerkatAPI
import SwiftUI

extension WidgetFamily {
    var maxDisplayableBirthdays: Int {
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

struct UpcomingBirthdaysProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> BirthdayEntry {
        BirthdayEntry.placeholder
    }
    
    func snapshot(for configuration: InstanceSelectionConfigurationAppIntent, in context: Context) async -> BirthdayEntry {
        if context.isPreview {
            return BirthdayEntry.placeholder
        }
        
        guard let instance = configuration.instance else {
            do {
                let activeInstance = try ConnectedInstance.getActiveInstance()
                return await self.createEntry(with: activeInstance, context: context)
            } catch {
                return BirthdayEntry(error: String(localized: "Please configure the widget and select an instance."))
            }
        }
        
        return await createEntry(with: instance, context: context)
    }
    
    private func createEntry(with instance: ConnectedInstance, context: Context) async -> BirthdayEntry {
        do {
            let token = try await instance.getToken()
            let apiHandler = ApiHandler(serverURL: instance.serverURL, token: token)
            
            let upcomingBirthdays = try await apiHandler.getUpcomingBirthdays()
            
            var birthdaysWithImages: [BirthdayWithImage] = []
            
            var i = 0
            
            for birthday in upcomingBirthdays {
                if i < context.family.maxDisplayableBirthdays, let contactId = birthday.contactId, let data = try? await apiHandler.getContactImage(contactId) {
                    birthdaysWithImages.append(BirthdayWithImage(birthday: birthday, image: data))
                } else {
                    birthdaysWithImages.append(BirthdayWithImage(birthday: birthday, image: nil))
                }
                i += 1
            }
            
            return BirthdayEntry(date: .now, birthdays: birthdaysWithImages)
        } catch {
            return BirthdayEntry(error: String(localized: "Error loading birthdays: \(error.localizedDescription)"))
        }
    }
    
    func timeline(for configuration: InstanceSelectionConfigurationAppIntent, in context: Context) async -> Timeline<BirthdayEntry> {
        
        let entry = await self.snapshot(for: configuration, in: context)
        
        let midnight = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: midnight)
        
        // This won't reflect newly added birthdays until midnight. After editing a contacts birthday in the app, this widget should be updated manually.
        return Timeline(entries: [entry], policy: .after(tomorrow ?? .now.addingTimeInterval(3600)))
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
