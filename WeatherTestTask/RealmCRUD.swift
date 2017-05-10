//
//  PlaceRealm.swift
//  WeatherTestTask
//
//  Created by Admin on 09.05.17.
//  Copyright © 2017 rusel95. All rights reserved.
//

import Foundation
import RealmSwift

//class RealmPlace : Object {
//    dynamic var name = ""
//    dynamic var address = ""
//    
//    dynamic var latitude = 0.0
//    dynamic var longitude = 0.0
//    
//}

class RealmCRUD {
    
    static let shared = RealmCRUD()
    private init () { }
    
    func write(somePlace: Place) {
        
        if !isExist(somePlace: somePlace) {
            
            let realm = try! Realm()
            
            try! realm.write {
                realm.add(somePlace)
            }
        }
    }
    
    func queryRealmPlacesToArray() -> [Place] {
        
        var objects = [Place]()
        
        let realm = try! Realm()
        let places = realm.objects(Place.self)
        for place in places {
            objects.append(place)
        }
        
        return objects
    }
    
    private func isExist(somePlace: Place) -> Bool {
        
        var exist = false
        
        let places = self.queryRealmPlacesToArray()
        for place in places {
            if place.address == somePlace.address {
                exist = true
                break
            }
        }
        
        return exist
    }
    
    func deleteRealmPlaces(placeToDelete: Place) -> Void {
        
        let realm = try! Realm()
        
        for place in queryRealmPlacesToArray() {
            if place.address == placeToDelete.address {
                try! realm.write {
                    realm.delete(place)
                }
                break
            }
        }
    }
    
}
