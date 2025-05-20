//
//  NetworkError.swift
//  Revolutic
//
//  Created by Muhammad Asher Azeem on 5/20/25.
//  Copyright © 2025 Revolutic. All rights reserved.
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
