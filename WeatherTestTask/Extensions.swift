//
//  Extensions.swift
//  WeatherTestTask
//
//  Created by Admin on 08.05.17.
//  Copyright © 2017 rusel95. All rights reserved.
//

import UIKit

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

extension UIImageView {
    
    func setWithImageWithKey(key: String) {
        switch key {
        case "broken clouds":
            self.image = UIImage(named: "06-s.png")
        case "clear sky":
            self.image = UIImage(named: "01-s.png")
        case "overcast clouds":
            self.image = UIImage(named: "13-s.png")
        case "few clouds":
            self.image = UIImage(named: "04-s.png")
        case "light rain":
            self.image = UIImage(named: "12-s.png")
        case "light intensity shower rain":
            self.image = UIImage(named: "14-s.png")
        case "heavy rain":
            self.image = UIImage(named: "18-s.png")
        default :
            self.image = UIImage(named: "01-s.png")
            break
        }
    }
}
