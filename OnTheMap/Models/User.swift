//
//  User.swift
//  OnTheMap
//
//  Created by Chuck Underwood on 10/7/18.
//  Copyright © 2018 Chuck Underwood. All rights reserved.
//

import Foundation

class User {
    
    var firstName: String
    var lastName: String
    var nickName: String
    var imageUrl: String
    
    init(_ dictionary: NSDictionary) {
        let user: NSDictionary = dictionary["user"] as! NSDictionary
        
        self.firstName = user["first_name"] as? String ?? ""
        self.lastName = user["last_name"] as? String ?? ""
        self.nickName = user["nickname"] as? String ?? ""
        self.imageUrl = user["_image_url"] as? String ?? ""
    }
    
    func isValid() -> Bool {
        return !self.firstName.isEmpty && !self.lastName.isEmpty
    }
}

