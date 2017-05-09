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
        
        var weather = [Any]()
        weather     <- map["weather"]
        self.weatherDescription = ( (weather[weather.startIndex] as! Dictionary<String, Any>)["description"] as! String )
        
        var main: [String : AnyObject] = [:]
        main    <- map["main"]
        self.temp = String(describing: (main["temp"] as? Double)!) + " ℃"
        self.pressure = String(describing: (main["pressure"] as? Int)!) + " ㍱"
        self.humidity = String(describing: (main["humidity"] as? Int)!) + " %"
        self.tempMin = String(describing: main["temp_min"] as? Double) + " ℃"
        self.tempMax = String(describing: main["temp_max"] as? Double) + " ℃"
        
        var wind: [String : AnyObject] = [:]
        wind    <- map["wind"]
        self.windSpeed = String(describing: ( (wind["speed"])! as? Double)! ) + " m/s"
        
        var clouds: [String : AnyObject] = [:]
        clouds  <- map["clouds"]
        self.cloudiness = String( describing: (clouds["all"] as? Int)! ) + " %"
        
        var visibilityResponse = Int()
        visibilityResponse      <- map["visibility"]
        self.visibility = String(describing: visibilityResponse) + " m"
        
        var sys: [String : AnyObject] = [:]
        sys     <- map["sys"]
        self.sunrise = String( describing: Date().unixtoString(secondsSince1970: (sys["sunrise"] as? Int)! ) )
        self.sunset = String( describing: Date().unixtoString(secondsSince1970: (sys["sunset"] as? Int)! ) )
    }
}
