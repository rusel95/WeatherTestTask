//
//  SettingsViewController.swift
//  WeatherTestTask
//
//  Created by Admin on 05.05.17.
//  Copyright © 2017 rusel95. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Settings"
        // Do any additional setup after loading the view.
    }
    
    var objects = [RealmPlace]()
    
    override func viewWillAppear(_ animated: Bool) {
        objects = RealmCRUD.shared.queryRealmPlaces()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count//realm number
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsTableViewCell
        
        cell.cityOutlet.setTitle(objects[indexPath.row].address, for: .normal)
        
        return cell
    }

}
