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
    
    var temp: String?           //kelvin, 0 kelvin = -273,15 celsius
    var pressure: String?
    var humidity: String?
    var tempMin: String?
    var tempMax: String?
    
    var windSpeed: String?
    var windDeg: String?
    
    var clouds: String?
    
    var visibility: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
    }
    
}
