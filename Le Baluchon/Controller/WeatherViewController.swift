//
//  WeatherViewController.swift
//  Le Baluchon
//
//  Created by Yoan on 15/03/2022.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        WeatherServices.shared.getWeather(cityLat: 43.30148780000000, cityLong: 5.548001012099657) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let myWeather):
                print("Successfuly----\(myWeather.name)")
                
            case .failure(let error):
                print("_________Error______ \(error.localizedDescription)")
            }
        }
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
