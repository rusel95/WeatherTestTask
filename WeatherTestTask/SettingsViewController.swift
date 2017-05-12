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

//struct tableData {
//    var sections = [Character]()
////    var itemsInsSections =
//}

class SettingsViewController: UITableViewController {
    
    var delegate: SettingsViewControllerDelegate?
    
    fileprivate var weatherToGiveBack : WeatherResponse?
    fileprivate var objects = [Place]()
    fileprivate let lettersArray = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    var dict = [ "" : [String]() ]
    
    
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
        
        objects = RealmCRUD.shared.queryRealmPlacesToArray()
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
        
        cell.cityNameOutlet.text = dict[neededKey]?[indexPath.row]
        
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            RealmCRUD.shared.deleteRealmPlaces(placeToDelete: objects[indexPath.row])
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getWeather(in: objects[indexPath.row], from: tableView.cellForRow(at: indexPath) as! SettingsTableViewCell)
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
    
    fileprivate func getSectionsAndRows(at allPlaces: [Place]) -> [ String : [String] ] {
        
        var tempDict = [ String : [String] ]()
        
        //every letter path through
        for letter in lettersArray {
            
            var tempItemsInSection = [String]()
            //every place path through
            for place in allPlaces {
                
                //check if the first letter of place is an iteration letter
                let placeNameFirstCharacter = place.name.characters[place.name.startIndex]
                if placeNameFirstCharacter == Character(letter) {
                    
                    tempItemsInSection.append(place.name)
                }
            }
            
            if tempItemsInSection.count != 0 {
                tempDict[letter] = tempItemsInSection
            }
        }
        
        return tempDict
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
