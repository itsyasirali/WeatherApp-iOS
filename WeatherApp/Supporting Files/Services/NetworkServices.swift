//
//  NetworkService.swift
//  Revolutic
//
//  Created by Muhammad Asher Azeem on 5/20/25.
//  Copyright © 2025 Revolutic. All rights reserved.
//

import Foundation
import UIKit

protocol NetworkServiceProtocol {
    func fetchForecast(for city: String, completion: @escaping (Result<[WeekWeatherInfo], NetworkError>) -> Void)
    func fetchCurrentWeather(for city: String, completion: @escaping (Result<WeatherData, NetworkError>) -> Void)
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void)
}

// MARK: - Implementation

final class NetworkService: NetworkServiceProtocol {
    
    func fetchForecast(for city: String, completion: @escaping (Result<[WeekWeatherInfo], NetworkError>) -> Void) {
        if let cached = CacheManager.shared.getCachedWeeklyForecast(cityName: city) {
            completion(.success(cached))
            return
        }
        let params = ["q": city, "appid": AppConstants.openWeatherApiKey]
        NetworkHelper.shared.GET(url: APIEndPoints.forecast, params: params, httpHeader: .none) { success, data in
            guard let data = data else {
                completion(.failure(.requestFailed))
                return
            }
            print("fetchForecast",String(data: data, encoding: .utf8) ?? "NO Data in fetchForecast")
            do {
                let response = try JSONDecoder().decode(WeatherResponse.self, from: data)
                CacheManager.shared.cacheWeeklyForecast(cityName: city, data: response.list)
                completion(.success(response.list))
            } catch {
                completion(.failure(.decodingFailed))
            }
        }
    }
    
    func fetchCurrentWeather(for city: String, completion: @escaping (Result<WeatherData, NetworkError>) -> Void) {
        if let cached = CacheManager.shared.getCachedCurrentWeather(cityName: city) {
            completion(.success(cached))
            return
        }
        let params = ["q": city, "appid": AppConstants.openWeatherApiKey]
        NetworkHelper.shared.GET(url: APIEndPoints.weather, params: params, httpHeader: .none) { success, data in
            guard success, let data = data else {
                completion(.failure(.requestFailed))
                return
            }
            print("fetchCurrentWeather",String(data: data, encoding: .utf8) ?? "NO Data in fetchCurrentWeather")
            do {
                let response = try JSONDecoder().decode(WeatherData.self, from: data)
                CacheManager.shared.cacheCurrentWeather(cityName: city, data: response)
                completion(.success(response))
            } catch {
                completion(.failure(.decodingFailed))
            }
        }
    }
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil, let data = data, let image = UIImage(data: data) else {
                print("Image download failed: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async { completion(nil) }
                return
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}




