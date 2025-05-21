//
//  NetworkError.swift
//  WeatherApp
//
//  Created by Revolutic on 20/05/2025.
//  Copyright © 2025 Revolutic LLC. All rights reserved.
//

import Foundation
import UIKit

enum NetworkError: Error, LocalizedError {
    case decodingFailed
    case requestFailed
    case emptyResponse
    
    var errorDescription: String? {
        switch self {
        case .decodingFailed:
            return "Failed to parse the data from the server."
        case .requestFailed:
            return "Network request failed."
        case .emptyResponse:
            return "No data received from the server."
        }
    }
}

enum TimeFormat: String {
    case timeOnly = "HH:mm"
    case dateOnly = "MMM dd, yyyy"
    case none = "EEEE, MMM dd, yyyy"
}

enum HTTPHeaderFields: String {
    case application_json = "application/json"
    case application_x_www_form_urlencoded = "application/x-www-form-urlencoded"
    case none = ""
}

enum LocationError: Error {
    case noLocationAvailable
    case noCityAvailable
    case noPlacemarkAvailable
}
