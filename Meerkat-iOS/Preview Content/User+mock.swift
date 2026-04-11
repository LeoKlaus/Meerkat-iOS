//
//  User+mock.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 29.03.26.
//

import Foundation
import MeerkatAPI

extension User {
    nonisolated static let mock = User(
        id: 1,
        createdAt: Date(),
        updatedAt: Calendar.current.date(byAdding: .day, value: -1, to: Date()),
        username: "john.doe",
        email: "john.doe@example.com",
        language: .en,
        dateFormat: .us,
        isAdmin: false
    )
    
    nonisolated static let mock2 = User(
        id: 2,
        createdAt: Calendar.current.date(byAdding: .month, value: -2, to: Date())!,
        updatedAt: nil,
        username: "jane_smith",
        email: "jane.smith@example.com",
        language: nil,
        dateFormat: .eu,
        isAdmin: true
    )
    
    nonisolated static let mock3 = User(
        id: 3,
        createdAt: Date(),
        updatedAt: Date(),
        username: "peterjones",
        email: "peter.jones@example.com",
        language: .en,
        dateFormat: nil,
        isAdmin: false
    )
}
