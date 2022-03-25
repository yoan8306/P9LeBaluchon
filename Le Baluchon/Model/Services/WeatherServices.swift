//
//  WeatherServices.swift
//  Le Baluchon
//
//  Created by Yoan on 25/03/2022.
//

import Foundation

class WeatherServices {
    static let shared = WeatherServices()
    private init() {}
    private static let urlAirCondition = URL(string: "http://api.openweathermap.org/data/2.5/air_pollution")
    
    func getWeather(cityLat: Float, cityLong: Float, completion: @escaping (Result<WeatherJson, Error>) -> Void) {
        var urlWeatherCondition = URLComponents()
        urlWeatherCondition.scheme = "https"
        urlWeatherCondition.host = "api.openweathermap.org"
        urlWeatherCondition.path = "/data/2.5/weather"
        urlWeatherCondition.queryItems = [
        URLQueryItem(name: "lat", value: String(cityLat)),
        URLQueryItem(name: "lon", value: String(cityLong)),
        URLQueryItem(name: "units", value: "metric"),
        URLQueryItem(name: "appid", value: ApiKeys.weather)
        ]
        guard let urlWeatherCondition = urlWeatherCondition.url else {
            return
        }
         SessionTask.shared.sendTask(url: urlWeatherCondition) { result in
             switch result {
             case .success(let data):
                 guard let weatherCondition = try? JSONDecoder().decode(WeatherJson.self, from: data) else {
                     completion(.failure(APIError.decoding))
                     return
                 }
                 completion(.success(weatherCondition))
             case .failure(let error):
                 completion(.failure(error))
             }
         }
     }
    
    func getCoordLocalisation(cityName: String?, completion: @escaping (Result<Data, Error>) -> Void) {
        var urlNameCity = URLComponents()
        urlNameCity.scheme = "http"
        urlNameCity.host = "api.openweathermap.org"
        urlNameCity.path = "/geo/1.0/direct"
        urlNameCity.queryItems = [
           URLQueryItem(name: "q", value: cityName),
           URLQueryItem(name: "limit", value: String(1)),
           URLQueryItem(name: "appid", value: ApiKeys.weather)
        ]
        guard let urlNameCity = urlNameCity.url else {
            return
        }
        SessionTask.shared.sendTask(url: urlNameCity) { result in
            switch result {
            case .success(let data):
                guard let coord = try? JSONDecoder().decode(String.self, from: data) else {
                    completion(.success(data))
                    return
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
