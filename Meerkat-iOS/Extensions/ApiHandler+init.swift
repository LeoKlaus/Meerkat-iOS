//
//  ApiHandler+init.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 30.03.26.
//

import Foundation
import MeerkatAPI

extension ApiHandler {
    convenience init?() {
        if let serverURL = UserDefaults.meerkat?.url(forKey: .userDefaults(.serverURL)) {
            self.init(serverURL: serverURL)
        } else {
            return nil
        }
    }
}
