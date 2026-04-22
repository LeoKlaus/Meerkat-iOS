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
    static var description: IntentDescription { "Intent to select an instance." }
    
    @Parameter(title: "Instance", description: "Instance the widget should use. If empty, the currently active instance from the app will be used.")
    var instance: ConnectedInstance?
    
    init() { }
    
    init(instance: ConnectedInstance? = nil) {
        self.instance = instance
    }
}
