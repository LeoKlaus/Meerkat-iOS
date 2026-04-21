//
//  WidgetsBundle.swift
//  Widgets
//
//  Created by Leo Wehrfritz on 20.04.26.
//

import WidgetKit
import SwiftUI

@main
struct WidgetsBundle: WidgetBundle {
    var body: some Widget {
        UpcomingBirthdaysWidget()
        UpcomingRemindersWidget()
    }
}
