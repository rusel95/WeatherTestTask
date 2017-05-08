//
//  WeatherAPI.swift
//  WeatherTestTask
//
//  Created by Admin on 05.05.17.
//  Copyright © 2017 rusel95. All rights reserved.

//OpenWeathermap.com/api

import Foundation

class WeatherApi {
    
    static let shared = WeatherApi()
    private init() { }
    
    private let apiKey = "4a069077d6974db10f255af576ef8baa"
    private let apiRequest = "http://api.accuweather.com/alarms/v1/1day/335315?apikey="
    
    
    
}
