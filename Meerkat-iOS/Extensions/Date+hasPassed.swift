//
//  Date+hasPassed.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 21.04.26.
//

import Foundation

extension Date {
    var hasPassed: Bool {
        Date() > self
    }
}
