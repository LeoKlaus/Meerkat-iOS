//
//  ConnectedInstance+mock.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 04.04.26.
//

import Foundation

extension ConnectedInstance {
    static let mock = ConnectedInstance(
        serverURL: URL(string: "https://meerkat-crm-demo.fly.dev")!,
        username: "Leo"
    )
    
    static let mockLongUsername = ConnectedInstance(
        serverURL: URL(string: "https://meerkat-crm-demo.fly.dev")!,
        username: "Leopold-Garfield"
    )
}
