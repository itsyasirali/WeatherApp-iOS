//
//  WeatherDetailViewController.swift
//  WeatherApp
//
//  Created by Revolutic on 20/05/2025.
//  Copyright © 2025 Revolutic LLC. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    //MARK: IBOutlets
    @IBOutlet weak var weatherStatusImageView: UIImageView!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblMaxTemp: UILabel!
    @IBOutlet weak var lblMinTemp: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    //MARK: Var
    var weekForecast : WeekWeatherInfo?
    var currentWeatherData: WeatherData?
    var isCelsiusSelected = true
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    //MARK: Method
    func configureView() {
        guard let forecast = weekForecast else { return }
        lblTemp?.text = Utility.formattedTemperature(forecast.main.temp, isCelsius: isCelsiusSelected)
        lblMinTemp?.text = Utility.formattedTemperature(forecast.main.temp_min, isCelsius: isCelsiusSelected)
        lblMaxTemp?.text = Utility.formattedTemperature(forecast.main.temp_max, isCelsius: isCelsiusSelected)
        lblHumidity?.text = "\(forecast.main.humidity)%"
        lblDescription?.text = currentWeatherData?.weather.first?.description ?? .empty
        lblDate.text = Utility.getformattedDateFromTimeStamp(from: forecast.dt ?? .zero)
        let iconName = forecast.weather.first?.icon
        weatherStatusImageView?.image = Utility.image(for: iconName)
    }
}
