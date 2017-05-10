//
//  ResultViewController.swift
//  WeatherTestTask
//
//  Created by Admin on 05.05.17.
//  Copyright © 2017 rusel95. All rights reserved.
//

import UIKit
import GoogleMaps
import RealmSwift

fileprivate var isFirstCallAfterStart = true
fileprivate var defaultPlace = Place()

class ResultViewController: UIViewController, SettingsViewControllerDelegate, SearchViewControllerDelegate {
    
    func doSomething(with place: Place) {
        placeForWeather = place
    }
    
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
        searchVC.delegate = self
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @IBAction func settingsButton(_ sender: UIBarButtonItem) {
        let settingsVC = self.storyboard?.instantiateViewController(withIdentifier: "settingsVC") as! SettingsViewController
        settingsVC.delegate = self
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
    
    var placeForWeather = Place() {
        didSet {
            getWeatherInCity()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaultPlace.setPlace(name: "Dnipro", address: "Dnipropetrovska oblast", latitude: 48.4686, longitude: 35.0357)
        
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
                let lastSearchedPlace = Place()
                    lastSearchedPlace.setPlace(name: (lastRealmPlace?.name)!, address: (lastRealmPlace?.address)!, latitude: (lastRealmPlace?.latitude)!, longitude: (lastRealmPlace?.longitude)!)
                placeForWeather = lastSearchedPlace
                isFirstCallAfterStart = false
            }
            
        }
    }
    
    fileprivate func getWeatherInCity() {
        
        if HelperInstance.shared.isInternetAvailable() {
            
            WeatherApi.shared.getWeatherData(latitude: placeForWeather.latitude, longitude: placeForWeather.longitude) { weatherResponse in
                
                if weatherResponse != nil {
                    self.activityIndicator?.stopAnimating()
                    //add place to realm
                    RealmCRUD.shared.write(somePlace: self.placeForWeather)
                    
                    self.fillViewWith(weather: weatherResponse!)
                    
                } else {
                    HelperInstance.shared.createAlert(title: "OoOops..", message: "Looks like mistake while weather request", currentView: self)
                }
            }
        } else {
            HelperInstance.shared.createAlert(title: "OoOops..", message: "Looks like there is no internet connection. Please, try to establish an internet connection!", currentView: self)
        }
    }
    
    fileprivate func fillViewWith(weather: WeatherResponse) {
        self.cityName?.text = self.placeForWeather.address
        self.weatherIcon.setWithImageWithKey(key: (weather.weatherDescription)!)
        self.temp?.text = weather.temp!
        self.weatherDescription?.text = weather.weatherDescription
        self.cloudiness?.text = weather.cloudiness!
        self.wind?.text = weather.windSpeed
        self.visibility?.text = weather.visibility
        self.barometer?.text = weather.pressure!
        self.humidity?.text = weather.humidity!
        self.sunrise?.text = weather.sunrise
        self.sunset?.text = weather.sunset
    }
    
}
