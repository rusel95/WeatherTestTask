//
//  ResultViewController.swift
//  WeatherTestTask
//
//  Created by Admin on 05.05.17.
//  Copyright © 2017 rusel95. All rights reserved.
//

import UIKit
import GoogleMaps

class ResultViewController: UIViewController {

    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var cloudiness: UILabel!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var visibility: UILabel!
    @IBOutlet weak var barometer: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var sunrise: UILabel!
    @IBOutlet weak var sunset: UILabel!
    
    var placeForWeather = Place(name: "0", address: "0", location: CLLocationCoordinate2D(latitude: 0, longitude: 0) ) {
        
        didSet {
            WeatherApi.shared.getWeatherData(location: placeForWeather.location!) { weatherResponse in
                if weatherResponse != nil {
                    self.cityName?.text = self.placeForWeather.address
                    self.temp?.text = weatherResponse?.temp!
                    self.weatherDescription?.text = weatherResponse?.weatherDescription
                    self.cloudiness?.text = weatherResponse?.cloudiness!
                    self.wind?.text = weatherResponse?.windSpeed
                    self.visibility?.text = weatherResponse?.visibility
                    self.barometer?.text = weatherResponse?.pressure!
                    self.humidity?.text = weatherResponse?.humidity!
                    self.sunrise?.text = weatherResponse?.sunrise
                    self.sunset?.text = weatherResponse?.sunset
                    
                    
                } else {
                    HelperInstance.shared.createAlert(title: "OoOops..", message: "Looks like mistake while weather request", currentView: self, controllerToDismiss: self.navigationController!)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
