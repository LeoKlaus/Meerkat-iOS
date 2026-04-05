//
//  Birthday+mock.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 30.03.26.
//

import Foundation
import MeerkatAPI

extension Birthday {
    nonisolated static let mock = Birthday(
        type: .contact,
        name: "Alice Smith",
        birthday: DateComponents(calendar: .current, year: 1985, month: 3, day: 15),
        contactId: 1
    )
    
    nonisolated static let mock2 = Birthday(
        type: .contact,
        name: "Bob Johnson",
        birthday: DateComponents(calendar: .current, year: 1990, month: 12, day: 124),
        contactId: 2
    )
    
    nonisolated static let mock3 = Birthday(
        type: .relationship,
        name: "Anniversary",
        birthday: DateComponents(calendar: .current, month: 01, day: 15),
        contactId: 2
    )
    
    nonisolated static let placeholder = Birthday(
        type: .contact,
        name: "Anniversary",
        birthday: DateComponents(calendar: .current, year: 1985, month: 03, day: 15),
        contactId: nil
    )
}
