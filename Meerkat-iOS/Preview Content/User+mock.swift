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
        username: "john.doe",
        email: "john.doe@example.com",
        language: "en-US",
        date_format: "MM/dd/yyyy",
        is_admin: false,
        created_at: Date(),
        updated_at: Calendar.current.date(byAdding: .day, value: -1, to: Date())
    )
    
    nonisolated static let mock2 = User(
        id: 2,
        username: "jane_smith",
        email: "jane.smith@example.com",
        language: nil,
        date_format: "yyyy-MM-dd",
        is_admin: true,
        created_at: Calendar.current.date(byAdding: .month, value: -2, to: Date())!,
        updated_at: nil
    )
    
    nonisolated static let mock3 = User(
        id: 3,
        username: "peterjones",
        email: "peter.jones@example.com",
        language: "fr-CA",
        date_format: nil,
        is_admin: false,
        created_at: Date(),
        updated_at: Date()
    )
}
