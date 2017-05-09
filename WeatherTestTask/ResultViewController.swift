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
            WeatherApi.shared.getWeatherData(location: placeForWeather.location!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
