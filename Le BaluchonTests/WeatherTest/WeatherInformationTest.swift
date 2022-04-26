//
//  WeatherLocalizationTest.swift
//  Le BaluchonTests
//
//  Created by Yoan on 19/04/2022.
//

import XCTest
@testable import Le_Baluchon

class WeatherInformationTest: XCTestCase {

    func testGivenCorrectDataWeather_WhenAddIntoArray_ThenAllDataAreAvailable() {
        let weatherDTO = FakeResponseWeatherData()
        var listWeather: WeatherDTO {
            try! XCTUnwrap(try JSONDecoder().decode(WeatherDTO.self, from: weatherDTO.weatherCorrectData))
        }
        
        let weatherInfo = WeatherInformation()

        weatherInfo.addNewDataWeather(weatherData: listWeather)

        XCTAssertEqual(weatherInfo.arrayWeatherData[0].sys?.country, "FR")
    }
}
