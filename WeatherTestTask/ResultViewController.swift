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
