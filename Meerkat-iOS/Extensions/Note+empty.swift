//
//  Note+empty.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 16.04.26.
//

import Foundation
import MeerkatAPI

extension Note {
    static func empty(contactId: Int? = nil) -> Note {
        return Note(
            id: 0,
            createdAt: .now,
            updatedAt: nil,
            deletedAt: nil,
            content: "",
            date: .now,
            contactId: contactId,
            contact: nil
        )
    }
}
