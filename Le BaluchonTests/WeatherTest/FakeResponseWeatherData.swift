//
//  FakeResponseWeather.swift
//  Le BaluchonTests
//
//  Created by Yoan on 12/04/2022.
//

import Foundation

class FakeResponseWeatherData {
// MARK: - Error
    class WeatherError: Error {}
    let weatherError = WeatherError()

// MARK: - Data
    var weatherCorrectData: Data {
        let bundle = Bundle(for: FakeResponseWeatherData.self)
        let url = bundle.url(forResource: "Weather", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    var weatherIncorrectData = "i'm bad json".data(using: .utf8)
}
