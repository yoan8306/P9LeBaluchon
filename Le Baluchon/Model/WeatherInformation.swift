//
//  WeatherLocalization.swift
//  Le Baluchon
//
//  Created by Yoan on 14/04/2022.
//

import Foundation

/// stock weather data in array for list in tableView
class WeatherInformation {
    var arrayWeatherData: [WeatherDTO] = []

    func addNewDataWeather(weatherData: WeatherDTO) {
        arrayWeatherData.append(weatherData)
    }
}
