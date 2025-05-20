//
//  WeatherViewController.swift
//  Revolutic
//
//  Created by Muhammad Asher Azeem on 5/20/25.
//  Copyright © 2025 Revolutic. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    //MARK: - IBOutlet(s)
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCity: UILabel?
    @IBOutlet weak var lblWeatherDescription: UILabel!
    @IBOutlet weak var imgWeatherStatusPic: UIImageView?
    @IBOutlet weak var btnForecastSegment: UISegmentedControl?
    @IBOutlet weak var weatherCollectionViewList: UICollectionView?
    @IBOutlet weak var btnTempSegment: UISegmentedControl!
    @IBOutlet weak var temperature: UILabel!
    
    //MARK: - Var(s)
    private lazy var viewModel = WeatherViewModel()
    var weekForecast: [WeekWeatherInfo] = []
    var todayForeCast: [WeekWeatherInfo] = []
    var currentWeatherData: WeatherData?
    var isCelsiusSelected = true
    //MARK: - Life Cycle Method(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeViewModel()
//        performSearch(for: "London")
        weatherCollectionViewList?.dataSource = self
        weatherCollectionViewList?.delegate = self
    }
    
    //MARK: - Action Method(s)
    
    @IBAction func btnSegmentAction(_ segment: UISegmentedControl) {
        weatherCollectionViewList?.reloadData()
    }
    
    @IBAction func btnTempSegmentAction(_ segment: UISegmentedControl) {
        isCelsiusSelected = (segment.selectedSegmentIndex == 0)
        weatherCollectionViewList?.reloadData()
        if let temperatureValue = currentWeatherData?.main.temp {
            let celsiusTemperature = Utility.convertKelvinToCelsius(temperatureValue)
            let fahrenheitTemperature = Utility.celsiusToFahrenheit(celsiusTemperature)
            temperature?.text = isCelsiusSelected ? String(format: "%.0f °C", celsiusTemperature) : String(format: "%.0f °F", fahrenheitTemperature)
        }
    }
    
    @IBAction func onSearch(_ sender: Any) {
        showAlert { [weak self] city in
            self?.performSearch(for: city)
        }
    }
    
    func performSearch(for cityName: String) {
        viewModel.fetchWeeklyForecast(for: cityName)
        viewModel.fetchCurrentWeather(for: cityName)
    }
    
    func updateTemperatureLabel() {
        if let temperatureValue = currentWeatherData?.main.temp {
            let celsiusTemperature = Utility.convertKelvinToCelsius(temperatureValue)
            let roundedTemperature = isCelsiusSelected ? round(celsiusTemperature) : round(Utility.celsiusToFahrenheit(celsiusTemperature))
            temperature?.text = String(format: "%.0f °%@", roundedTemperature, isCelsiusSelected ? "C" : "F")
        }
    }
    
    func convertTemperature(_ celsius: Double) -> String {
        let roundedTemperature = round(celsius)
        return isCelsiusSelected ? String(format: "%.0f °C", roundedTemperature) : String(format: "%.0f °F", Utility.celsiusToFahrenheit(roundedTemperature))
    }
    
}

//MARK: - UI update and ViewModel Initializer

extension WeatherViewController {
    
    func initializeViewModel() {
        viewModel.reloadWeatherList = { [weak self] forecastData in
            DispatchQueue.main.async {
                self?.updateForeCastList(arrForeCastData: forecastData)
            }
        }
        
        viewModel.showWeatherData = { [weak self] cityData in
            guard let self = self else { return }
            if let cityData = cityData {
                currentWeatherData = cityData
            }
            DispatchQueue.main.async {
                self.showCityWeatherData()
            }
        }
        
        LocationManager.shared.getCurrentCity { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let cityName):
                print("📍 Current city from location: \(cityName)")
                viewModel.fetchWeeklyForecast(for: cityName)
                viewModel.fetchCurrentWeather(for: cityName)
            case .failure(let error):
                print("Failed to retrieve city: \(error.localizedDescription)")
                let fallbackCity = "Dubai"
                self.lblCity?.text = fallbackCity
                self.performSearch(for: fallbackCity)
            }
        }
    }
    
    func updateForeCastList(arrForeCastData: [WeekWeatherInfo]) {
        print("✅ Full forecast count:", arrForeCastData.count)
        weekForecast = arrForeCastData.filter({ Utility.isToday($0.dt ?? .zero) == false })
        todayForeCast = arrForeCastData.filter({ Utility.isToday($0.dt ?? .zero) == true  })
        print("📅 Today forecast count:", todayForeCast.count)
        print("📆 Week forecast count:", weekForecast.count)
        weatherCollectionViewList?.reloadData()
    }
    
    func showCityWeatherData() {
        if let timeInterval = currentWeatherData?.dt {
            lblDate?.text = Utility.getformattedDateFromTimeStamp(from: timeInterval)
        } else {
            lblDate?.text = .empty
        }
        
        if let description = currentWeatherData?.weather.first?.description {
            lblWeatherDescription?.text = description
        } else {
            lblWeatherDescription?.text = .empty
        }
        
        if let city = currentWeatherData?.name {
            lblCity?.text = city
        } else {
            lblCity?.text = .empty
        }
        if let kelvinTemp = currentWeatherData?.main.temp {
            let celsiusTemperature = Utility.convertKelvinToCelsius(kelvinTemp)
            let fahrenheitTemperature = Utility.celsiusToFahrenheit(celsiusTemperature)
            temperature?.text = isCelsiusSelected
            ? String(format: "%.2f °C", celsiusTemperature)
            : String(format: "%.2f °F", fahrenheitTemperature)
            
            updateTemperatureLabel()
        } else {
            temperature?.text = .empty
        }
        if let iconName = currentWeatherData?.weather.first?.icon, let icon = UIImage(named: iconName) {
            imgWeatherStatusPic?.image = icon
        } else {
            imgWeatherStatusPic?.image = UIImage(named: "unknown")
        }
    }
}

//MARK: - UICollectionViewDataSource Method(s)

extension WeatherViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = btnForecastSegment?.selectedSegmentIndex == 0 ? todayForeCast.count : weekForecast.count
        print("🔢 Reloading collection view with count:", count)
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherForecastCell", for: indexPath) as! WeatherForecastCell
        let isTodaySelected = btnForecastSegment?.selectedSegmentIndex == 0
        let currentListArray = isTodaySelected ? todayForeCast : weekForecast
        
        guard indexPath.row < currentListArray.count else {
            print("Index \(indexPath.row) is out of bounds for forecast array of size \(currentListArray.count)")
            return cell
        }
        
        let data = currentListArray[indexPath.row]
        
        // Weather icon
        if let iconName = data.weather.first?.icon, let icon = UIImage(named: iconName) {
            cell.imgWeatherStatusPic?.image = icon
        } else {
            cell.imgWeatherStatusPic?.image = UIImage(named: "unknown")
        }
        
        // Temperature
        if let tempInKelvin = data.main.temp {
            let tempInCelsius = Utility.convertKelvinToCelsius(tempInKelvin)
            cell.lblTemprature?.text = convertTemperature(tempInCelsius)
        } else {
            cell.lblTemprature?.text = .empty
        }
        
        // Time label
        if let timeInterval = data.dt {
            cell.lblTime?.text = isTodaySelected
            ? Utility.getformattedDateFromTimeStamp(from: timeInterval, format: .timeOnly)
            : Utility.getformattedDateFromTimeStamp(from: timeInterval)
        } else {
            cell.lblTime?.text = .empty
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentListArray = btnForecastSegment?.selectedSegmentIndex == 0 ? todayForeCast : weekForecast
        let data = currentListArray[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier:  "WeatherDetailViewController" ) as! WeatherDetailViewController
        vc.weekForecast = data
        vc.currentWeatherData = currentWeatherData
        vc.isCelsiusSelected = isCelsiusSelected
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - //MARK: - UICollectionViewDataSource Method(s)

extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let colllectionViewHeight = collectionView.bounds.size.height
        let colllectionViewWidth = collectionView.bounds.size.width / 5
        return CGSize(width: colllectionViewWidth, height: colllectionViewHeight)
    }
}
