//
//  FakeResponseWeather.swift
//  Le BaluchonTests
//
//  Created by Yoan on 12/04/2022.
//

import Foundation

class FakeResponseWeatherData {

    // non utilisé `responseOK` `responseFailed`

    // MARK: - Response
    let responseOK = HTTPURLResponse(url: URL(string: "https://duckduckgo.com")!,
                                     statusCode: 200,
                                     httpVersion: nil,
                                     headerFields: nil)
    let responseFailed = HTTPURLResponse(url: URL(string: "https://duckduckgo.com")!,
                                         statusCode: 500,
                                         httpVersion: nil,
                                         headerFields: nil)

    // MARK: - Error
    class WeatherError: Error {}
    let weatherError = WeatherError()

    // MARK: - Data
    var weatherCorrectData: Data {
        let bundle = Bundle(for: FakeResponseWeatherData.self)
        let url = bundle.url(forResource: "Weather", withExtension: "json")
        //        swiftlint:disable force_try
        let data = try! Data(contentsOf: url!)
        return data
    }

    var weatherIncorrectData = "i'm bad json".data(using: .utf8)
}
