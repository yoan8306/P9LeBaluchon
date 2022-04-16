//
//  WeatherLocalization.swift
//  Le Baluchon
//
//  Created by Yoan on 14/04/2022.
//

import Foundation

class WeatherLocalization {
    var listCityName = ["New York"]
    var arrayWeatherData: [WeatherDTO] = []

    func addNewLocalization(cityName: String) {
        listCityName.append(cityName)
    }

    func addNewDataWeather(weatherData: WeatherDTO) {
        arrayWeatherData.append(weatherData)
    }
}
