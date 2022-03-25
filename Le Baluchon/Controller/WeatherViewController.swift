//
//  WeatherViewController.swift
//  Le Baluchon
//
//  Created by Yoan on 15/03/2022.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       userLocationRequest()
    }
    
    private func callWeatherServices(city: String) {
        WeatherServices.shared.getWeatherJson(city: city) { result in
            
            switch result {
            case .success(let myWeather):
                print("Successfuly----\(myWeather.name)")
                print(myWeather.sys?.country)
                
            case .failure(let error):
                print("_________Error______ \(error.localizedDescription)")
            }
        }
    }
    
}

extension WeatherViewController: CLLocationManagerDelegate {
    private func userLocationRequest() {
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let firstLocation = locations.first else {
            return
        }
        CLGeocoder().reverseGeocodeLocation(firstLocation) { places, _ in
            guard let firstPlace = places?.first else {
                return
            }
            guard let cityName = firstPlace.locality else {
                return
            }
            self.callWeatherServices(city: cityName)
        }
        locationManager.stopUpdatingLocation()
    }
}
