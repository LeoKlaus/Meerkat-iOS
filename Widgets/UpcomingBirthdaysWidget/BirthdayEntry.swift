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
    let instance: ConnectedInstance?
    let error: String?
    
    static let placeholder = BirthdayEntry(date: .now, birthdays: [
        BirthdayWithImage(birthday: Birthday(type: .contact, name: "Gustav Gans", birthday: .init(todayMinusYears: 21), contactId: 1), image: nil),
        BirthdayWithImage(birthday: .mock, image: UIImage(named: "MockUserImage")?.resize(350, 350).pngData()),
        BirthdayWithImage(birthday: .mock2, image: nil),
        BirthdayWithImage(birthday: .mock3, image: nil)
    ], instance: .mock)
    
    init(date: Date, birthdays: [BirthdayWithImage], instance: ConnectedInstance) {
        self.date = date
        self.birthdays = birthdays
        self.instance = instance
        self.error = nil
    }
    
    init(error: String) {
        self.date = .now
        self.birthdays = []
        self.instance = nil
        self.error = error
    }
}
