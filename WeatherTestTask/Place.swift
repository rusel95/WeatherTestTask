//
//  Place.swift
//  WeatherTestTask
//
//  Created by Admin on 08.05.17.
//  Copyright © 2017 rusel95. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces

class Place {
    var name : String?
    var address: String?
    var location: CLLocationCoordinate2D?
    
    init(name: String, address: String, location: CLLocationCoordinate2D) {
        self.name = name
        self.address = address
        self.location = location
    }
}
