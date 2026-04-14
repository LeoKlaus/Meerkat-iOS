//
//  SupportedMessenger.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 05.04.26.
//

import Foundation
import SwiftUI
import MeerkatAPI

struct SupportedMessenger: Codable, Hashable, Identifiable {
    var id: String {
        self.fieldId
    }
    
    let name: String
    let imageData: Data?
    let color: Color?
    let fieldId: String
    let linkFormat: String
    let disclaimner: String?
    
    func generateLink(for userId: String) -> URL? {
        URL(string: self.linkFormat.replacingOccurrences(of: "{user_id}", with: userId))
    }
    
    init(name: String, imageData: Data? = nil, color: Color? = nil, fieldId: String, linkFormat: String, disclaimer: String? = nil) {
        self.name = name
        self.imageData = imageData
        self.color = color
        self.fieldId = fieldId
        self.linkFormat = linkFormat
        self.disclaimner = disclaimer
    }
}

// MARK: Default Messengers
extension SupportedMessenger {
    static let standard: [SupportedMessenger] = [
        .whatsApp,
        .discord,
        .signal
    ]
    
    static let discord = SupportedMessenger(
        name: "Discord",
        imageData: UIImage(resource: .discord).pngData(),
        color: Color(hex: "#5865F2"),
        fieldId: "Discord-ID",
        linkFormat: "https://discord.com/users/{user_id}",
        disclaimer: "Discord and the “Clyde” Logo are trademarks of Discord. \(Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "Meerkat-iOS") is not affiliated with Discord in any form. The Discord branding is only used to refer to the Discord app."
    )
    
    static let whatsApp = SupportedMessenger(
        name: "WhatsApp",
        imageData: UIImage(resource: .whatsApp).pngData(),
        color: Color(hex: "#25d366"),
        fieldId: "WhatsApp-ID",
        linkFormat: "https://wa.me/{user_id}",
        disclaimer: "WhatsApp is a trademark of Meta. \(Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "Meerkat-iOS") is not affiliated with WhatsApp or Meta in any form. The WhatsApp branding is only used to refer to the WhatsApp app."
    )
    
    static let signal = SupportedMessenger(
        name: "Signal",
        imageData: UIImage(resource: .signal).pngData(),
        color: Color(hex: "3b45fd"),
        fieldId: "Signal-ID",
        linkFormat: "https://signal.me/#p/{user_id}",
        disclaimer: "Signal's Brand Assets are owned by Signal Technology Foundation. \(Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "Meerkat-iOS") is not affiliated with Signal in any form. The Signal branding is only used to refer to the Signal app."
    )
}

struct MessengerLink: Identifiable {
    let id = UUID()
    let messenger: SupportedMessenger
    var userId: String
    var url: URL? {
        self.messenger.generateLink(for: userId)
    }
    
    init(messenger: SupportedMessenger, userId: String) {
        self.messenger = messenger
        self.userId = userId
    }
}

extension Contact {
    func getMatchingMessengers(_ messengerList: [SupportedMessenger]) -> [MessengerLink] {
        let matchingMessengers = messengerList.filter { messenger in
            self.customFields?.keys.contains(messenger.fieldId) ?? false
        }
        
        var messengerLinks: [MessengerLink] = []
        
        for messenger in matchingMessengers {
            if let userId = self.customFields?[messenger.fieldId] {
                messengerLinks.append(MessengerLink(messenger: messenger, userId: userId))
            }
        }
        
        return messengerLinks
    }
    
    func nonMessengerFields(_ messengerList: [SupportedMessenger]) -> [String:String] {
        let messengerFieldIds = messengerList.map(\.fieldId)
        
        return self.customFields?.filter { field in
            !messengerFieldIds.contains(field.key)
        } ?? [:]
    }
}
