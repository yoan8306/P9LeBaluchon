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
    var weatherInfo = WeatherInformation()
    var getUserLocated = false

    // MARK: - IBOutlet
    @IBOutlet weak var localizeButtonUIView: UIView!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var weatherTableView: UITableView!

    // MARK: - Lyfe cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let newYorkCity = "New York"
        weatherServices(city: newYorkCity)
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

    /// Get user localization
    /// - Parameter sender: UIButton "Detect position"
    @IBAction func userLocalizationActionButton(_ sender: UIButton) {
        localizeButtonUIView.isHidden = true
        cityTextField.resignFirstResponder()
        getUserLocated = true
        userLocationRequest()
    }

    // MARK: - private functions
    /// Get weather information on API
    /// - Parameter city: city name
    private func weatherServices(city: String) {
        activityIndicator.isHidden = false
        WeatherServices.shared.getWeatherJson(city: city) {[weak self] result in
            guard let self = self else {
                return
            }

            switch result {
            case .success(let weatherInfo):
                self.weatherInfo.addNewDataWeather(weatherData: weatherInfo)
                self.weatherTableView.reloadData()
                self.activityIndicator.isHidden = true
            case .failure(let error):
                self.activityIndicator.isHidden = true
                self.presentAlert(alertMessage: error.localizedDescription)
            }
        }
    }
}

// MARK: - Extension location Manager Delegate

extension WeatherViewController: CLLocationManagerDelegate {
    private func userLocationRequest() {
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            self.getCityName(location: locations)
    }

    /// get city name with location and stop updating location
    /// - Parameter location: data user location
    func getCityName(location: [CLLocation]) {
        activityIndicator.isHidden = false
        guard let firstLocation = location.first else {
            return
        }

        CLGeocoder().reverseGeocodeLocation(firstLocation) { places, _ in
            guard let city = places?.first?.locality, self.getUserLocated else {
                return
            }
            self.weatherServices(city: city)
            self.getUserLocated = false
            self.locationManager.stopUpdatingLocation()
        }
    }
}

// MARK: - Extension UITextField delegate
extension WeatherViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        cityTextField.resignFirstResponder()

        guard let city = cityTextField.text, city.isEmpty == false, city.count > 3 else {
            presentAlert(alertMessage: "Please enter a correct city name."
                         + "\nif necessary specify the country code like this:"
                         + "\nFor France -> FR"
                         + "\nFor America -> US.")
            localizeButtonUIView.isHidden = true
            return true
        }

        localizeButtonUIView.isHidden = true
        weatherServices(city: city)
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        localizeButtonUIView.isHidden = false
    }
}

// MARK: - tableView DataSource

extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return weatherInfo.arrayWeatherData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let weatherData = weatherInfo.arrayWeatherData[indexPath.row]

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath)
                as? WeatherTableViewCell else {
                    return UITableViewCell()
                }
        cell.configureCellWeather(weatherData: weatherData)
        cell.layer.cornerRadius = 10
        return cell
    }
}

// MARK: - TableViewDelegate

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexpath: IndexPath) {

        if indexpath.row > 0, editingStyle == .delete {
            weatherInfo.arrayWeatherData.remove(at: indexpath.row)
            tableView.deleteRows(at: [indexpath], with: .right)
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row > 0
    }

}
