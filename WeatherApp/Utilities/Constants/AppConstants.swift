//
//  AppConstants.swift
//  WeatherApp
//
//  Created by Revolutic on 20/05/2025.
//  Copyright © 2025 Revolutic LLC. All rights reserved.
//

import Foundation

enum AppConstants {
    static let mainStoryboardName = "Main"
    static var openWeatherApiKey: String {
        Bundle.main.infoDictionary?["OPENWEATHER_API_KEY"] as? String ?? .empty
    }
}

enum APIEndPoints: String {
    
    var baseUrl : String {
        "https://api.openweathermap.org/data/2.5/"
    }
    
    case forecast = "forecast"
    case weather = "weather"
    
    var url : String {
        switch self {
        case .forecast:
            return "\(baseUrl)forecast"
        case .weather:
            return "\(baseUrl)weather"
        }
    }
    
}


