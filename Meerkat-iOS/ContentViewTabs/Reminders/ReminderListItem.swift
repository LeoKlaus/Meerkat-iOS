//
//  ReminderListItem.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 03.04.26.
//

import SwiftUI
import MeerkatAPI
import EasyErrorHandling

struct ReminderListItem: View {
    
    let reminder: Reminder
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(self.reminder.message)
            HStack {
                Text(self.reminder.remindAt, style: .date)
                
                if self.reminder.byMail {
                   Image(systemName: "envelope")
                }
                
                ReminderRecurrenceItem(reminder: self.reminder)
                
                if self.reminder.reoccurFromCompletion {
                    Text("Flexible")
                        .padding(.horizontal, 10)
                        .foregroundStyle(.tint)
                        .overlay(
                            RoundedRectangle(cornerRadius: .infinity)
                                .stroke(.tertiary)
                        )
                }
            }
            .foregroundStyle(.secondary)
            .font(.caption)
        }
    }
}

#Preview {
    List {
        ReminderListItem(reminder: .mock2)
    }
}
