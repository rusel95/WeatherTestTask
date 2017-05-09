//
//  WeatherAPI.swift
//  WeatherTestTask
//
//  Created by Admin on 05.05.17.
//  Copyright © 2017 rusel95. All rights reserved.

//OpenWeathermap.com/api

import Foundation
import Alamofire
import AlamofireObjectMapper
import GoogleMaps

class WeatherApi {
    
    static let shared = WeatherApi()
    private init() { }
    
    
    private let apiSkeletonUrl = "http://api.openweathermap.org/data/2.5/weather"
    private let apiKeyUrl = "&appid=4a069077d6974db10f255af576ef8baa"
    private let apiAccuracyUrl = "&type=accurate"
    private let apiMetricUrl = "&units=metric"
    
    func getWeatherData(latitude: Double, longitude: Double, giveData: @escaping (WeatherResponse?) -> Void) -> Void {
        
        let locationUrl = "?lat=" + String(latitude) + "&lon=" + String(longitude)
        let urlForRequest = apiSkeletonUrl + locationUrl + apiAccuracyUrl + apiMetricUrl + apiKeyUrl
        
//        Alamofire.request(urlForRequest).responseJSON { (response) in
//           print(response.result.value)
//        }
        
        Alamofire.request(urlForRequest).responseObject { (response: DataResponse<WeatherResponse>) in
            
            switch response.result {
            
            case .success:
                let weatherResponse = response.result.value!
                giveData(weatherResponse)
                
            case .failure(let error):
                print(error.localizedDescription, urlForRequest)
                giveData(nil)
            }
        }
        
    }
    
    
}
