//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Revolutic on 20/05/2025.
//  Copyright © 2025 Revolutic LLC. All rights reserved.
//

import Foundation
import UIKit

class WeatherViewModel {
    
    //MARK: - Var(s)
    let networkService = NetworkService()
    var reloadWeatherList: (([WeekWeatherInfo]) -> Void)?
    var showWeatherData: ((WeatherData?) -> Void)?
    
    var weatherForeCastData = [WeekWeatherInfo]() {
        didSet {
            reloadWeatherList?(weatherForeCastData)
        }
    }
    
    var cityWeatherData: WeatherData? {
        didSet {
            if let weatherData = cityWeatherData {
                showWeatherData?(weatherData)
            }
        }
    }
    
    //MARK: - Helper Method(s)
    
    func fetchWeeklyForecast(for city: String) {
        networkService.callRequest(apiEndPoint: .forecast, city: city) { result in
            switch result {
            case .success(let forecast):
                self.weatherForeCastData = forecast
            case .failure(let error):
                log("weatherForeCastData Not Found: \(error.localizedDescription)", tag: "WeatherViewModel")
            }
        }
    }
    
    func fetchCurrentWeather(for city: String) {
        networkService.callRequest(apiEndPoint: .weather, city: city) { result in
            switch result {
            case .success(let weatherData):
                self.cityWeatherData = weatherData
            case .failure(let error):
                log("cityWeatherData Not Found: \(error.localizedDescription)", tag: "WeatherViewModel")
            }

        }
    }
    
}
