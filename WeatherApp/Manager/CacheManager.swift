//
//  CacheManager.swift
//  Revolutic
//
//  Created by Muhammad Asher Azeem on 5/20/25.
//  Copyright © 2025 Revolutic. All rights reserved.
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
            print("Error encoding WeatherForcast data: \(error.localizedDescription)")
        }
    }
    
    func getCachedWeeklyForecast(cityName: String) -> [WeekWeatherInfo]? {
        if let encodedData = userDefaults.data(forKey: "WeatherForcast_\(cityName)") {
            do {
                let decodedData = try JSONDecoder().decode([WeekWeatherInfo].self, from: encodedData)
                return decodedData
            } catch {
                print("Error decoding WeatherForcast data: \(error.localizedDescription)")
            }
        }
        return nil
    }
    
    func cacheCurrentWeather(cityName: String, data: WeatherData) {
        do {
            let encodedData = try JSONEncoder().encode(data)
            userDefaults.set(encodedData, forKey: "CityWeather_\(cityName)")
        } catch {
            print("Error encoding CityWeather data: \(error.localizedDescription)")
        }
    }
    
    func getCachedCurrentWeather(cityName: String) -> WeatherData? {
        if let encodedData = userDefaults.data(forKey: "CityWeather_\(cityName)") {
            do {
                let decodedData = try JSONDecoder().decode(WeatherData.self, from: encodedData)
                return decodedData
            } catch {
                print("Error decoding CityWeather data: \(error.localizedDescription)")
            }
        }
        return nil
    }
}

