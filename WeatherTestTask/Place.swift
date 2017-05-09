//
//  Place.swift
//  WeatherTestTask
//
//  Created by Admin on 08.05.17.
//  Copyright © 2017 rusel95. All rights reserved.
//

import Foundation

class Place {
    var name : String?
    var address: String?
    var latitude: Double?
    var longitude: Double?
    
    init(name: String, address: String, latitude: Double, longitude: Double) {
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
}
