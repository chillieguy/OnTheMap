//
//  MapVC.swift
//  OnTheMap
//
//  Created by Chuck Underwood on 10/7/18.
//  Copyright © 2018 Chuck Underwood. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {

    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        map.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Parse.shared.getStudents(limit: 100, skip: 0, onComplete: {error in
            DispatchQueue.main.async(execute: {
                self.studentLocationLoaded(error: error)
            })
        })
        
    }
    
    func studentLocationLoaded(error: Errors?) {
        if error != nil {
            showAlert(title: "Error", message: (error)!.rawValue, dismissHandler: nil)
            return
        }
        
        var annotations = [MKPointAnnotation]()
        
        for studentLocation in Cache.shared.studentLocations {
            annotations.append(studentLocation.annotation())
        }
        self.map.addAnnotations(annotations)
    }
    

}

extension MapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.green
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }  else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            openLinkInSafari(url: view.annotation?.subtitle!)
        }
    }
    
}
