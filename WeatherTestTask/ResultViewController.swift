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
import AlamofireImage

class ResultViewController: UIViewController, SettingsViewControllerDelegate, SearchViewControllerDelegate {
    
    fileprivate var defaultPlace = Place()
    
    //MARK:
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
    
    
    //MARK: views references
    @IBOutlet weak var backgroundImageView: UIImageView!
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
    
    
    //MARK: overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeNavBarCool()
        
        downloadDefaultOrLastCity()
    }
    
    
    //MARK: Delegeted function
    func doSomething(with weather: WeatherResponse) {
        
        fillViewWith(weather: weather)
        PixabayApi.shared.getImageUrl(with: weather.cityName!) { url in
            if url != nil {
                self.backgroundImageView.af_setImage(withURL: URL(string: url!)! )
            }
        }
    }
    
}

//MARK: extra functions
extension ResultViewController {
    
    fileprivate func makeNavBarCool() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "launch1.png"), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Optima", size: 20)!,
                                                                         NSForegroundColorAttributeName: UIColor(red: 87, green: 143, blue: 220, alpha: 1) ]
    }
    
    fileprivate func downloadDefaultOrLastCity() {
        
        defaultPlace.setPlace(name: "Dnipro", address: "Dnipropetrovska oblast", latitude: 48.4686, longitude: 35.0357)
        
        if RealmCRUD.shared.queryPlacesToArray().count == 0 {
            getWeather(in: defaultPlace)
            setBackroundImage(with: defaultPlace)
        } else {
            let lastPlace = RealmCRUD.shared.queryPlacesToArray().last
            
            getWeather(in: lastPlace!)
            
            setBackroundImage(with: lastPlace!)
        }
    }
    
    fileprivate func setBackroundImage(with place: Place) {
        PixabayApi.shared.getImageUrl(with: place.name) { url in
            if url != nil {
                self.backgroundImageView.af_setImage(withURL: URL(string: url!)! )
            }
        }
    }
    
    fileprivate func getWeather(in place: Place) {
        
        self.activityIndicator.startAnimating()
        WeatherApi.shared.getWeatherData(latitude: place.latitude, longitude: place.longitude) { weatherResponse in
            
            self.activityIndicator.stopAnimating()
            if weatherResponse != nil {
                RealmCRUD.shared.write(somePlace: place)
                weatherResponse?.cityName = place.name
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
