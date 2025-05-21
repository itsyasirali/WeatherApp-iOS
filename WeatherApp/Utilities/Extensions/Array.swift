//
//  Array.swift
//  WeatherApp
//
//  Created by Revolutic on 20/05/2025.
//

extension Array where Element == WeekWeatherInfo {
    func filterTodayAndWeek() -> (today: [Element], week: [Element]) {
        let today = self.filter { Utility.isToday($0.dt ?? .zero) }
        let week = self.filter { !Utility.isToday($0.dt ?? .zero) }
        return (today, week)
    }
}
