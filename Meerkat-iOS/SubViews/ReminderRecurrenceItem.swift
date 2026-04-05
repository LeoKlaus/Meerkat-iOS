//
//  ReminderRecurrenceItem.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 03.04.26.
//

import SwiftUI
import MeerkatAPI

struct ReminderRecurrenceItem: View {
    
    let reminder: Reminder
    
    var body: some View {
        if self.reminder.recurrence != .once {
            HStack {
                Image(systemName: "repeat")
                Text(self.reminder.recurrence.localizedRepresentation)
            }
            .padding(.horizontal, 10)
            .foregroundStyle(.secondary)
            .overlay(
                RoundedRectangle(cornerRadius: .infinity)
                    .stroke(.tertiary)
            )
        }
    }
}

#Preview {
    ReminderRecurrenceItem(reminder: .mock2)
}

#Preview {
    List {
        ReminderListItem(reminder: .mock2)
    }
}
