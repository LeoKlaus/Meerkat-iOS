//
//  UpcomingBirthdaysConfiguration.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 20.04.26.
//

import WidgetKit
import AppIntents

struct UpcomingBirthdaysConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Configuration" }
    static var description: IntentDescription { "Widget displaying upcoming birthdays." }
    
    @Parameter(title: "Instance")
    var instance: ConnectedInstance?
}
