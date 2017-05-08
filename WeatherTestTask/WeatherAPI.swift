//
//  WeatherAPI.swift
//  WeatherTestTask
//
//  Created by Admin on 05.05.17.
//  Copyright © 2017 rusel95. All rights reserved.

//OpenWeathermap.com/api

import Foundation
import Alamofire
import ObjectMapper
import GoogleMaps

class WeatherApi {
    
    static let shared = WeatherApi()
    private init() { }
    
    private let apiKey = "&appid=4a069077d6974db10f255af576ef8baa"
    private let apiCall = "http://api.openweathermap.org/data/2.5/weather"
    
    func getWeatherData(location: CLLocationCoordinate2D) {
        
        let urlForRequest = apiCall + "?lat=" + String(location.latitude) + "&lon=" + String(location.longitude) + apiKey
        
        Alamofire.request(urlForRequest).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                print(response.result.value!)
                
            case .failure(let error):
                print(error.localizedDescription, urlForRequest)
            }
        }
        
    }
    
    
}
