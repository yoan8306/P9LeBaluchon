//
//  WeatherServices.swift
//  Le Baluchon
//
//  Created by Yoan on 25/03/2022.
//

import Foundation

class WeatherServices {
    static let shared = WeatherServices(sessionTask: SessionTask.shared)
    var sessionTask: SessionTaskProtocol

    init(sessionTask: SessionTaskProtocol) {
        self.sessionTask = sessionTask
    }

    func getWeatherJson(city: String?, completionHandler: @escaping (Result<WeatherDTO, Error>) -> Void) {
        var urlWeatherInfos = URLComponents()

        guard let city = city else {
            return
        }

        urlWeatherInfos.scheme = "https"
        urlWeatherInfos.host = "api.openweathermap.org"
        urlWeatherInfos.path = "/data/2.5/weather"
        urlWeatherInfos.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: ApiKeys.weatherKey)
        ]

        guard let urlWeatherInfos = urlWeatherInfos.url else {
            return
        }

        sessionTask.sendTask(url: urlWeatherInfos) { result in
            switch result {
            case .success(let data):
                guard let weatherInfo = try? JSONDecoder().decode(WeatherDTO.self, from: data) else {
                    completionHandler(.failure(APIError.decoding))
                    return
                }
                completionHandler(.success(weatherInfo))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
