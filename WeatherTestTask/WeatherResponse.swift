//
//  Weather.swift
//  WeatherTestTask
//
//  Created by Admin on 08.05.17.
//  Copyright © 2017 rusel95. All rights reserved.
//

import Foundation
import ObjectMapper

class WeatherResponse: Mappable {
    
    var cityName: String?
    
    var search: String?
    
    var weatherMain: String?
    var weatherDescription: String?
    
    
    var temp: String?
    var pressure: String?
    var humidity: String?
    var tempMin: String?
    var tempMax: String?
    
    var windSpeed: String?
    
    var cloudiness: String?
    
    var visibility: String?
    
    var sunrise: String?
    var sunset: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        cityName    <- map["name"]
        
        setWeather(with: map["weather"])
        setMain(with: map["main"])
        setWind(with: map["wind"])
        setClouds(with: map["clouds"])
        setVisibility(with: map["visibility"])
        setSys(with: map["sys"])
    }
    
    private func setWeather(with map: Map) {
        var weather = [Any]()
        weather <- map
        self.weatherDescription = ( (weather[weather.startIndex] as! Dictionary<String, Any>)["description"] as! String )
    }
    
    private func setMain(with map: Map) {
        var main: [String : AnyObject] = [:]
        main    <- map
        self.temp = String(describing: (main["temp"] as? Double)!) + " ℃"
        self.pressure = String(describing: (main["pressure"] as? Int)!) + " ㍱"
        self.humidity = String(describing: (main["humidity"] as? Int)!) + " %"
        self.tempMin = String(describing: main["temp_min"] as? Double) + " ℃"
        self.tempMax = String(describing: main["temp_max"] as? Double) + " ℃"
    }
    
    private func setWind(with map: Map) {
        var wind: [String : AnyObject] = [:]
        wind    <- map
        self.windSpeed = String(describing: ( (wind["speed"])! as? Double)! ) + " m/s"
    }
    
    private func setClouds(with map: Map) {
        var clouds: [String : AnyObject] = [:]
        clouds  <- map
        self.cloudiness = String( describing: (clouds["all"] as? Int)! ) + " %"
    }
    
    private func setVisibility(with map: Map) {
        var visibilityResponse = Int()
        visibilityResponse  <- map
        self.visibility = String(describing: visibilityResponse) + " m"
    }
    
    private func setSys(with map: Map) {
        var sys: [String : AnyObject] = [:]
        sys     <- map
        self.sunrise = String( describing: Date().unixtoString(secondsSince1970: (sys["sunrise"] as? Int)! ) )
        self.sunset = String( describing: Date().unixtoString(secondsSince1970: (sys["sunset"] as? Int)! ) )
    }
}
