//
//  Array+RawRepresentable.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 04.04.26.
//

import Foundation

extension Array: @retroactive RawRepresentable where Element: Codable {
    nonisolated public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else { return nil }
        self = result
    }
    
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}
