//
//  ReminderCompletion+mock.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 05.04.26.
//

import Foundation
import MeerkatAPI

extension ReminderCompletion {
    nonisolated static let mock = ReminderCompletion(
        id: 1,
        createdAt: Date().addingTimeInterval(-86400),
        updatedAt: Date().addingTimeInterval(-3600),
        deletedAt: nil,
        reminderId: 1,
        contactId: 1,
        message: "Don't forget the meeting!",
        completedAt: Date().addingTimeInterval(-3600)
    )
    
    nonisolated static let mock2 = ReminderCompletion(
        id: 2,
        createdAt: Date().addingTimeInterval(-172800),
        updatedAt: Date().addingTimeInterval(-10000),
        deletedAt: nil,
        reminderId: 2,
        contactId: 2,
        message: "Buy groceries",
        completedAt: Date().addingTimeInterval(-72700)
    )
    
    nonisolated static let mock3 = ReminderCompletion(
        id: 3,
        createdAt:  Date(),
        updatedAt: nil,
        deletedAt: nil,
        reminderId: 3,
        contactId: 3,
        message: "Follow up with client",
        completedAt: Date().addingTimeInterval(86400)
    )
}
