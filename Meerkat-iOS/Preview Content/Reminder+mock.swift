//
//  Reminder+mock.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 03.04.26.
//

import Foundation
import MeerkatAPI

extension Reminder {
    nonisolated static let mock = Reminder(
        id: 1,
        createdAt: Date().addingTimeInterval(-86400),
        updatedAt: Date().addingTimeInterval(-3600),
        deletedAt: nil,
        message: "Don't forget the meeting!",
        byMail: true,
        remindAt: Date().addingTimeInterval(3600 * 5),
        recurrence: .once,
        reoccurFromCompletion: false,
        completed: false,
        emailSent: false,
        lastSent: nil,
        contactId: 101,
        contact: .mock
    )
    
    nonisolated static let mock2 = Reminder(
        id: 2,
        createdAt: Date().addingTimeInterval(-172800),
        updatedAt: Date().addingTimeInterval(-10000),
        deletedAt: nil,
        message: "Buy groceries\nand snacks",
        byMail: false,
        remindAt: Date().addingTimeInterval(-3600),
        recurrence: .weekly,
        reoccurFromCompletion: true,
        completed: true,
        emailSent: true,
        lastSent: Date().addingTimeInterval(-3600),
        contactId: 102,
        contact: .mock2
    )
    
    nonisolated static let mock3 = Reminder(
        id: 3,
        createdAt: Date(), // Just now
        updatedAt: nil,
        deletedAt: nil,
        message: "Follow up with client",
        byMail: true,
        remindAt: Date().addingTimeInterval(86400),
        recurrence: .quarterly,
        reoccurFromCompletion: false,
        completed: false,
        emailSent: false,
        lastSent: nil,
        contactId: 103,
        contact: .mock3
    )
}
