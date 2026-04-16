//
//  Activity+empty.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 16.04.26.
//

import Foundation
import MeerkatAPI

extension Activity {
    static let empty = Activity(
        id: 0,
        createdAt: .now,
        updatedAt: nil,
        deletedAt: nil,
        title: "",
        description: nil,
        location: nil,
        date: .now,
        contacts: nil
    )
    
    static func empty(with contacts: [Contact]) -> Activity {
        var empty = Activity.empty
        empty.contacts = contacts
        return empty
    }
}
