//
//  Place.swift
//  WeatherTestTask
//
//  Created by Admin on 08.05.17.
//  Copyright © 2017 rusel95. All rights reserved.
//

import Foundation
import RealmSwift

class Place : Object  {
    dynamic var name : String = ""
    dynamic var address: String = ""
    dynamic var latitude: Double = 0.0
    dynamic var longitude: Double = 0.0
    
    func setPlace(name: String, address: String, latitude: Double, longitude: Double) {
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
}
