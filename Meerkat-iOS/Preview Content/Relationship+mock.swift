//
//  Relationship+mock.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 30.03.26.
//

import Foundation
import MeerkatAPI

extension Relationship {
    nonisolated static let mock = Relationship(
        id: 1,
        createdAt: Date(),
        updatedAt: Calendar.current.date(byAdding: .day, value: -3, to: Date()),
        deletedAt: nil,
        name: "Spouse",
        type: "Marriage",
        gender: .female,
        birthday: "1987-05-20",
        contactId: 1,
        relatedContactId: 2,
        relatedContact: Contact.mock
    )
    
    nonisolated static let mock2 = Relationship(
        id: 2,
        createdAt: Calendar.current.date(byAdding: .weekOfMonth, value: -1, to: Date())!,
        updatedAt: nil,
        deletedAt: Calendar.current.date(byAdding: .month, value: -3, to: Date()),
        name: "Parent",
        type: "Biological",
        gender: .male,
        birthday: nil,
        contactId: 2,
        relatedContactId: 3,
        relatedContact: Contact.mock2
    )
    
    nonisolated static let mock3 = Relationship(
        id: 3,
        createdAt: Date(),
        updatedAt: Calendar.current.date(byAdding: .hour, value: -6, to: Date()),
        deletedAt: nil,
        name: "Child",
        type: "Adoption",
        gender: .other,
        birthday: "2015-11-10",
        contactId: 3,
        relatedContactId: 1,
        relatedContact: Contact.mock3
    )
}
