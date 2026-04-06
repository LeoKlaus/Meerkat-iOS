//
//  Color+isLight.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 05.04.26.
//


import SwiftUI

extension Color {
    func isLight() -> Bool? {
        let cgColor = self.cgColor
        
        let RGBCGColor = cgColor?.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil)
        guard let components = RGBCGColor?.components else {
            return nil
        }
        guard components.count >= 3 else {
            return nil
        }
        
        let brightness = Float(((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000)
        return (brightness > 0.5)
    }
}