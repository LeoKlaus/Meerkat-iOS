//
//  BirthdayEntry.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 20.04.26.
//

import Foundation
import WidgetKit
import MeerkatAPI
import SwiftUI

struct BirthdayWithImage: Identifiable {
    let id = UUID()
    let birthday: Birthday
    let image: Data?
}

struct BirthdayEntry: WidgetKit.TimelineEntry {
    let date: Date
    let birthdays: [BirthdayWithImage]
    let error: String?
    
    static let placeholder = BirthdayEntry(date: .now, birthdays: [
        BirthdayWithImage(birthday: Birthday(type: .contact, name: "Gustav Gans", birthday: .init(todayMinusYears: 21), contactId: 1), image: nil),
        BirthdayWithImage(birthday: .mock, image: UIImage(named: "MockUserImage")?.resize(350, 350).pngData()),
        BirthdayWithImage(birthday: .mock2, image: nil),
        BirthdayWithImage(birthday: .mock3, image: nil)
    ])
    
    init(date: Date, birthdays: [BirthdayWithImage], error: String? = nil) {
        self.date = date
        self.birthdays = birthdays
        self.error = error
    }
}
