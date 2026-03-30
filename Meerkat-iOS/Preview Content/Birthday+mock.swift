//
//  Birthday+mock.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 30.03.26.
//

import MeerkatAPI

extension Birthday {
    nonisolated static let mock = Birthday(
        type: .contact,
        name: "Alice Smith",
        birthday: "1985-03-15",
        contactId: 1
    )
    
    nonisolated static let mock2 = Birthday(
        type: .contact,
        name: "Bob Johnson",
        birthday: "1990-12-24",
        contactId: 2
    )
    
    nonisolated static let mock3 = Birthday(
        type: .relationship,
        name: "Anniversary",
        birthday: "2024-01-01",
        contactId: 2
    )
}
