//
//  LocationError.swift
//  Revolutic
//
//  Created by Muhammad Asher Azeem on 5/20/25.
//  Copyright © 2025 Revolutic. All rights reserved.
//

import Foundation

enum LocationError: Error {
    case noLocationAvailable
    case noCityAvailable
    case noPlacemarkAvailable
}
