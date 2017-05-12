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
    
    var delegate: SettingsViewControllerDelegate?
    
    fileprivate var weatherToGiveBack : WeatherResponse?
    fileprivate var objects = [Place]()
    fileprivate let lettersArray = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    fileprivate var sectionsArray = [Character]()
    fileprivate var itemsInSections = [[String]]()
    
    var dict : [ Character : [String] ] = [:]
    
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        objects = RealmCRUD.shared.queryRealmPlacesToArray()
        sectionsArray = getHeaders(at: objects)
        itemsInSections = getItemInSections(sectionsArray, with: objects)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if weatherToGiveBack != nil {
            //weatherToGiveBack?.search = self.search
            self.delegate?.doSomething(with: weatherToGiveBack!)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsInSections[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsTableViewCell
        
        cell.cityNameOutlet.text = itemsInSections[indexPath.section][indexPath.row]
        
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
    
}


//MARK: For sections
extension SettingsViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsArray.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(sectionsArray[section])
    }
    
    fileprivate func getHeaders(at allPlaces: [Place]) -> [Character] {
        
        var currentSections = [Character]()
        
        //every letter path through
        for letter in lettersArray {
            
            //every place path through
            for place in allPlaces {
                
                //check if the first letter of place is an iteration letter
                let placeNameFirstCharacter = place.name.characters[place.name.startIndex]
                if placeNameFirstCharacter == Character(letter) {
                    
                    //add letter if it does not exist already in curerntheaders
                    if !currentSections.contains( Character(letter) ) {
                        currentSections.append( Character(letter) )
                    }
                }
            }
        }
        return currentSections
    }
    
    fileprivate func getItemInSections(_ sections: [Character], with places: [Place]) -> [ [String] ] {
        
        var tempItemsInSections = [ [String] ]()
        
        //every letter in section path through
        for letter in sections {
            
            
            //every place path through
            for place in places {
                
                let placeNameFirstCharacter = place.name.characters[place.name.startIndex]
                if placeNameFirstCharacter == letter {

                    tempItemsInSections.append([place.name])
                }
            }
        }
        
        return tempItemsInSections
    }
    
}



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
