//
//  WeatherViewModel.swift
//  Revolutic
//
//  Created by Muhammad Asher Azeem on 5/20/25.
//  Copyright © 2025 Revolutic. All rights reserved.
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
            self.reloadWeatherList?(weatherForeCastData)
        }
    }
    
    var cityWeatherData: WeatherData? {
        didSet {
            if let weatherData = self.cityWeatherData {
                self.showWeatherData?(weatherData)
            }
        }
    }
    
    //MARK: - Helper Method(s)
    
    func fetchWeeklyForecast(for city: String) {
        networkService.fetchForecast(for: city) { result in
            switch result {
            case .success(let forecast):
                self.weatherForeCastData = forecast
            case .failure(let error):
                print("weatherForeCastData Not Found", error.localizedDescription)
                
            }
        }
    }
    
    func fetchCurrentWeather(for city: String) {
        networkService.fetchCurrentWeather(for: city) { result in
            switch result {
            case .success(let weatherData):
                self.cityWeatherData = weatherData
            case .failure(let error):
                print("cityWeatherData Not Found", error.localizedDescription)
            }
        }
    }
    
}
