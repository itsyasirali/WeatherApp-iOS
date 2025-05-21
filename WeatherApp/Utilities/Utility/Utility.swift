//
//  Utility.swift
//  WeatherApp
//
//  Created by Revolutic on 20/05/2025.
//  Copyright © 2025 Revolutic LLC. All rights reserved.
//

import Foundation
import UIKit

final class Utility {
    
    // MARK: - Date & Time
    static func isToday(_ timestamp: TimeInterval) -> Bool {
        let inputDate = Date(timeIntervalSince1970: timestamp)
        return Calendar.current.isDateInToday(inputDate)
    }
    
    static func getformattedDateFromTimeStamp(from timestamp: TimeInterval, format: TimeFormat = .none) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.string(from: date)
    }
    
    // MARK: - Temperature
    static func formattedTemperature(_ kelvin: Double?, isCelsius: Bool) -> String {
        guard let kelvin = kelvin else { return .empty }
        let celsius = kelvin - 273.15
        let value = isCelsius ? celsius : round((celsius * 9/5) + 32)
        let unit = isCelsius ? "°C" : "°F"
        return String(format: "%.0f %@", value, unit)
    }
    
    // MARK: - Weather Icon
    static func image(for iconName: String?) -> UIImage {
        guard let iconName = iconName, let image = UIImage(named: iconName) else {
            return UIImage(named: "unknown") ?? UIImage()
        }
        return image
    }
    
}


