//
//  Utility.swift
//  Revolutic
//
//  Created by Muhammad Asher Azeem on 5/20/25.
//  Copyright © 2025 Revolutic. All rights reserved.
//

import Foundation

final class Utility {
    
    
    static func isToday(_ timestamp: TimeInterval) -> Bool {
        let inputDate = Date(timeIntervalSince1970: timestamp)
        return Calendar.current.isDateInToday(inputDate)
    }
    
    static func getformattedDateFromTimeStamp(from timestamp: TimeInterval, format: TimeFormat = .none) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        
        switch format {
        case .timeOnly:
            formatter.dateFormat = "HH:mm"
        case .dateOnly:
            formatter.dateFormat = "MMM dd, yyyy"
        case .none:
            formatter.dateFormat = "EEEE, MMM dd, yyyy"
        }
        
        return formatter.string(from: date)
    }
    
    static func convertKelvinToCelsius(_ kelvin: Double) -> Double {
        return kelvin - 273.15
    }
    static func celsiusToFahrenheit(_ celsius: Double) -> Double {
        return round((celsius * 9/5) + 32)
    }
}
