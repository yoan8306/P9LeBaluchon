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
    var newYorkCity = "New York"

    @IBOutlet weak var weatherUIView: UIView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var uiViewButton: UIView!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var descriptionWeatherLabel: UILabel!

    // MARK: - Lyfe cycle
    override func viewDidLoad() {
        callWeatherServices(city: newYorkCity)
        super.viewDidLoad()
        uiViewButton.isHidden = true
        weatherUIView.isHidden = true
    }

    // MARK: - @IBAction
    @IBAction func dissmissKeyboard(_ sender: UITapGestureRecognizer) {
        uiViewButton.isHidden = true
        cityTextField.resignFirstResponder()
    }

    @IBAction func userLocalisationActionButton(_ sender: UIButton) {
        cityTextField.resignFirstResponder()
        uiViewButton.isHidden = true
        userLocationRequest()
    }

    // MARK: - private functions

    private func callWeatherServices(city: String) {
        WeatherServices.shared.getWeatherJson(city: city) { result in

            switch result {
            case .success(let myWeather):
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEE d HH:mm"
                self.cityLabel.text = "\(myWeather.name ?? "no city"), \(myWeather.sys?.country ?? "no country")"
                self.weatherImage.image = UIImage(named: myWeather.weather.first??.icon ?? "questionmark")
                self.tempLabel.text =  String(myWeather.main?.temp ?? 0) + "°c"
                self.tempMaxLabel.text = "Temp Max: " + String(myWeather.main?.temp_max ?? 0) + "°c"
                self.tempMinLabel.text = "Temp Min: " + String(myWeather.main?.temp_min ?? 0) + "°c"
                self.sunriseLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(myWeather.sys?.sunrise ?? 00)))
                self.sunsetLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(myWeather.sys?.sunset ?? 00)))
                self.descriptionWeatherLabel.text = myWeather.weather.first??.description ?? "no data"
                self.showUIViewWeather()
            case .failure(let error):
                self.presentAlert(alertMessage: error.localizedDescription)
            }
        }
    }
    private func showUIViewWeather() {
        weatherUIView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        weatherUIView.isHidden = false
        UIView.transition(with: weatherUIView.self, duration: 0.6, options: .curveEaseIn, animations: {
            self.weatherUIView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }

    private func presentAlert (alertTitle title: String = "Error", alertMessage message: String,
                               buttonTitle titleButton: String = "Ok",
                               alertStyle style: UIAlertAction.Style = .cancel ) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: titleButton, style: style, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }

}

// MARK: - Extension location Manager Delegate

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

// MARK: - Extension UItexteField delegate
extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let city = cityTextField.text else {
            cityTextField.resignFirstResponder()
            return true
        }
        cityTextField.resignFirstResponder()
        uiViewButton.isHidden = true
        callWeatherServices(city: city)
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        uiViewButton.isHidden = false
    }
}
