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
       
    func getImageUrl(with name: String, giveURL: @escaping (String?) -> Void) -> Void {
        
        let parts = name.components(separatedBy: " ")
        
        var qUrl = "&q="
        for part in parts {
            qUrl += part
            if part != parts.last {
                qUrl += "+"
            }
        }
        
        let urlForRequest = apiSkeletonUrl + apiKeyUrl + qUrl
        
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
