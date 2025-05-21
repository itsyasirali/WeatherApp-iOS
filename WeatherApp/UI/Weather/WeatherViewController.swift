//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Revolutic on 20/05/2025.
//  Copyright © 2025 Revolutic LLC. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCity: UILabel?
    @IBOutlet weak var lblWeatherDescription: UILabel!
    @IBOutlet weak var imgWeatherStatusPic: UIImageView?
    @IBOutlet weak var btnForecastSegment: UISegmentedControl?
    @IBOutlet weak var weatherCollectionViewList: UICollectionView?
    @IBOutlet weak var btnTempSegment: UISegmentedControl!
    @IBOutlet weak var temperature: UILabel!
    
    //MARK: - Var
    private lazy var viewModel = WeatherViewModel()
    var weekForecast: [WeekWeatherInfo] = []
    var todayForeCast: [WeekWeatherInfo] = []
    var currentWeatherData: WeatherData?
    var isCelsiusSelected = true
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeViewModel()
        weatherCollectionViewList?.dataSource = self
        weatherCollectionViewList?.delegate = self
    }
    
    //MARK: - Action Methods
    
    @IBAction func btnSegmentAction(_ segment: UISegmentedControl) {
        weatherCollectionViewList?.reloadData()
    }
    
    @IBAction func btnTempSegmentAction(_ segment: UISegmentedControl) {
        isCelsiusSelected = (segment.selectedSegmentIndex == .zero)
        weatherCollectionViewList?.reloadData()
        temperature?.text = Utility.formattedTemperature(currentWeatherData?.main.temp, isCelsius: isCelsiusSelected)
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
                log("Current city from Corelocation: \(cityName)", tag: "WeatherViewController")
                viewModel.fetchWeeklyForecast(for: cityName)
                viewModel.fetchCurrentWeather(for: cityName)
            case .failure(let error):
                log("Failed to retrieve city from CoreLocation: \(error.localizedDescription)", tag: "WeatherViewController")
                let fallbackCity = "Dubai"
                self.lblCity?.text = fallbackCity
                self.performSearch(for: fallbackCity)
            }
        }
    }
    
    func updateForeCastList(arrForeCastData: [WeekWeatherInfo]) {
        let (today, week) = arrForeCastData.filterTodayAndWeek()
            todayForeCast = today
            weekForecast = week
            weatherCollectionViewList?.reloadData()
    }
    
    func showCityWeatherData() {
        lblDate?.text = currentWeatherData?.dt != nil
                ? Utility.getformattedDateFromTimeStamp(from: currentWeatherData!.dt)
                : .empty
            lblWeatherDescription?.text = currentWeatherData?.weather.first?.description ?? .empty
            lblCity?.text = currentWeatherData?.name ?? .empty
            temperature?.text = Utility.formattedTemperature(currentWeatherData?.main.temp, isCelsius: isCelsiusSelected)
            imgWeatherStatusPic?.image = Utility.image(for: currentWeatherData?.weather.first?.icon)
    }
}

//MARK: - UICollectionViewDataSource Method(s)

extension WeatherViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = btnForecastSegment?.selectedSegmentIndex == .zero ? todayForeCast.count : weekForecast.count
        log("Reloading collection view with count: \(count)", tag: "WeatherViewController")
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherForecastCell", for: indexPath) as! WeatherForecastCell
        let isTodaySelected = btnForecastSegment?.selectedSegmentIndex == .zero
        let currentListArray = isTodaySelected ? todayForeCast : weekForecast
        
        guard indexPath.row < currentListArray.count else {
            log("Index \(indexPath.row) is out of bounds for forecast array of size \(currentListArray.count)", tag: "WeatherViewController")
            return cell
        }
        
        let data = currentListArray[indexPath.row]
        cell.imgWeatherStatusPic?.image = Utility.image(for: data.weather.first?.icon)
        cell.lblTemprature?.text = Utility.formattedTemperature(data.main.temp, isCelsius: isCelsiusSelected)
        cell.lblTime?.text = data.dt != nil
            ? (isTodaySelected
                ? Utility.getformattedDateFromTimeStamp(from: data.dt!, format: .timeOnly)
                : Utility.getformattedDateFromTimeStamp(from: data.dt!))
            : .empty
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentListArray = btnForecastSegment?.selectedSegmentIndex == .zero ? todayForeCast : weekForecast
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
