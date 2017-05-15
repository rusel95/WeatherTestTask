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

class SettingsViewController: UITableViewController, UISearchBarDelegate {
    
    
    //MARK: delegetions
    var delegate: SettingsViewControllerDelegate?
    var weatherToGiveBack : WeatherResponse?
    
    
    //MARK: stored properties
    var objects = [Place]()
    var dict = [ "" : [Place]() ]
    var filteredDict = [ "" : [Place]() ]
    
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
        
        searchBookmarks.delegate = self
        
        setNavBar()
        
        objects = RealmCRUD.shared.queryPlacesToArray()
        dict = getSectionsAndRows(at: objects)
        filteredDict = dict
    }
    
    func setNavBar() {
        navigationItem.title = "Bookmarks"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "trash1.png" ), style: .plain, target: self, action: #selector(deleteAllPlaces))

    }
       
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if weatherToGiveBack != nil {
            self.delegate?.doSomething(with: weatherToGiveBack!)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let neededKey = Array(filteredDict.keys)[section]
        return (filteredDict[neededKey]?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsTableViewCell
        
        let neededKey = Array(filteredDict.keys)[indexPath.section]
        
        cell.cityNameOutlet.text = filteredDict[neededKey]?[indexPath.row].name
        
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let neededKey = Array(filteredDict.keys)[indexPath.section]
            let neededPlace = filteredDict[neededKey]?[indexPath.row]
            
            if Array(filteredDict.keys).count == 1 {
                filteredDict.removeValue(forKey: neededKey)
                let set : IndexSet = [indexPath.section]
                tableView.deleteSections(set, with: .automatic)
            } else if Array(filteredDict.keys).count > 1 {
                filteredDict[neededKey]?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
            }

            RealmCRUD.shared.deletePlace(placeToDelete: neededPlace!)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let neededKey = Array(filteredDict.keys)[indexPath.section]
        let neededPlace = filteredDict[neededKey]?[indexPath.row]
        
        getWeather(in: neededPlace!, from: tableView.cellForRow(at: indexPath) as! SettingsTableViewCell)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return filteredDict.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(filteredDict.keys)[section]
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        var lettersArray = [String]()
        for key in filteredDict.keys {
            lettersArray.append(key)
        }
        return lettersArray
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
}

//MARK: Search Bar delegetion
extension SettingsViewController {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        filteredDict = filterDictWith(text: searchText)
        tableView.reloadData()
    }
    
    private func filterDictWith(text: String) -> [ String : [Place] ] {
        
        var tempDict = [ String : [Place] ]()
       
        //if text in search bar exist
        if text != "" {
            
            //path through all dict keys to fill tempDict
            for key in dict.keys {
                
                //if letter of searched text is the same as key of dict
                if key == String(describing: text.characters.first!) || key.uppercased() == String( describing: text.characters.first!) {
                    
                    //fill tempDict with values of dict with key
                    tempDict[key] = dict[key]
                }
            }
            
            if tempDict.keys.count == 0 {
                
                let tempPlace = Place()
                tempPlace.setPlace(name: "no results... please, try again", address: "", latitude: 0, longitude: 0)
                var tempPlaceArray = [Place]()
                tempPlaceArray.append(tempPlace)
                tempDict[""] = tempPlaceArray
            }
            
        } else {
            tempDict = dict
        }
        
        return tempDict
    }
    
    private func fellKeysWith() {
    //path through all place in section
    //                    let placesInSection = dict[key]!
    //                    for i in 0..<placesInSection.count {
    //
    //                        var temp = true
    //                        for j in 0..<text.characters.count {
    //
    //                            let placeNameCharacter = placesInSection[i].name.characters[j]
    //                            if placeNameCharacter == text.characters[text.index(0, offsetBy: Int(i))] {
    //                                temp = false
    //                            }
    //                            if temp == true {
    //                                print(placesInSection[i])
    //                                tempDict[key]?.append(placesInSection[i])
    //                            }
    //                        }
    //                    }
    }
}


//MARK: For sections
extension SettingsViewController {
    
    fileprivate func getSectionsAndRows(at allPlaces: [Place]) -> [ String : [Place] ] {
        
        let lettersArray = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        
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
        filteredDict.removeAll()
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
