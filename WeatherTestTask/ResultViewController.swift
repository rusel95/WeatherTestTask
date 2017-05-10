//
//  ResultViewController.swift
//  WeatherTestTask
//
//  Created by Admin on 05.05.17.
//  Copyright © 2017 rusel95. All rights reserved.
//

import UIKit
import GoogleMaps

fileprivate var isFirstCallAfterStart = true

class ResultViewController: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        print("Init_ResultViewController")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        print("Init_ResultViewController")
    }
    
    deinit {
        print("deinit_ResultViewController")
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func searchButton(_ sender: UIBarButtonItem) {
        let searchVC = self.storyboard?.instantiateViewController(withIdentifier: "searchVC") as! SearchViewController
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @IBAction func settingsButton(_ sender: UIBarButtonItem) {
        let settingsVC = self.storyboard?.instantiateViewController(withIdentifier: "settingsVC") as! SettingsViewController
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
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
    
    fileprivate let defaultPlace = Place(name: "Dnipro", address: "Dnipro", latitude: 48.45, longitude: 34.983)
    
    var placeForWeather = Place(name: "", address: "", latitude: 0.0, longitude: 0.0) {
        
        didSet {
            
            if HelperInstance.shared.isInternetAvailable() {
                WeatherApi.shared.getWeatherData(latitude: placeForWeather.latitude!, longitude: placeForWeather.longitude!) { weatherResponse in
                    if weatherResponse != nil {
                        self.activityIndicator?.stopAnimating()
                        
                        self.cityName?.text = self.placeForWeather.address
                        self.weatherIcon.setWithImageWithKey(key: (weatherResponse?.weatherDescription)!)
                        self.temp?.text = weatherResponse?.temp!
                        self.weatherDescription?.text = weatherResponse?.weatherDescription
                        self.cloudiness?.text = weatherResponse?.cloudiness!
                        self.wind?.text = weatherResponse?.windSpeed
                        self.visibility?.text = weatherResponse?.visibility
                        self.barometer?.text = weatherResponse?.pressure!
                        self.humidity?.text = weatherResponse?.humidity!
                        self.sunrise?.text = weatherResponse?.sunrise
                        self.sunset?.text = weatherResponse?.sunset
                        
                        //add place to realm
                        RealmCRUD.shared.write(somePlace: self.placeForWeather)
                    } else {
                        HelperInstance.shared.createAlert(title: "OoOops..", message: "Looks like mistake while weather request", currentView: self)
                    }
                }
            } else {
                HelperInstance.shared.createAlert(title: "OoOops..", message: "Looks like there is no internet connection. Please, try to establish an internet connection!", currentView: self)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadDefaultOrLastCity()
    }
    
}

extension ResultViewController {
    
    func downloadDefaultOrLastCity() {
        if isFirstCallAfterStart == true {
            if RealmCRUD.shared.queryRealmPlacesToArray().count == 0 {
                placeForWeather = defaultPlace
                isFirstCallAfterStart = false
            } else {
                let lastRealmPlace = RealmCRUD.shared.queryRealmPlacesToArray().last
                let lastSearchedPlace = Place(name: (lastRealmPlace?.name)!, address: (lastRealmPlace?.address)!, latitude: (lastRealmPlace?.latitude)!, longitude: (lastRealmPlace?.longitude)!)
                placeForWeather = lastSearchedPlace
                isFirstCallAfterStart = false
            }
            
        }
    }
    
}
