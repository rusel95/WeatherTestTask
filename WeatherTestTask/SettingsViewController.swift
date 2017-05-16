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
    var allPlaces = [Place]()
    
    var sectionsNames = [String]()
    var placesInSections = [[Place]]()
    
    var searchedSectionsNames = [String]()
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
        
        allPlaces = RealmCRUD.shared.queryPlacesToArray()
        getSectionsAndPlaces()
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
        return searchedSectionsNames.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return searchedSectionsNames[section]
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
            
            for i in 0..<allPlaces.count {
                if allPlaces[i] == neededPlace {
                    allPlaces.remove(at: i)
                    break
                }
            }
            searchedPlacesInSections[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .right)
            
            if searchedPlacesInSections[indexPath.section].count == 0 {
                searchedPlacesInSections.remove(at: indexPath.section)
                searchedSectionsNames.remove(at: indexPath.section)
                tableView.deleteSections([indexPath.section], with: .left)
            }
            
            RealmCRUD.shared.deletePlace(placeToDelete: neededPlace)
            allPlaces = RealmCRUD.shared.queryPlacesToArray()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let neededPlace = searchedPlacesInSections[indexPath.section][indexPath.row]
        getWeather(in: neededPlace, from: tableView.cellForRow(at: indexPath) as! SettingsTableViewCell)
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return searchedSectionsNames.count > 1 ? searchedSectionsNames : nil
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
}

//MARK: For sections
extension SettingsViewController {
    
    fileprivate func getSectionsAndPlaces() {
        
        sectionsNames.removeAll()
        
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
        
        searchedSectionsNames = sectionsNames
        searchedPlacesInSections = placesInSections
    }
    
    func deleteAllPlaces() {
        allPlaces.removeAll()
        sectionsNames.removeAll()
        placesInSections.removeAll()
        RealmCRUD.shared.deleteAllPlaces()
        tableView.reloadData()
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
        
        searchedPlacesInSections.removeAll()
        searchedSectionsNames.removeAll()
        
        if text != "" {
            
            //path through all sections
            for i in 0..<sectionsNames.count {
                
                //path through all places in section
                for place in placesInSections[i] {
                    if place.name.lowercased().contains(text.lowercased()) {
                        searchResults.append(place)
                    }
                }
            }
            
            if searchResults.count != 0 {
                searchedPlacesInSections.append(searchResults)
                searchedSectionsNames = ["results: "]
            } else {
                let tempPlace = Place()
                tempPlace.setPlace(name: "no results... please, try again", address: "", latitude: 0, longitude: 0)
                var tempPlaceArray = [Place]()
                tempPlaceArray.append(tempPlace)
                searchedPlacesInSections.append(tempPlaceArray)
                searchedSectionsNames = ["OoOops..."]
                
            }
            
        } else {
            getSectionsAndPlaces()
        }
        
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
