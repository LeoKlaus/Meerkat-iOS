//
//  UpcomingRemindersWidget.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 20.04.26.
//

import WidgetKit
import SwiftUI
import MeerkatAPI
import AppIntents

struct UpcomingRemindersEntryView : View {
    
    @Environment(\.widgetFamily) var widgetFamily
    @Environment(\.widgetRenderingMode) var renderingMode
    @Environment(\.redactionReasons) var reasons
    
    var entry: UpcomingRemindersProvider.Entry
    
    var remainingReminders: Int {
        self.entry.reminders.count - self.widgetFamily.maxDisplayableReminders
    }
    
    var body: some View {
        VStack {
            if let error = self.entry.error {
                Text(error)
                    .font(.title3)
                    .foregroundStyle(.primary)
                    .minimumScaleFactor(0.5)
                
            } else {
                if self.entry.reminders.isEmpty {
                    switch self.widgetFamily {
                    case .accessoryRectangular:
                            Label("No upcoming reminders", systemImage: "bell.fill")
                    case .accessoryCircular:
                        Label("0", systemImage: "bell.fill")
                    default:
                        Spacer()
                        ContentUnavailableView("No upcoming reminders", systemImage: "bell.fill")
                            .minimumScaleFactor(0.5)
                        Spacer()
                    }
                } else {
                    switch self.widgetFamily {
                    case .accessoryInline:
                        Label("\(self.entry.reminders.count) upcoming reminders", systemImage: "bell.fill")
                    case .accessoryCircular:
                        Label("\(self.entry.reminders.count)", systemImage: "bell.fill")
                    default:
                        ForEach(self.entry.reminders.prefix(self.widgetFamily.maxDisplayableReminders)) { reminder in
                            
                            // TODO: Build reminder detail view and support this?
                            /*if let url = URL(string: "meerkat://reminder/\(reminder.id)") {
                                Link(destination: url) {
                                    self.reminderItem(reminder)
                                }
                                .buttonStyle(.plain)
                            } else {*/
                                self.reminderItem(reminder)
                            //}
                            
                            if reminder != self.entry.reminders.prefix(self.widgetFamily.maxDisplayableReminders).last {
                                Divider()
                            }
                        }
                        
                        if self.remainingReminders > 0 {
                            Text("and \(self.remainingReminders) more...")
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
            }
            switch self.widgetFamily {
            case .accessoryInline, .accessoryCircular, .accessoryRectangular:
                EmptyView()
            default:
                Spacer()
                HStack {
                    Group {
                        if self.widgetFamily == .systemSmall {
                            if let instance = entry.instance {
                                Label("for \(instance.username)", systemImage: "bell.fill")
                            } else {
                                Image(systemName: "bell.fill")
                            }
                        } else {
                            if let instance = entry.instance {
                                Label("Upcoming Reminders for \(instance.username)", systemImage: "bell.fill")
                            } else {
                                Label("Upcoming Reminders ", systemImage: "bell.fill")
                            }
                        }
                    }
                    .foregroundStyle(.secondary)
                    .font(.caption2)
                    .minimumScaleFactor(0.75)
                    .lineLimit(1)
                    Spacer()
                    
                    Button(intent: ReloadAllWidgetsIntent()) {
                        Label("\(entry.date, style: .time)", systemImage: "arrow.circlepath")
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.secondary)
                    .font(.caption)
                }
            }
        }
    }
    
    func reminderItem(_ reminder: Reminder) -> some View {
        HStack {
            if let instance = self.entry.instance {
                Toggle(isOn: UserDefaults.meerkat?.string(forKey: .userDefaults(.widgetCompletedReminder)) == "\(instance.id)+\(reminder.id)", intent: CompleteReminderIntent(instance: instance, reminder: reminder)) {
                    if UserDefaults.meerkat?.string(forKey: .userDefaults(.widgetCompletedReminder)) == "\(instance.id)+\(reminder.id)" {
                        Image(systemName: "checkmark.circle.fill")
                    } else {
                        Image(systemName: "circle")
                    }
                }
                .buttonStyle(.plain)
                .foregroundStyle(.accent)
                
                /*Button(intent: CompleteReminderIntent(instance: instance, reminder: reminder)) {
                    Image(systemName: "circle")
                        .foregroundStyle(.accent)
                }
                .buttonStyle(.plain)*/
            } else {
                Image(systemName: "circle")
                    .foregroundStyle(.accent)
            }
            VStack(alignment: .leading) {
                Text(reminder.message)
                    .multilineTextAlignment(.leading)
                    .lineLimit(self.widgetFamily == .systemSmall ? 2 : 1)
                    .minimumScaleFactor(0.75)
                HStack {
                    Text(reminder.remindAt, style: .date)
                        .foregroundStyle(reminder.remindAt.hasPassed ? .red : .secondary)
                    
                    if [WidgetFamily.systemMedium, .systemLarge, .systemExtraLarge].contains(self.widgetFamily) {
                        if reminder.byMail {
                            Image(systemName: "envelope")
                                .foregroundStyle(.secondary)
                        }
                        
                        ReminderRecurrenceItem(reminder: reminder)
                        
                        if reminder.reoccurFromCompletion {
                            Text("Flexible")
                                .padding(.horizontal, 10)
                                .foregroundStyle(.tint)
                                .overlay(
                                    RoundedRectangle(cornerRadius: .infinity)
                                        .stroke(.tertiary)
                                )
                        }
                        
                        Spacer()
                    }
                    
                }
                .font(.caption)
            }
            
            Spacer()
        }
        .frame(maxHeight: 45)
    }
}

struct UpcomingRemindersWidget: Widget {
    let kind: String = "UpcomingReminders"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: InstanceSelectionConfigurationAppIntent.self, provider: UpcomingRemindersProvider()) { entry in
            UpcomingRemindersEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .promptsForUserConfiguration()
        .supportedFamilies([
            .accessoryCircular,
            .accessoryInline,
            .accessoryRectangular,
            .systemSmall,
            .systemMedium,
            .systemLarge
        ])
        .configurationDisplayName("Upcoming Reminders")
        .description("Shows upcoming reminders for the selected instance.")
    }
}

#Preview("Regular", as: .systemLarge) {
    UpcomingRemindersWidget()
} timeline: {
    ReminderEntry.placeholder
}

#Preview("Empty", as: .systemLarge) {
    UpcomingRemindersWidget()
} timeline: {
    ReminderEntry(date: .now, reminders: [], instance: .mockLongUsername)
}

#Preview("Error", as: .systemSmall) {
    UpcomingRemindersWidget()
} timeline: {
    ReminderEntry(error: "Please configure the widget and select an instance.")
}

#Preview("Inline", as: .accessoryInline) {
    UpcomingRemindersWidget()
} timeline: {
    ReminderEntry.placeholder
}

#Preview("Inline Empty", as: .accessoryInline) {
    UpcomingRemindersWidget()
} timeline: {
    ReminderEntry(date: .now, reminders: [], instance: .mock)
}

#Preview("Circular", as: .accessoryCircular) {
    UpcomingRemindersWidget()
} timeline: {
    ReminderEntry.placeholder
}

#Preview("Circular Empty", as: .accessoryCircular) {
    UpcomingRemindersWidget()
} timeline: {
    ReminderEntry(date: .now, reminders: [], instance: .mock)
}

#Preview("Rectangular", as: .accessoryRectangular) {
    UpcomingRemindersWidget()
} timeline: {
    ReminderEntry.placeholder
}

#Preview("Rectangular Empty", as: .accessoryRectangular) {
    UpcomingRemindersWidget()
} timeline: {
    ReminderEntry(date: .now, reminders: [], instance: .mock)
}
