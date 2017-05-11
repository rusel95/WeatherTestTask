//
//  BingApi.swift
//  WeatherTestTask
//
//  Created by Admin on 11.05.17.
//  Copyright © 2017 rusel95. All rights reserved.
//

import Foundation
import Alamofire

class BingApi {
    
    static let shared = BingApi()
    private init() { }
    
    private let apiSkeletonUrl = "https://api.cognitive.microsoft.com/bing/v5.0/images/search?q=sailing+dinghies&mkt=en-us"
    private let apiKeyUrl = "&subscriprion_key=a09b3a245a4a475190d0e22b989fc308"
    //private let apiAccuracyUrl = "&type=accurate"
    //private let apiMetricUrl = "&units=metric"
    
    func getImage(name: String, giveData: @escaping (WeatherResponse?) -> Void) -> Void {
        
        let urlForRequest = apiSkeletonUrl + apiKeyUrl
        
                Alamofire.request(urlForRequest).responseJSON { (response) in
                   print(response.result.value)
                }
        
//        Alamofire.request(urlForRequest).responseObject { (response: DataResponse<WeatherResponse>) in
//            
//            switch response.result {
//                
//            case .success:
//                let weatherResponse = response.result.value!
//                giveData(weatherResponse)
//                
//            case .failure(let error):
//                print(error.localizedDescription, urlForRequest)
//                giveData(nil)
//            }
//        }
        
    }
    
    
}
