//
//  ReminderEntry.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 20.04.26.
//

import WidgetKit
import MeerkatAPI

struct ReminderEntry: WidgetKit.TimelineEntry {
    let date: Date
    let reminders: [Reminder]
    let instance: ConnectedInstance?
    let error: String?
    
    static let placeholder = ReminderEntry(
        date: .now,
        reminders: [
            .mock,
            .mock2,
            .mock3
        ],
        instance: .mock
    )
    
    init(date: Date, reminders: [Reminder], instance: ConnectedInstance) {
        self.date = date
        self.reminders = reminders
        self.instance = instance
        self.error = nil
    }
    
    init(error: String) {
        self.date = .now
        self.reminders = []
        self.instance = nil
        self.error = error
    }
}
