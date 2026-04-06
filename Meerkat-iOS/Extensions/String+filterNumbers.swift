//
//  String+filterNumbers.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 05.04.26.
//

import Foundation

extension String {
    
    func filterNumbers() -> String {
        let digits = self.unicodeScalars.filter {
            CharacterSet.decimalDigits.contains($0)
        }
        
        return String(String.UnicodeScalarView(digits))
    }
   
}
