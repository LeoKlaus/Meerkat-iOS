//
//  ReloadAllWidgetsIntent.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 20.04.26.
//


import AppIntents
import WidgetKit

struct ReloadAllWidgetsIntent: AppIntent {
    
    static let title: LocalizedStringResource = "Reload all widgets"
    static let description: IntentDescription? = "Force reloads all widgets."
    
    static let isDiscoverable: Bool = false
    
    func perform() async throws -> some IntentResult {
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}
