//
//  DateComponents+toBirthdayString.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 05.04.26.
//

import Foundation

extension DateComponents {
    
    init(todayMinusYears: Int) {
        var components = Calendar.current.dateComponents([.calendar, .year, .month, .day], from: Date())
        components.setValue((components.year ?? 2000) - todayMinusYears, for: .year)
        self = components
    }
    
    var isToday: Bool {
        let today = Date()
        return self.day == Calendar.current.component(.day, from: today) && self.month == Calendar.current.component(.month, from: today)
    }
    
    func toBirthdayStringWithAge(_ formatString: String = "MMMdd") -> String {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate(formatString)
        
        if let date = self.date {
            
            let base = self.isToday ? String(localized: "Today") : formatter.string(from: date)
            
            if let birthYear = self.year {
                let currentYear = Calendar.current.component(.year, from: Date())
                return String(localized: "\(base) (turns \(currentYear - birthYear))")
            }
            
            
            return base
        } else {
            return "<Error>"
        }
    }
    
    func toBirthdayStringWithoutAge(_ formatString: String = "MMMdd") -> String {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate(formatString)
        
        if let date = self.date {
            return self.isToday ? String(localized: "Today") : formatter.string(from: date)
        } else {
            return "<Error>"
        }
    }
    
    func toAgeString(dateOnlyFormatString: String = "MMMdd", dateAndYearFormatString: String = "MMMdd yyyy") -> String {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate(dateOnlyFormatString)
        
        if let date = self.date {
            if self.year != nil, let age = Calendar.current.dateComponents([.year], from: date, to: .now).year {
                formatter.setLocalizedDateFormatFromTemplate(dateAndYearFormatString)
                return String(localized: "\(formatter.string(from: date)) (\(age) years old)")
            }
            
            return formatter.string(from: date)
        } else {
            return "<Error>"
        }
    }
}
