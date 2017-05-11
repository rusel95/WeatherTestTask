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

    var delegate: SearchViewControllerDelegate?
    var weatherToGiveBack : WeatherResponse?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        print("Init_SearchViewController")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        print("Init_SearchViewController")
    }
 
    deinit {
        print("deinit_SearchViewController")
    }
    
    fileprivate var currentPlace = Place()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if weatherToGiveBack != nil {
            self.delegate?.doSomething(with: weatherToGiveBack!)
        }
    }
    
    private func presentAutocompleteView() {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
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
                self.navigationController?.popViewController(animated: true)
                
            } else {
                HelperInstance.shared.createAlert(title: "OoOops..", message: "Looks like mistake while weather request", currentView: self)
            }
        }
    }
}


extension SearchViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        currentPlace.setPlace(name: place.name, address: place.formattedAddress!, latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        print(place.placeID)
        placeOutlet.text = currentPlace.address
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: \(error)")
        dismiss(animated: true, completion: nil)
    }
    
    // User cancelled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        dismiss(animated: true, completion: nil)
    }
}
