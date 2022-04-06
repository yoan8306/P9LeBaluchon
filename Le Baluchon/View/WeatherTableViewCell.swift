//
//  WeatherTableViewCell.swift
//  Le Baluchon
//
//  Created by Yoan on 05/04/2022.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var descriptionWeatherLabel: UILabel!
    @IBOutlet weak var whiteView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        addShadow()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func configureCellWeather(city: String?, temp: Float?, tempMin: Float?,
                              tempMax: Float?, sunrise: Int?, sunset: Int? ,
                              weatherIcon: String?, description: String?) {
        guard let city = city,
              let temp = temp,
              let tempMin = tempMin,
              let tempMax = tempMax,
              let sunrise = sunrise,
              let sunset = sunset,
              let weatherIcon = weatherIcon,
              let description = description  else {
                  return
              }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        cityLabel.text = city
        tempLabel.text = "\(temp) °c"
        tempMaxLabel.text = "Temp max: \(tempMax)°c"
        tempMinLabel.text = "Temp min: \(tempMin)°c"
        sunriseLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(sunrise)))
        sunsetLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(sunset)))
        weatherImage.image = UIImage(named: weatherIcon)
        descriptionWeatherLabel.text = description
    }

    private func addShadow() {
        whiteView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).cgColor
        whiteView.layer.shadowRadius = 2.0
        whiteView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        whiteView.layer.shadowOpacity = 2.0
    }

}
