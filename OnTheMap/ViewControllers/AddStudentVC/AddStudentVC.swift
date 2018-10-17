//
//  AddStudentVC.swift
//  OnTheMap
//
//  Created by Chuck Underwood on 10/9/18.
//  Copyright © 2018 Chuck Underwood. All rights reserved.
//

import UIKit
import MapKit

class AddStudentVC: UIViewController {

    @IBOutlet weak var locationInput: UITextField!
    @IBOutlet weak var urlInput: UITextField!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationInput.delegate = self
        
        navigationController?.title = "New Student"
        hideKeyboardWhenTappedAround()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        activityIndicator.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func addStudent(_ sender: Any) {
        if (locationInput.text?.isEmpty)! {
            showAlert(title: "No Location", message: "Please enter a location to add pin.", dismissHandler: nil)
            return
        }
        
        let link = urlInput.text ?? ""
        guard let url = URL(string: link),
            UIApplication.shared.canOpenURL(url) else {
            showAlert(title: "URL Error", message: "Please enter a valid website in the format: http(s)://website.com", dismissHandler: nil)
            return
        }
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        saveLocation()
    }
    
    func saveLocation() {
        let location = locationInput.text
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = location
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if response == nil {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                
                self.showAlert(title: "Invalid Location", message: "Unable to find location from string.  Please correct or refine location.", dismissHandler: nil)
            }
            
            if let results = response?.mapItems {
                let title = results[0].placemark.title
                
                let coords = results[0].placemark.coordinate
                
                let lat = coords.latitude
                let long = coords.longitude
                
                let url = self.urlInput.text
                
                Parse.shared.postStudentLocation(locationString: title!, mediaUrl: url!, lat: lat, lng: long, onComplete: { (error) in
                    DispatchQueue.main.async {
                        if error != nil {
                            self.showAlert(title: "Ruh Roh", message: error!.rawValue, dismissHandler: { (_) in
                                self.navigationController?.popViewController(animated: true)
                                
                            })
                        } else {
                            self.showAlert(title: "Success", message: "Congratulations.  Location added.", dismissHandler: { (_) in
                                self.navigationController?.popViewController(animated: true)
                            })
                        }
                    }
                })
                
            }
            
        }
    }
    
    func updateMapView() {
        
        let previousAnnotations = self.map.annotations
        if !previousAnnotations.isEmpty{
            self.map.removeAnnotation(previousAnnotations[0])
        }
        
        let location = locationInput.text
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = location
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if response == nil {
                return
            }
            
            if let results = response?.mapItems {
                
                let coords = results[0].placemark.coordinate
                let lat = coords.latitude
                let long = coords.longitude
                
                let annotation = MKPointAnnotation()
                annotation.coordinate.latitude = lat
                annotation.coordinate.longitude = long
                self.map.addAnnotation(annotation)
                
                let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
                
                self.map.setRegion(region, animated: true)
            }
            
        }
    }
    
}

extension AddStudentVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateMapView()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == locationInput) {
            urlInput.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            
        }
        return true
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillChange(_ notification:Notification) {
        
        let safeBottom = self.urlInput.frame.maxY + 16
        
        let keyboardTop = self.view.frame.height - getKeyboardHeight(notification)
        
        let offset = safeBottom - keyboardTop
        
        if (offset <= 0) {
            return
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame.origin.y = 0
            self.view.frame.origin.y -= offset
        })
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame.origin.y = 0
        })
    }
    
    private func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
}

