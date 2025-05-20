//
//  AppConstants.swift
//  Revolutic
//
//  Created by Muhammad Asher Azeem on 5/20/25.
//  Copyright © 2025 Revolutic. All rights reserved.
//

import Foundation

enum AppConstants {
    static let mainStoryboardName = "Main"
    static var openWeatherApiKey: String {
        get {
            KeychainService.getAPIKey() ?? "4b83b1dc6a0f2b2873657b569dc85347"
        }
        set {
            KeychainService.saveAPIKey(newValue)
        }
    }
}

struct APIEndPoints{
    static let baseUrl = "https://api.openweathermap.org/data/2.5/"
    static let forecast = "\(baseUrl)forecast"
    static let weather = "\(baseUrl)weather"
}

extension String{
    static let empty = ""
}
