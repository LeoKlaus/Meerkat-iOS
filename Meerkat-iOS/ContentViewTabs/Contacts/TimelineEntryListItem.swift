//
//  TimelineEntryListItem.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 05.04.26.
//

import SwiftUI
import MeerkatAPI

struct TimelineEntryListItem: View {
    
    let entry: any TimelineEntry
    
    var body: some View {
        VStack(alignment: .leading) {
            if let reminder = self.entry as? ReminderCompletion {
                Text("Reminder Completed")
                    .bold()
                Text(reminder.message)
            } else if let note = self.entry as? Note {
                Text("Note")
                    .bold()
                Text(note.content)
            } else if let activity = self.entry as? Activity {
                Text(activity.title)
                    .bold()
                if let description = activity.description {
                    Text(description)
                }
                if let location = activity.location {
                    Label(location, systemImage: "pin")
                        .padding(.vertical, 2)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                if let contacts = activity.contacts, !contacts.isEmpty {
                    Label(contacts.map(\.firstAndLastName).joined(separator: ","), systemImage: "person.2")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            } else {
                Text("Unsupported type")
            }
            if let time = entry.time {
                HStack {
                    Spacer()
                    Text(time, style: .date)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

#Preview {
    List {
        TimelineEntryListItem(entry: Activity.mock)
        TimelineEntryListItem(entry: ReminderCompletion.mock)
        TimelineEntryListItem(entry: Note.mock)
    }
}
