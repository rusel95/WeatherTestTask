//
//  SettingsViewController.swift
//  WeatherTestTask
//
//  Created by Admin on 05.05.17.
//  Copyright © 2017 rusel95. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        print("Init_SettingsViewController")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        print("Init_SettingsViewController")
    }
    
    
    deinit {
        print("deinit_SettingsViewController")
    }
    
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
        
        cell.cityNameOutlet.text = objects[indexPath.row].address
        
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
        
        //self.performSegue(withIdentifier: "SettingsToResult", sender: tempPlace)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "SettingsToResult" {
//            if let SearchResultVC = segue.destination as? ResultViewController {
//                SearchResultVC.placeForWeather = sender as! Place
//            }
//        }
//    }
    
}
