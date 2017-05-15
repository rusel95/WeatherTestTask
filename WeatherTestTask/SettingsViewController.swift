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
    //    var dict = [ "" : [Place]() ]
    
    var sectionsNames = [String]()
    var placesInSections = [[Place]]()
    var searchedPlacesInSections = [[Place]]()
    
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
        getSectionsAndPlaces(from: objects)
        searchedPlacesInSections = placesInSections
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
    

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsNames.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
        
        return sectionsNames[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedPlacesInSections[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsTableViewCell
        
        cell.cityNameOutlet.text = searchedPlacesInSections[indexPath.section][indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let neededPlace = searchedPlacesInSections[indexPath.section][indexPath.row]
            
            //            if Array(filteredDict.keys).count == 1 {
            //                filteredDict.removeValue(forKey: neededKey)
            //                let set : IndexSet = [indexPath.section]
            //                tableView.deleteSections(set, with: .automatic)
            //            } else if Array(filteredDict.keys).count > 1 {
            //                filteredDict[neededKey]?.remove(at: indexPath.row)
            //                tableView.deleteRows(at: [indexPath], with: .left)
            //                /////////////////////////////////////////
            ////                let set : IndexSet = [indexPath.section]
            ////                tableView.deleteSections(set, with: .right)
            //            }
            
            RealmCRUD.shared.deletePlace(placeToDelete: neededPlace)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let neededPlace = placesInSections[indexPath.section][indexPath.row]
        
        getWeather(in: neededPlace, from: tableView.cellForRow(at: indexPath) as! SettingsTableViewCell)
    }
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionsNames
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
}

//MARK: Search Bar delegetion
extension SettingsViewController {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchFilter(text: searchText)
        tableView.reloadData()
    }
    
    private func searchFilter(text: String) {
        var searchResults = [Place]()
        
        if text != "" {
            
            searchedPlacesInSections.removeAll()
            //path through all sections
            for i in 0..<sectionsNames.count {
                
                //path through all places in section
                for place in placesInSections[i] {
                    if place.name.contains(text.lowercased()) {
                        searchResults.append(place)
                    }
                }
            }
            
            sectionsNames.removeAll()
            if searchResults.count != 0 {
                searchedPlacesInSections.append(searchResults)
                sectionsNames = ["results: "]
            } else {
                if placesInSections.count == 0 {
                    let tempPlace = Place()
                    tempPlace.setPlace(name: "no results... please, try again", address: "", latitude: 0, longitude: 0)
                    var tempPlaceArray = [Place]()
                    tempPlaceArray.append(tempPlace)
                    placesInSections.append(tempPlaceArray)
                    sectionsNames = ["OoOops..."]
                }
            }
            
        } else {
            getSectionsAndPlaces(from: objects)
        }
        
    }
    
}


//MARK: For sections
extension SettingsViewController {
    
    fileprivate func getSectionsAndPlaces(from allPlaces: [Place]) {
        
        for i in 0..<allPlaces.count {
            let nameFirstLetter = String(describing: allPlaces[i].name.characters.first! )
            if !sectionsNames.contains(nameFirstLetter) {
                sectionsNames.append(nameFirstLetter)
            }
        }
        sectionsNames.sort()
        
        //every letter path through
        for i in 0..<sectionsNames.count {
            
            var tempPlacesInSection = [Place]()
            //every place path through
            for place in allPlaces {
                
                //check if the first letter of place is an iteration letter
                let placeNameFirstCharacter = String( describing: place.name.characters.first! )
                if placeNameFirstCharacter == sectionsNames[i] {
                    tempPlacesInSection.append(place)
                }
            }
            if tempPlacesInSection.count != 0 {
                placesInSections.append(tempPlacesInSection)
            }
        }
        
        searchedPlacesInSections = placesInSections
    }
    
    func deleteAllPlaces() {
        objects.removeAll()
        sectionsNames.removeAll()
        placesInSections.removeAll()
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
