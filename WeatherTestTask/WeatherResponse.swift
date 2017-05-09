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
        
        var main: [String : AnyObject] = [:]
        main    <- map["main"]
        self.temp = String(describing: main["temp"] as? Double) + "℃"
        self.pressure = String(describing: main["pressure"] as? Int) + " ㍱"
        self.humidity = String(describing: main["humidity"] as? Int) + " %"
        self.tempMin = String(describing: main["pressure"] as? Double) + " ℃"
        self.tempMax = String(describing: main["pressure"] as? Double) + " ℃"
        
        var wind: [String : AnyObject] = [:]
        wind    <- map["wind"]
        self.windSpeed = String(describing: Double( Int((wind["speed"] as? Double)! ) * 10) / 10.0 ) + " m/s"
        
        var clouds: [String : AnyObject] = [:]
        clouds  <- map["clouds"]
        self.cloudiness = String( describing: clouds["all"] as? Int ) + " %"
        
        self.visibility     <- map["visibility"]
        
        var sys: [String : AnyObject] = [:]
        sys     <- map["sys"]
        self.sunrise = String( describing: Date().unixtoString(secondsSince1970: (sys["sunrise"] as? Int)! ) )
        self.sunset = String( describing: Date().unixtoString(secondsSince1970: (sys["sunset"] as? Int)! ) )
    }
}
