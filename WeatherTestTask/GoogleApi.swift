//
//  GoogleApi.swift
//  WeatherTestTask
//
//  Created by Admin on 11.05.17.
//  Copyright © 2017 rusel95. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class GooglePlaceApi {
    
    static let shared = GooglePlaceApi()
    private init() { }
    
    private let apiKeyUrl = "&key=AIzaSyCqFUu4kg2KKQdEUzYlGK_T4vDNjNAQWlc"
    
    func getPlaceImage(in latitude: Double, and longitude: Double) {
        
        getPhotoReference(in: latitude, and: longitude) { (photoReference) in
            self.getImageUrl(with: photoReference!) { (imageUrl) in
                if imageUrl != nil {
                    print(imageUrl!)
                }
            }
        }
        
    }
    
    private func getPhotoReference(in latitude: Double, and longitude: Double, givePhotoReference: @escaping (String?) -> Void) -> Void {
        
        let apiSkeletonUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        let locationUrl = "?location=" + String(latitude) + "," + String(longitude)
        let radiusUrl = "&radius=2000"
        
        let urlForRequest = apiSkeletonUrl + locationUrl + radiusUrl + apiKeyUrl
        
        Alamofire.request(urlForRequest).responseJSON { (response) in
            
            switch response.result {
            case .success:
                let responseJSON = JSON(response.result.value!)
                //print(responseJSON["results"][2])
                let photoReference = responseJSON["results"][0]["photos"][0]["photo_reference"].string
                givePhotoReference(photoReference)
                
            case .failure(let error):
                print(error.localizedDescription, urlForRequest)
                givePhotoReference(nil)
            }
        }
    }
    
    private func getImageUrl(with photoReference: String, giveData: @escaping (String?) -> Void) -> Void {
        
        let apiSkeletonUrl = "https://maps.googleapis.com/maps/api/place/photo?"
        let apiMaxWidthUrl = "maxheight=600"
        let apiPhotoReferenceUrl = "&photoreference=" + photoReference
        
        let urlForRequest = apiSkeletonUrl + apiMaxWidthUrl + apiPhotoReferenceUrl + apiKeyUrl
        
        Alamofire.request(urlForRequest).validate().responseJSON { (response) in
            
            let need = String(describing: response.response!)

            debugPrint(need)
            
//            switch response.result {
//            case .success:
//                let result = JSON(response)
//                debugPrint(String(describing: response.response!))
//                
//            case .failure(let error):
//                print(error.localizedDescription, urlForRequest)
//               // print(response)
//                giveData(nil)
//            }
        }
    }
    
    
    
}
