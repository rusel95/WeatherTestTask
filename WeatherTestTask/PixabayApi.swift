//
//  PixabayApi.swift
//  WeatherTestTask
//
//  Created by Admin on 11.05.17.
//  Copyright © 2017 rusel95. All rights reserved.
//

import Foundation
import Alamofire

class PixabayApi {
    
    static let shared = PixabayApi()
    private init() { }
    
    private let apiSkeletonUrl = "https://pixabay.com/api/"
    private let apiKeyUrl = "?key=5338293-61c484c98ff85459e5f832d8c"
    //private let apiCxUrl = "&cx=007074722634991237053:lh8r7drklew"
    //private let apiMetricUrl = "&units=metric"
    
    func getImage(name: String, giveData: @escaping (WeatherResponse?) -> Void) -> Void {
        
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
