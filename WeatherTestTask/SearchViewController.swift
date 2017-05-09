//
//  SearchViewController.swift
//  WeatherTestTask
//
//  Created by Admin on 05.05.17.
//  Copyright © 2017 rusel95. All rights reserved.
//

import UIKit
import GooglePlaces

class SearchViewController: UIViewController {

    fileprivate var currentPlace : Place! {
        didSet {
            placeOutlet.text = currentPlace.address
        }
    }
    
    @IBOutlet weak var placeOutlet: UITextField!
    
    @IBAction func placeAction(_ sender: UITextField) {
        presentAutocompleteView()
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        if placeOutlet.text != "" {
            self.performSegue(withIdentifier: "ShowSearchResult", sender: currentPlace)
        } else {
            HelperInstance.shared.createAlert(title: "OoOops", message: "Looks like you have`t entered any city or address.. Please, do that!", currentView: self, controllerToDismiss: self.navigationController!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        RealmCRUD.shared.queryRealmPlaces()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSearchResult" {
            if let SearchResultVC = segue.destination as? ResultViewController {
                SearchResultVC.placeForWeather = sender as! Place
            }
        }
    }
    
    private func presentAutocompleteView() {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }

}


extension SearchViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        print("Place name: \(place.name)")
//        print("Place address: \(String(describing: place.formattedAddress))")
//        print("Place coordinate: \(String(describing: place.coordinate))")
        
        currentPlace = Place(name: place.name, address: place.formattedAddress!, location: place.coordinate)
        
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
