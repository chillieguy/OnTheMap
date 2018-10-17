//
//  Cache.swift
//  OnTheMap
//
//  Created by Chuck Underwood on 10/7/18.
//  Copyright © 2018 Chuck Underwood. All rights reserved.
//

import Foundation

class Cache {
    
    static let shared = Cache()
    
    var userInfo: User?
    var studentLocations: [StudentInfo]
    
    private init() {
        studentLocations = [StudentInfo]()
    }
    
    func clear() {
        userInfo = nil
        studentLocations.removeAll()
    }
}

