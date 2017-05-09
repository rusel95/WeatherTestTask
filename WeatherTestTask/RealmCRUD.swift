//
//  PlaceRealm.swift
//  WeatherTestTask
//
//  Created by Admin on 09.05.17.
//  Copyright © 2017 rusel95. All rights reserved.
//

import Foundation
import RealmSwift

class RealmPlace : Object {
    dynamic var name = ""
    dynamic var address = ""
    
    dynamic var latitude = 0.0
    dynamic var longitude = 0.0
    
}

class RealmCRUD {
    
    static let shared = RealmCRUD()
    private init () { }
    
    func write(somePlace: Place) {
        
        if !isExist(somePlace: somePlace) {
            let realmPlace = RealmPlace()
            realmPlace.name = somePlace.name!
            realmPlace.address = somePlace.address!
            realmPlace.latitude = (somePlace.latitude)!
            realmPlace.longitude = (somePlace.longitude)!
            
            let realm = try! Realm()
            
            try! realm.write {
                realm.add(realmPlace)
            }
        }
    }
    
    func queryRealmPlacesToArray() -> [RealmPlace] {
        
        let realm = try! Realm()
        var objects = [RealmPlace]()
        
        let places = realm.objects(RealmPlace.self)
        for place in places {
            objects.append(place)
        }
        
        return objects
    }
    
    private func isExist(somePlace: Place) -> Bool {
        
        var exist = false
        
        let realmPlace = RealmPlace()
        realmPlace.name = somePlace.name!
        realmPlace.address = somePlace.address!
        realmPlace.latitude = (somePlace.latitude)!
        realmPlace.longitude = (somePlace.longitude)!
        
        let places = self.queryRealmPlacesToArray()
        for place in places {
            if place.address == realmPlace.address {
                exist = true
                break
            }
        }
        
        return exist
    }
    
    func deleteRealmPlaces(placeToDelete: RealmPlace) -> Void {
        
        let realm = try! Realm()
        
        //realm.delete(placeToDelete)
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
