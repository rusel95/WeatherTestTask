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
        
        let realmPlace = RealmPlace()
        realmPlace.name = somePlace.name!
        realmPlace.address = somePlace.address!
        realmPlace.latitude = (somePlace.location?.latitude)!
        realmPlace.longitude = (somePlace.location?.longitude)!
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(realmPlace)
        }
    }
    
    func queryRealmPlaces() -> [RealmPlace] {
       
        let realm = try! Realm()
        var objects = [RealmPlace]()
        
        let places = realm.objects(RealmPlace.self)
        for place in places {
            objects.append(place)
        }
        
        return objects
    }
    
}
