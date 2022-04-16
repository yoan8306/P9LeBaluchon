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
    var arrayDataWeather: [WeatherDTO] = []
    var weatherLocalisation = WeatherLocalization()

    // MARK: - IBOutlet
    @IBOutlet weak var localizeButtonUIView: UIView!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var weatherTableView: UITableView!

    // MARK: - Lyfe cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        callWeatherServices(city: weatherLocalisation.listCityName.first)
        localizeButtonUIView.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        weatherTableView.reloadData()
    }

    // MARK: - @IBAction
    @IBAction func dissmissKeyboard(_ sender: UITapGestureRecognizer) {
        localizeButtonUIView.isHidden = true
        cityTextField.resignFirstResponder()
    }

    @IBAction func userLocalisationActionButton(_ sender: UIButton) {
        localizeButtonUIView.isHidden = true
        cityTextField.resignFirstResponder()
        userLocationRequest()
    }

    // MARK: - private functions
    private func callWeatherServices(city: String?) {
        activityIndicator.isHidden = false
        guard let city = city else {
            return
        }
        WeatherServices.shared.getWeatherJson(city: city) { result in

            switch result {
            case .success(let myWeather):
                self.weatherLocalisation.arrayWeatherData.append(myWeather)
                self.weatherTableView.reloadData()
                self.activityIndicator.isHidden = true
            case .failure(let error):
                self.activityIndicator.isHidden = true
                self.presentAlert(alertMessage: error.localizedDescription)
            }
        }
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
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            self.getCityName(location: locations)
    }

    func getCityName(location: [CLLocation]) {
        activityIndicator.isHidden = false
        guard let firstLocation = location.first else {
            return
        }
        locationManager.stopUpdatingLocation()
        CLGeocoder().reverseGeocodeLocation(firstLocation) { places, _ in

            guard let myPlace = places?.first else {
                return
            }
            guard let city = myPlace.locality else {
                return
            }
            self.callWeatherServices(city: city)
        }
    }
}

// MARK: - Extension UItexteField delegate
extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let city = cityTextField.text else {
            cityTextField.resignFirstResponder()
            localizeButtonUIView.isHidden = true
            return true
        }
        cityTextField.resignFirstResponder()
        localizeButtonUIView.isHidden = true
        callWeatherServices(city: city)
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        localizeButtonUIView.isHidden = false
    }
}

// MARK: - tableView DataSource

extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return weatherLocalisation.arrayWeatherData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let weatherData = weatherLocalisation.arrayWeatherData[indexPath.row]

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath)
                as? WeatherTableViewCell else {
                    return UITableViewCell()
                }
        cell.configureCellWeather(weatherData: weatherData)
        return cell
    }
}
