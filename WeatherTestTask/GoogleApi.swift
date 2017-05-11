//
//  GoogleApi.swift
//  WeatherTestTask
//
//  Created by Admin on 11.05.17.
//  Copyright © 2017 rusel95. All rights reserved.
//

import Foundation
import Alamofire

class GooglePlaceApi {
    
    static let shared = GooglePlaceApi()
    private init() { }
    
    private let apiKeyUrl = "&key=AIzaSyCqFUu4kg2KKQdEUzYlGK_T4vDNjNAQWlc"
    
    func getPlace(in latitude: String, and longitude: String, givePlace: @escaping (String?) -> Void) -> Void {
        
        let apiSkeletonUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        let locationUrl = "?location=" + latitude + "," + longitude
        let radiusUrl = "&radius=2000"
        
        let urlForRequest = apiSkeletonUrl + locationUrl + radiusUrl + apiKeyUrl
        
        Alamofire.request(urlForRequest).responseJSON { (response) in
            switch response.result {
                
            case .success:
                let placeResponse = response.result.value!
                print(placeResponse)
                
            case .failure(let error):
                print(error.localizedDescription, urlForRequest)
                givePlace(nil)
            }
        }
        
    }
    
    
    
    func getImage(name: String, giveData: @escaping (WeatherResponse?) -> Void) -> Void {
        
        let apiSkeletonUrl = "https://maps.googleapis.com/maps/api/place/photo?"
        
        let urlForRequest = apiSkeletonUrl + apiKeyUrl + "&q=" + name
        
        Alamofire.request(urlForRequest).responseJSON { (response) in
            switch response.result {
                
            case .success:
                let weatherResponse = response.result.value!
                print(weatherResponse)
                
            case .failure(let error):
                print(error.localizedDescription, urlForRequest)
                giveData(nil)
            }
        }
        
    }
    
    
}
