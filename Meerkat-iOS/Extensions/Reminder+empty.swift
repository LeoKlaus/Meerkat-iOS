//
//  Reminder+empty.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 07.04.26.
//

import Foundation
import MeerkatAPI

extension Reminder {
    static let empty = Reminder(
        id: 0,
        createdAt: .now,
        message: "",
        byMail: false,
        remindAt: .now,
        recurrence: .once,
        reoccurFromCompletion: false,
        completed: false,
        emailSent: false,
        contactId: 0
    )
}
