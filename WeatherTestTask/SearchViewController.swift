//
//  SearchViewController.swift
//  WeatherTestTask
//
//  Created by Admin on 05.05.17.
//  Copyright © 2017 rusel95. All rights reserved.
//

import UIKit
import GooglePlaces

protocol SearchViewControllerDelegate {
    func doSomething(with weather: WeatherResponse)
}

class SearchViewController: UIViewController {

    //MARK: sored properties
    var delegate: SearchViewControllerDelegate?
    fileprivate var weatherToGiveBack : WeatherResponse?
    fileprivate var currentPlace = Place()

    //MARK: view referances
    @IBOutlet weak var placeOutlet: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBAction func placeAction(_ sender: UITextField) {
        presentAutocompleteView()
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        if placeOutlet.text != "" {
            getWeather(in: currentPlace)
        } else {
            HelperInstance.shared.createAlert(title: "OoOops", message: "Looks like you have`t entered any city or address.. Please, do that!", currentView: self)
        }
    }
    
    //MARK: init/deinit
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if weatherToGiveBack != nil {
            self.delegate?.doSomething(with: weatherToGiveBack!)
        }
    }
    
    

}

extension SearchViewController {
    
    fileprivate func getWeather(in place: Place) {
        
        self.activityIndicator.startAnimating()
        WeatherApi.shared.getWeatherData(latitude: place.latitude, longitude: place.longitude) { weatherResponse in
            
            self.activityIndicator.stopAnimating()
            if weatherResponse != nil {
                RealmCRUD.shared.write(somePlace: self.currentPlace)
                self.weatherToGiveBack = weatherResponse
                self.weatherToGiveBack?.cityName = self.currentPlace.name
                self.navigationController?.popViewController(animated: true)
                
            } else {
                HelperInstance.shared.createAlert(title: "OoOops..", message: "Looks like mistake while weather request", currentView: self)
            }
        }
    }
}

//MARK: GoogleAutocomplete
extension SearchViewController: GMSAutocompleteViewControllerDelegate {
    
    fileprivate func presentAutocompleteView() {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    // Handle the user's selection.
    internal func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        currentPlace.setPlace(name: place.name, address: place.formattedAddress!, latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        placeOutlet.text = currentPlace.address
        
        dismiss(animated: true, completion: nil)
    }
    
    internal func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: \(error)")
        dismiss(animated: true, completion: nil)
    }
    
    // User cancelled the operation.
    internal func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        dismiss(animated: true, completion: nil)
    }
}
