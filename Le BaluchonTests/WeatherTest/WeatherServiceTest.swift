//
//  WeatherServiceTest.swift
//  Le BaluchonTests
//
//  Created by Yoan on 16/04/2022.
//

import XCTest
@testable import Le_Baluchon
// swiftlint:disable force_try

class WeatherServiceTest: XCTestCase {

    func testGivenCallWeatherService_WhenDataIsCorrect_ThenResultEqualSuccess () {
        let session = SessionTaskMock()
        let weatherService = WeatherServices(sessionTask: session)
        let response = FakeResponseWeatherData()
        
        session.data = response.weatherCorrectData

        weatherService.getWeatherJson(city: "Marseille") { result in
            switch result {
            case .success(let response):
                let tempMax = try! XCTUnwrap(response.main?.temp_max)
                XCTAssertEqual(20.1, tempMax)
            case .failure:
                fatalError()
            }
        }
    }

    func testGivenCallWeather_WhenDataIsIncorrect_ThenReturnError() {
        let session = SessionTaskMock()
        let weatherService = WeatherServices(sessionTask: session)
        let response = FakeResponseWeatherData()
        
        session.data = response.weatherIncorrectData

        weatherService.getWeatherJson(city: "Marseille") { result in
            switch result {
            case .success:
               fatalError()
            case .failure(let error):
                XCTAssertTrue(error.localizedDescription.isEmpty == false)
            }
        }
    }
}
