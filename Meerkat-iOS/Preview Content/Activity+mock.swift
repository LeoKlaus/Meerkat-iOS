//
//  Activity+mock.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 30.03.26.
//

import Foundation
import MeerkatAPI

extension Activity {
    nonisolated static let mock = Activity(
        id: 1,
        createdAt: Calendar.current.date(byAdding: .day, value: -30, to: .now)!,
        updatedAt: nil,
        deletedAt: nil,
        title: "Morning Yoga",
        description: "Start your day with flexibility and mindfulness.",
        location: "Community Center Hall A",
        date: Calendar.current.date(byAdding: .day, value: 1, to: .now)!,
        contacts: [
            .mock,
            .mock2
        ]
    )
    
    nonisolated static let mock2 = Activity(
        id: 2,
        createdAt: Calendar.current.date(byAdding: .day, value: -5, to: .now)!,
        updatedAt: Calendar.current.date(byAdding: .hour, value: 2, to: .now)!,
        deletedAt: nil,
        title: "Team Standup",
        description: "Weekly sync with the engineering team.",
        location: "Zoom / Online",
        date: Calendar.current.date(byAdding: .day, value: -1, to: .now)!
    )
    
    nonisolated static let mock3 = Activity(
        id: 3,
        createdAt: Calendar.current.date(byAdding: .weekOfYear, value: -2, to: .now)!,
        updatedAt: nil,
        deletedAt: Calendar.current.date(byAdding: .hour, value: 10, to: .now)!,
        title: "Old Project Review",
        description: nil,
        location: nil,
        date: Calendar.current.date(byAdding: .month, value: -2, to: .now)!
    )
}
