//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Revolutic on 20/05/2025.
//  Copyright © 2025 Revolutic LLC. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Implementation
final class NetworkService {
    
    func callRequest(
        apiEndPoint: APIEndPoints,
        city: String,
        forCastCompletion: ((Result<[WeekWeatherInfo], NetworkError>) -> Void)? = nil,
        weatherCompletion: ((Result<WeatherData, NetworkError>) -> Void)? = nil
    ) {
        
        if apiEndPoint == .forecast {
            let cache = CacheManager.shared.getCachedWeeklyForecast(cityName: city)
            forCastCompletion?(.success(cache ?? []))
            return
        } else if apiEndPoint == .weather {
            let cache = CacheManager.shared.getCachedCurrentWeather(cityName: city)
            weatherCompletion?(.success(cache!))
            return
        }
                
        let params: [RequestParameter: String] = [
            .q : city,
            .appid : AppConstants.openWeatherApiKey
        ]
        
        log("openWeatherApiKey = \(AppConstants.openWeatherApiKey)", tag: "NetworkService")
        log("url = \(APIEndPoints.weather)", tag: "NetworkService")
        log("parameters = \(params)", tag: "NetworkService")
        
        
        NetworkHelper.shared.GET(apiEndPoint: apiEndPoint, params: params) { success, data in
            guard success, let data = data else {
                if apiEndPoint == .forecast {
                    forCastCompletion?(.failure(.requestFailed))
                } else {
                    weatherCompletion?(.failure(.requestFailed))
                }
                return
            }
            log("response data FetchCurrentWeather: \(String(data: data, encoding: .utf8) ?? .empty)", tag: "NetworkService")
            do {
                
                if apiEndPoint == .forecast {
                    let response = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    CacheManager.shared.cacheWeeklyForecast(cityName: city, data: response.list)
                    forCastCompletion?(.success(response.list))
                } else {
                    let response = try JSONDecoder().decode(WeatherData.self, from: data)
                    CacheManager.shared.cacheCurrentWeather(cityName: city, data: response)
                    weatherCompletion?(.success(response))
                }
            } catch {
                if apiEndPoint == .forecast {
                    forCastCompletion?(.failure(.decodingFailed))
                } else {
                    weatherCompletion?(.failure(.decodingFailed))

                }
            }
        }
    }
    
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil, let data = data, let image = UIImage(data: data) else {
                log("Image download failed: \(String(describing: error?.localizedDescription))", tag: "NetworkService")
                DispatchQueue.main.async { completion(nil) }
                return
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
