//
//  SettingsViewController.swift
//  WeatherTestTask
//
//  Created by Admin on 05.05.17.
//  Copyright © 2017 rusel95. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func doSomething(with weather: WeatherResponse)
}

class SettingsViewController: UITableViewController {
    
    
    //MARK: delegetions
    var delegate: SettingsViewControllerDelegate?
    var weatherToGiveBack : WeatherResponse?
    
    
    //MARK: stored properties
    var objects = [Place]()
    let lettersArray = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    var dict = [ "" : [Place]() ]
    
    
    //MARK: outlets/actions
    @IBOutlet weak var searchBookmarks: UISearchBar!
        
    //MARK: init/deinit
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
    
    //MARK: tableView overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Settings"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Delete All", style: .plain, target: self, action: #selector(deleteAllPlaces))
        
        objects = RealmCRUD.shared.queryPlacesToArray()
        dict = getSectionsAndRows(at: objects)
    }
       
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if weatherToGiveBack != nil {
            self.delegate?.doSomething(with: weatherToGiveBack!)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let neededKey = Array(dict.keys)[section]
        return (dict[neededKey]?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsTableViewCell
        
        let neededKey = Array(dict.keys)[indexPath.section]
        
        cell.cityNameOutlet.text = dict[neededKey]?[indexPath.row].name
        
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let neededKey = Array(dict.keys)[indexPath.section]
            let neededPlace = dict[neededKey]?[indexPath.row]
            
            if Array(dict.keys).count == 1 {
                dict.removeValue(forKey: neededKey)
                let set : IndexSet = [indexPath.section]
                tableView.deleteSections(set, with: .automatic)
            } else if Array(dict.keys).count > 1 {
                dict[neededKey]?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
            }

            RealmCRUD.shared.deletePlace(placeToDelete: neededPlace!)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let neededKey = Array(dict.keys)[indexPath.section]
        let neededPlace = dict[neededKey]?[indexPath.row]
        
        getWeather(in: neededPlace!, from: tableView.cellForRow(at: indexPath) as! SettingsTableViewCell)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dict.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(dict.keys)[section]
    }
    
}


//MARK: For sections
extension SettingsViewController {
    
    fileprivate func getSectionsAndRows(at allPlaces: [Place]) -> [ String : [Place] ] {
        
        var tempDict = [ String : [Place] ]()
        
        //every letter path through
        for letter in lettersArray {
            
            var tempItemsInSection = [Place]()
            //every place path through
            for place in allPlaces {
                
                //check if the first letter of place is an iteration letter
                let placeNameFirstCharacter = place.name.characters[place.name.startIndex]
                if placeNameFirstCharacter == Character(letter) {
                    
                    tempItemsInSection.append(place)
                }
            }
            
            if tempItemsInSection.count != 0 {
                tempDict[letter] = tempItemsInSection
            }
        }
        
        return tempDict
    }
    
    func deleteAllPlaces() {
        objects.removeAll()
        dict.removeAll()
        RealmCRUD.shared.deleteAllPlaces()
        tableView.reloadData()
    }
    
}


//MARK: getting of weather
extension SettingsViewController {
    
    fileprivate func getWeather(in place: Place, from cell: SettingsTableViewCell) {
        
        cell.activityIndicator.startAnimating()
        WeatherApi.shared.getWeatherData(latitude: place.latitude, longitude: place.longitude) { weatherResponse in
            
            cell.activityIndicator.stopAnimating()
            if weatherResponse != nil {
                weatherResponse?.cityName = place.name
                self.weatherToGiveBack = weatherResponse
                self.navigationController?.popViewController(animated: true)
            } else {
                HelperInstance.shared.createAlert(title: "OoOops..", message: "Looks like mistake while weather request", currentView: self)
            }
        }
    }
}
