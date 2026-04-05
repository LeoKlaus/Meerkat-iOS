//
//  ReminderDetailView.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 03.04.26.
//

import SwiftUI
import MeerkatAPI
import EasyErrorHandling

struct ReminderDetailView: View {
    
    let reminder: Reminder
    
    var body: some View {
        List {
            Text(self.reminder.message)
            Text(self.reminder.remindAt, style: .date)
        }
    }
}

#Preview {
    ReminderDetailView(reminder: .mock)
}
