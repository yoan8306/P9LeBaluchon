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
    
    func getWeatherJson(city: String?, completionHandler: @escaping (Result<WeatherJson, Error>) -> Void) {
        var urlWeatherCondition = URLComponents()
        
        guard let city = city else {
            return
        }
       
        urlWeatherCondition.scheme = "https"
        urlWeatherCondition.host = "api.openweathermap.org"
        urlWeatherCondition.path = "/data/2.5/weather"
        urlWeatherCondition.queryItems = [
        URLQueryItem(name: "q", value: city),
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
                     completionHandler(.failure(APIError.decoding))
                     return
                 }
                 completionHandler(.success(weatherCondition))
             case .failure(let error):
                 completionHandler(.failure(error))
             }
         }
     }
    
    
}
