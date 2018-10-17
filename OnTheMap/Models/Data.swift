//
//  File.swift
//  OnTheMap
//
//  Created by Chuck Underwood on 10/7/18.
//  Copyright © 2018 Chuck Underwood. All rights reserved.
//

import Foundation

class Data {
    
    static let shared: Data = Data()
    
    private init() {}
    
    func getUser() -> Response? {
        
        let sessionId = UserDefaults.standard.string(forKey: "UdacityAuthResponse.sessionId")
        let accountKey = UserDefaults.standard.string(forKey: "UdacityAuthResponse.accountKey")
        let expirationString = UserDefaults.standard.string(forKey: "UdacityAuthResponse.dateString")
        if (sessionId != nil && accountKey != nil && expirationString != nil) {
            return Response(sessionId: sessionId!, expirationString: expirationString!, accountKey: accountKey!)
        }
        return nil
    }
    
    func storeUser(_ auth: Response) {
        
        UserDefaults.standard.set(auth.sessionId, forKey: "UdacityAuthResponse.sessionId")
        UserDefaults.standard.set(auth.accountKey, forKey: "UdacityAuthResponse.accountKey")
        UserDefaults.standard.set(auth.dateString(), forKey: "UdacityAuthResponse.dateString")
    }
    
    func clearUser() {
        
        UserDefaults.standard.removeObject(forKey: "UdacityAuthResponse.sessionId")
        UserDefaults.standard.removeObject(forKey: "UdacityAuthResponse.accountKey")
        UserDefaults.standard.removeObject(forKey: "UdacityAuthResponse.dateString")
    }
}

