//
//  Weather.swift
//  Le Baluchon
//
//  Created by Yoan on 25/03/2022.
//

import Foundation

struct WeatherDTO: Decodable {
    let name: String?
    let weather: [Weather?]
    let main: Main?
    let sys: Sys?
    let timezone: Int?
    
    struct Weather: Decodable {
        let description: String
        let icon: String
    }

    struct Main: Decodable {
        let temp: Float
        let temp_min: Float
        let temp_max: Float
    }

    struct Sys: Decodable {
        let country: String
        let sunrise: Int
        let sunset: Int
    }
}
