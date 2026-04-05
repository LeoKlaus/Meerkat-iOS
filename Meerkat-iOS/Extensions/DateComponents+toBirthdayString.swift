//
//  DateComponents+toBirthdayString.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 05.04.26.
//

import Foundation

extension DateComponents {
    
    func toBirthdayString(_ formatString: String = "MMMdd") -> String {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate(formatString)
        
        if let date = self.date {
            if let birthYear = self.year {
                let currentYear = Calendar.current.component(.year, from: Date())
                return String(localized: "\(formatter.string(from: date)) (turns \(currentYear - birthYear) years)")
            }
            
            return formatter.string(from: date)
        } else {
            return "<Error>"
        }
    }
}
