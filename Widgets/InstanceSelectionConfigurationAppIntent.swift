//
//  InstanceSelectionConfigurationAppIntent.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 20.04.26.
//

import WidgetKit
import AppIntents

struct InstanceSelectionConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Configuration" }
    static var description: IntentDescription { "Widget displaying upcoming birthdays." }
    
    @Parameter(title: "Instance")
    var instance: ConnectedInstance?
    
    init() { }
    
    init(instance: ConnectedInstance? = nil) {
        self.instance = instance
    }
}
