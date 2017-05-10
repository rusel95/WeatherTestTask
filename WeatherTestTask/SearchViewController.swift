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
    func doSomething(with place: Place)
}

class SearchViewController: UIViewController {

    var delegate: SearchViewControllerDelegate?
    var placeToGiveBack : Place?
    
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
            placeToGiveBack = currentPlace
            self.navigationController?.popViewController(animated: true)
        } else {
            HelperInstance.shared.createAlert(title: "OoOops", message: "Looks like you have`t entered any city or address.. Please, do that!", currentView: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if placeToGiveBack != nil {
            self.delegate?.doSomething(with: placeToGiveBack!)
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
        
        currentPlace = Place()
        currentPlace.setPlace(name: place.name, address: place.formattedAddress!, latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        
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
