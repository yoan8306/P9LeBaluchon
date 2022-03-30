//
//  Weather.swift
//  Le Baluchon
//
//  Created by Yoan on 25/03/2022.
//

import Foundation

struct WeatherJson: Decodable {
    let name: String?
    let coord: Coord?
    let weather: [Weather?]
    let main: Main?
    let wind: Wind?
    let sys: Sys?

    struct Coord: Decodable {
        let lon: Float
        let lat: Float
    }

//    swiftlint:disable identifier_name
    struct Weather: Decodable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }

    struct Main: Decodable {
        let temp: Float
        let feels_like: Float
        let temp_min: Float
        let temp_max: Float
        let pressure: Int
        let humidity: Float
    }

    struct Wind: Decodable {
        let speed: Float
    }

    struct Sys: Decodable {
        let type: Int
        let id: Int
        let country: String
        let sunrise: Int
        let sunset: Int
    }
}
