//
//  SettingsTableViewCell.swift
//  WeatherTestTask
//
//  Created by Admin on 09.05.17.
//  Copyright © 2017 rusel95. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityOutlet: UIButton!
    
    @IBAction func cityAction(_ sender: UIButton) {
        print("do something")
    }
    
}
