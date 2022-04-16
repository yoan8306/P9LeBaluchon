//
//  WeatherLocalization.swift
//  Le Baluchon
//
//  Created by Yoan on 14/04/2022.
//

import Foundation

class WeatherLocalization {
    var arrayWeatherData: [WeatherDTO] = []

    func addNewDataWeather(weatherData: WeatherDTO) {
        arrayWeatherData.append(weatherData)
    }
}
