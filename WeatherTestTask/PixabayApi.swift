//
//  PixabayApi.swift
//  WeatherTestTask
//
//  Created by Admin on 11.05.17.
//  Copyright © 2017 rusel95. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class PixabayApi {
    
    static let shared = PixabayApi()
    private init() { }
    
    private let apiSkeletonUrl = "https://pixabay.com/api/"
    private let apiKeyUrl = "?key=5338293-61c484c98ff85459e5f832d8c"
    
//    func getImage(with name: String, giveData: @escaping (WeatherResponse?) -> Void) -> Void {
//
//        let urlForRequest = apiSkeletonUrl + apiKeyUrl + "&q=" + name
//        
//        Alamofire.request(urlForRequest).responseJSON { (response) in
//            switch response.result {
//                
//            case .success:
//                let weatherResponse = response.result.value!
//                print(weatherResponse)
//                
//            case .failure(let error):
//                print(error.localizedDescription, urlForRequest)
//                giveData(nil)
//            }
//        }
//    }
    
    func getImageUrl(with name: String, giveURL: @escaping (String?) -> Void) -> Void {
        
        let urlForRequest = apiSkeletonUrl + apiKeyUrl + "&q=" + name
        
        Alamofire.request(urlForRequest).responseJSON { (response) in
            switch response.result {
                
            case .success:
                let json = JSON(response.result.value!)
                let url = json["hits"][0]["webformatURL"].string
                giveURL(url)
                
            case .failure(let error):
                print(error.localizedDescription, urlForRequest)
                giveURL(nil)
            }
        }
    }
    
}
