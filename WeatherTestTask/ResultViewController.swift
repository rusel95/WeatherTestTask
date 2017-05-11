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
    
    func doSomething(with weather: WeatherResponse) {
        fillViewWith(weather: weather)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeNavBarCool()
        
        downloadDefaultOrLastCity()
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
}

extension ResultViewController {
    
    func makeNavBarCool() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "launch1.png"), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Optima", size: 20)!,
                                                                         NSForegroundColorAttributeName: UIColor(red: 87, green: 143, blue: 220, alpha: 1) ]
    }
    
    fileprivate func downloadDefaultOrLastCity() {
        
        defaultPlace.setPlace(name: "Dnipro", address: "Dnipropetrovska oblast", latitude: 48.4686, longitude: 35.0357)
        
        if isFirstCallAfterStart == true {
            if RealmCRUD.shared.queryRealmPlacesToArray().count == 0 {
                getWeather(in: defaultPlace)
                isFirstCallAfterStart = false
            } else {
                let lastRealmPlace = RealmCRUD.shared.queryRealmPlacesToArray().last
                let lastSearchedPlace = Place()
                    lastSearchedPlace.setPlace(name: (lastRealmPlace?.name)!, address: (lastRealmPlace?.address)!, latitude: (lastRealmPlace?.latitude)!, longitude: (lastRealmPlace?.longitude)!)
                getWeather(in: lastSearchedPlace)
                isFirstCallAfterStart = false
            }
        }
    }
    
    fileprivate func getWeather(in place: Place) {
        
        self.activityIndicator.startAnimating()
        WeatherApi.shared.getWeatherData(latitude: place.latitude, longitude: place.longitude) { weatherResponse in
            
            self.activityIndicator.stopAnimating()
            if weatherResponse != nil {
                RealmCRUD.shared.write(somePlace: place)
                self.fillViewWith(weather: weatherResponse!)
            } else {
                HelperInstance.shared.createAlert(title: "OoOops..", message: "Looks like mistake while weather request", currentView: self)
            }
        }
    }
    
    fileprivate func fillViewWith(weather: WeatherResponse) {
        
        self.cityName?.text = weather.cityName
        self.weatherIcon.setWithImageWithKey(key: (weather.weatherDescription)!)
        self.temp?.text = weather.temp! + "\n" + weather.weatherDescription!
        self.cloudiness?.text = "Cloudiness: " + weather.cloudiness!
        self.wind?.text = "Wind: " + weather.windSpeed!
        self.visibility?.text = "Visibility: " + weather.visibility!
        self.barometer?.text = "Barometer: " + weather.pressure!
        self.humidity?.text = "Humidity: " + weather.humidity!
        self.sunrise?.text = "Sunrise: " + weather.sunrise!
        self.sunset?.text = "Sunset: " + weather.sunset!
    }
    
}
