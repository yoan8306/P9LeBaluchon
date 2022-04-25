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

    // MARK: - IBOutlet
    @IBOutlet weak var localizeButtonUIView: UIView!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var weatherTableView: UITableView!

    // MARK: - Lyfe cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let newYorkCity = "New York"
        callWeatherServices(city: newYorkCity)
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

    @IBAction func userLocalizationActionButton(_ sender: UIButton) {
        localizeButtonUIView.isHidden = true
        cityTextField.resignFirstResponder()
        userLocationRequest()
    }

    // MARK: - private functions
    // le city ne devrait pas être optionnel
    private func callWeatherServices(city: String?) {
        activityIndicator.isHidden = false
        guard let city = city else {
            return
        }
        WeatherServices.shared.getWeatherJson(city: city) { result in

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

    private func initializeView() {

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
            // tu peux direct faire `let city = places?.first?.locality`
            guard let city = myPlace.locality else {
                return
            }
            self.callWeatherServices(city: city)
        }
    }
}

// MARK: - Extension UItextField delegate
extension WeatherViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let city = cityTextField.text, city.isEmpty == false, city.count > 3 else {
            presentAlert(alertMessage: "Veuillez entrer un nom de ville correcte")
            
            // déplace ce code avant le guard, tu le fait 2 fois.
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

        if indexpath.row > 0 {
            if editingStyle == .delete {
                weatherInfo.arrayWeatherData.remove(at: indexpath.row)
                tableView.deleteRows(at: [indexpath], with: .right)
            }
        }
    }
}
