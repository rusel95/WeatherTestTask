//
//  PlaceRealm.swift
//  WeatherTestTask
//
//  Created by Admin on 09.05.17.
//  Copyright © 2017 rusel95. All rights reserved.
//

import Foundation
import RealmSwift

class RealmCRUD {
    
    static let shared = RealmCRUD()
    private init () { }
    
    func write(someObject: Any) {
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(someObject as! Object)
        }
    }
    
//    func get() {
//        let realm = try! Realm()
////        let place =
//    }
    
}
