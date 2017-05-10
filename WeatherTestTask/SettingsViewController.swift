//
//  SettingsViewController.swift
//  WeatherTestTask
//
//  Created by Admin on 05.05.17.
//  Copyright © 2017 rusel95. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func doSomething(with place: Place)
}

class SettingsViewController: UITableViewController {
    
    var delegate: SettingsViewControllerDelegate?
    var placeToGiveBack : Place?
    
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
        
        placeToGiveBack = tempPlace
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if placeToGiveBack != nil {
            self.delegate?.doSomething(with: placeToGiveBack!)
        }
    }
}
