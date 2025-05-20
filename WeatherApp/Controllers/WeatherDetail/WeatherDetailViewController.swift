//
//  WeatherDetailViewController.swift
//  Revolutic
//
//  Created by Muhammad Asher Azeem on 5/20/25.
//  Copyright © 2025 Revolutic. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    
    @IBOutlet weak var weatherStatusImageView: UIImageView!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblMaxTemp: UILabel!
    @IBOutlet weak var lblMinTemp: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    var weekForecast : WeekWeatherInfo?
    var currentWeatherData: WeatherData?
    var isCelsiusSelected = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func formatTemperature(_ kelvin: Double?) -> String {
        guard let kelvin = kelvin else { return "N/A" }
        let celsius = Utility.convertKelvinToCelsius(kelvin)
        let value = isCelsiusSelected ? celsius : Utility.celsiusToFahrenheit(celsius)
        let unit = isCelsiusSelected ? "°C" : "°F"
        return String(format: "%.0f %@", value, unit)
    }
    
    func configureView() {
        guard let forecast = weekForecast else { return }
        lblTemp?.text = formatTemperature(forecast.main.temp)
        lblMinTemp?.text = formatTemperature(forecast.main.temp_min)
        lblMaxTemp?.text = formatTemperature(forecast.main.temp_max)
        lblHumidity?.text = "\(forecast.main.humidity)%"
        lblDescription?.text = currentWeatherData?.weather.first?.description ?? "N/A"
        lblDate?.text = forecast.dt != nil
        ? Utility.getformattedDateFromTimeStamp(from: forecast.dt!)
        : "N/A"
        if let iconName = forecast.weather.first?.icon,
           let icon = UIImage(named: iconName) {
            weatherStatusImageView?.image = icon
        } else {
            weatherStatusImageView?.image = UIImage(named: "unknown")
        }
    }
}
