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
        updateUI()
    }
    
    fileprivate func updateUI() {
        objects = RealmCRUD.shared.queryRealmPlacesToArray()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RealmCRUD.shared.queryRealmPlacesToArray().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsTableViewCell
        
        cell.cityOutlet.setTitle(objects[indexPath.row].address, for: .normal)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            RealmCRUD.shared.deleteRealmPlaces(placeToDelete: objects[indexPath.row])
            updateUI()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let tempPlace = Place(name: objects[indexPath.row].name, address: objects[indexPath.row].address, latitude: objects[indexPath.row].latitude, longitude: objects[indexPath.row].longitude)
        
        self.performSegue(withIdentifier: "SettingsToResult", sender: tempPlace)
        navigationController?.popViewController(animated: false )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSearchResult" {
            if let SearchResultVC = segue.destination as? ResultViewController {
                SearchResultVC.placeForWeather = sender as! Place
            }
        }
    }
    
}
