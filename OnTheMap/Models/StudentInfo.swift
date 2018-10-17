//
//  StudentInfo.swift
//  OnTheMap
//
//  Created by Chuck Underwood on 10/7/18.
//  Copyright © 2018 Chuck Underwood. All rights reserved.
//

import Foundation
import MapKit

class StudentInfo {
    
    var objectId : String
    var uniqueKey : String
    
    var firstName : String
    var lastName : String
    var latitude : Double
    var longitude : Double
    var mapString : String
    var mediaURL : String
    
    var createdAt : Date
    var updatedAt : Date
    
    let dateFormat = ISO8601DateFormatter()
    
    init?(_ dictionary: NSDictionary) {
        self.objectId = dictionary["objectId"] as! String
        self.uniqueKey = dictionary["uniqueKey"] as? String ?? ""
        self.createdAt =  dateFormat.date(from: dictionary["createdAt"] as! String) ?? Date()
        self.updatedAt = Date()
        
        if dictionary["firstName"] == nil || dictionary["lastName"] == nil {
            return nil
        }
        self.firstName = dictionary["firstName"] as! String
        self.lastName = (dictionary["lastName"] as! String)
        
        if dictionary["latitude"] == nil || dictionary["longitude"] == nil {
            return nil
        }
        self.latitude = (dictionary["latitude"] as! Double)
        self.longitude = (dictionary["longitude"] as! Double)
        
        if dictionary["mapString"] == nil || dictionary["mediaURL"] == nil {
            return nil
        }
        self.mapString = (dictionary["mapString"] as! String)
        self.mediaURL = (dictionary["mediaURL"] as! String)
    }

}

extension StudentInfo {
    
    func annotation() -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = self.latitude
        annotation.coordinate.longitude = self.longitude
        annotation.title = "\(self.firstName) \(self.lastName)"
        annotation.subtitle = self.mediaURL
        return annotation
    }
}
