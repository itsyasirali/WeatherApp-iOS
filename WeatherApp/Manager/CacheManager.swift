//
//  CacheManager.swift
//  WeatherApp
//
//  Created by Revolutic on 20/05/2025.
//  Copyright © 2025 Revolutic LLC. All rights reserved.
//

import Foundation

class CacheManager {
    
    public static let shared = CacheManager()
    private let userDefaults = UserDefaults.standard
    private init() {}
    
    func cacheWeeklyForecast(cityName: String, data: [WeekWeatherInfo]) {
        do {
            let encodedData = try JSONEncoder().encode(data)
            userDefaults.set(encodedData, forKey: "WeatherForcast_\(cityName)")
        } catch {
            log("Error encoding WeatherForcast data: \(error.localizedDescription)", tag: "CacheManager")
        }
    }
    
    func getCachedWeeklyForecast(cityName: String) -> [WeekWeatherInfo]? {
        if let encodedData = userDefaults.data(forKey: "WeatherForcast_\(cityName)") {
            do {
                let decodedData = try JSONDecoder().decode([WeekWeatherInfo].self, from: encodedData)
                return decodedData
            } catch {
                log("Error encoding WeatherForcast data: \(error.localizedDescription)", tag: "CacheManager")
            }
        }
        return nil
    }
    
    func cacheCurrentWeather(cityName: String, data: WeatherData) {
        do {
            let encodedData = try JSONEncoder().encode(data)
            userDefaults.set(encodedData, forKey: "CityWeather_\(cityName)")
        } catch {
            log("Error encoding CityWeather data: \(error.localizedDescription)", tag: "CacheManager")
        }
    }
    
    func getCachedCurrentWeather(cityName: String) -> WeatherData? {
        if let encodedData = userDefaults.data(forKey: "CityWeather_\(cityName)") {
            do {
                let decodedData = try JSONDecoder().decode(WeatherData.self, from: encodedData)
                return decodedData
            } catch {
                log("Error decoding CityWeather data: \(error.localizedDescription)", tag: "CacheManager")
            }
        }
        return nil
    }
}

