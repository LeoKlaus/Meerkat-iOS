//
//  UpcomingBirthdaysWidget.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 20.04.26.
//

import WidgetKit
import SwiftUI
import MeerkatAPI

struct UpcomingBirthdaysEntryView : View {
    
    @Environment(\.widgetFamily) var widgetFamily
    @Environment(\.widgetRenderingMode) var renderingMode
    @Environment(\.redactionReasons) var reasons
    
    var entry: UpcomingBirthdaysProvider.Entry
    
    var remainingBirthdays: Int {
        self.entry.birthdays.count - self.widgetFamily.maxDisplayableBirthdays
    }
    
    var todaysBirthdays: [BirthdayWithImage] {
        self.entry.birthdays.filter(\.birthday.birthday.isToday)
    }
    
    var circularPresentation: some View {
        VStack(alignment: .leading, spacing: 0) {
            Label {
                Text("Today:")
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .bold()
            } icon: {
                Image(systemName: "birthday.cake.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 10)
            }
            ForEach(self.todaysBirthdays) { birthday in
                Text(birthday.birthday.name)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
            if self.todaysBirthdays.isEmpty {
                Text("None")
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if let error = self.entry.error {
                Text(error)
                    .font(.title3)
                    .foregroundStyle(.primary)
                    .minimumScaleFactor(0.5)
                
            } else {
                switch self.widgetFamily {
                case .accessoryCircular:
                    self.circularPresentation
                case .accessoryInline:
                    if self.todaysBirthdays.isEmpty {
                        Label("Today: None", systemImage: "birthday.cake.fill")
                            .minimumScaleFactor(0.5)
                    } else {
                        Label("Today: \(self.todaysBirthdays.map(\.birthday.name).joined(separator: ", "))", systemImage: "birthday.cake.fill")
                            .minimumScaleFactor(0.5)
                    }
                default:
                    if self.entry.birthdays.isEmpty {
                        if self.widgetFamily == .accessoryRectangular {
                            Label("No upcoming birthdays", systemImage: "birthday.cake.fill")
                        } else {
                            ContentUnavailableView("No upcoming birthdays", systemImage: "birthday.cake.fill")
                                .minimumScaleFactor(0.5)
                        }
                    }
                    ForEach(self.entry.birthdays.prefix(self.widgetFamily.maxDisplayableBirthdays)) { birthday in
                        if let contactId = birthday.birthday.contactId, let url = URL(string: "meerkat://contact/\(contactId)") {
                            Link(destination: url) {
                                self.birthdayItem(birthday)
                            }
                            .buttonStyle(.plain)
                        } else {
                            self.birthdayItem(birthday)
                        }
                    }
                    if self.remainingBirthdays > 0 {
                        Text("and \(self.remainingBirthdays) more...")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                    }
                }
            }
            switch self.widgetFamily {
            case .accessoryInline, .accessoryCircular, .accessoryRectangular:
                EmptyView()
            default:
                Spacer()
                Label("Upcoming Birthdays", systemImage: "birthday.cake.fill")
                    .foregroundStyle(.secondary)
                    .font(.caption2)
                    .minimumScaleFactor(0.75)
                    .lineLimit(1)
            }
        }
    }
    
    func birthdayItem(_ birthday: BirthdayWithImage) -> some View {
        HStack {
            if ![WidgetFamily.systemSmall, .accessoryRectangular].contains(self.widgetFamily) {
                self.userImage(birthday)
            }
            VStack(alignment: .leading) {
                Text(birthday.birthday.name)
                    .foregroundStyle(.primary)
                HStack(spacing: 0) {
                    if birthday.birthday.birthday.isToday && self.reasons != .placeholder {
                        Image(systemName: "birthday.cake")
                            .foregroundStyle(.tint)
                    }
                    Text(birthday.birthday.birthday.toBirthdayStringWithAge())
                        .font(.caption)
                        .bold(birthday.birthday.birthday.isToday)
                        .foregroundStyle(.secondary)
                }
            }
            .minimumScaleFactor(0.75)
            
            Spacer()
        }
        .frame(maxHeight: 40)
    }
    
    func userImage(_ birthday: BirthdayWithImage) -> some View {
        Group {
            if let imageData = birthday.image, let image = UIImage(data: imageData) {
                Image(uiImage: image)
                    .resizable()
                    .widgetAccentedRenderingMode(.accentedDesaturated)
                    .scaledToFit()
                    .clipShape(.circle)
                
            } else {
                ZStack {
                    if self.reasons == .placeholder {
                        Circle()
                            .fill(.quaternary)
                    } else {
                        if self.renderingMode == .fullColor {
                            Circle()
                                .fill(.tint)
                        } else {
                            Circle()
                                .stroke(lineWidth: 1)
                                .fill(.tint)
                        }
                        Text(birthday.birthday.name.prefix(1))
                            .foregroundStyle(.white)
                            .padding(4)
                    }
                }
                .frame(maxHeight: .infinity)
            }
        }
    }
}

struct UpcomingBirthdays: Widget {
    let kind: String = "UpcomingBirthdays"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: UpcomingBirthdaysConfigurationAppIntent.self, provider: UpcomingBirthdaysProvider()) { entry in
            UpcomingBirthdaysEntryView(entry: entry)
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
    }
}

#Preview("Regular", as: .systemLarge) {
    UpcomingBirthdays()
} timeline: {
    BirthdayEntry.placeholder
}

#Preview("Empty", as: .systemLarge) {
    UpcomingBirthdays()
} timeline: {
    BirthdayEntry(date: .now, birthdays: [])
}

#Preview("Error", as: .systemSmall) {
    UpcomingBirthdays()
} timeline: {
    BirthdayEntry(date: .now, birthdays: [], error: "Please configure the widget and select an instance.")
}

#Preview("Inline", as: .accessoryInline) {
    UpcomingBirthdays()
} timeline: {
    BirthdayEntry.placeholder
}

#Preview("Inline Empty", as: .accessoryInline) {
    UpcomingBirthdays()
} timeline: {
    BirthdayEntry(date: .now, birthdays: [])
}

#Preview("Circular", as: .accessoryCircular) {
    UpcomingBirthdays()
} timeline: {
    BirthdayEntry.placeholder
}

#Preview("Circular Empty", as: .accessoryCircular) {
    UpcomingBirthdays()
} timeline: {
    BirthdayEntry(date: .now, birthdays: [])
}

#Preview("Rectangular", as: .accessoryRectangular) {
    UpcomingBirthdays()
} timeline: {
    BirthdayEntry.placeholder
}

#Preview("Rectangular Empty", as: .accessoryRectangular) {
    UpcomingBirthdays()
} timeline: {
    BirthdayEntry(date: .now, birthdays: [])
}
