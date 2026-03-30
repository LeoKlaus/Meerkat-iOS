//
//  Note+mock.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 30.03.26.
//

import Foundation
import MeerkatAPI

extension Note {
    nonisolated static let mock = Note(
        id: 1,
        createdAt: .now,
        updatedAt: Calendar.current.date(byAdding: .day, value: -2, to: Date()),
        deletedAt: nil,
        content: "Meeting notes from yesterday's project review.",
        date: Calendar.current.date(byAdding: .day, value: -2, to: Date()),
        contactId: 1,
        contact: .mock
    )
    
    nonisolated static let mock2 = Note(
        id: 2,
        createdAt: Calendar.current.date(byAdding: .weekOfMonth, value: -1, to: Date())!,
        updatedAt: nil,
        deletedAt: Calendar.current.date(byAdding: .month, value: -6, to: Date()),
        content: "Reminder to follow up with Bob regarding the contract.",
        date: Calendar.current.date(byAdding: .day, value: 3, to: Date()),
        contactId: 2,
        contact: .mock2
    )
    
    nonisolated static let mock3 = Note(
        id: 3,
        createdAt: Date(),
        updatedAt: Calendar.current.date(byAdding: .hour, value: -30, to: Date()),
        deletedAt: nil,
        content: "Quick chat with Charlie about the upcoming event.",
        date: Date(),
        contactId: 3,
        contact: .mock3
    )
}
