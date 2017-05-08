//
//  Extensions.swift
//  WeatherTestTask
//
//  Created by Admin on 08.05.17.
//  Copyright © 2017 rusel95. All rights reserved.
//

import Foundation

extension Date {
    
    func unixtoString(secondsSince1970: Int) -> String {
        
        let date = Date(timeIntervalSince1970: TimeInterval(secondsSince1970))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.timeZone = TimeZone.ReferenceType.local
        dateFormatter.string(from: date)
        
        return dateFormatter.string(from: date)
    }
}
