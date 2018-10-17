//
//  Responses.swift
//  OnTheMap
//
//  Created by Chuck Underwood on 10/7/18.
//  Copyright © 2018 Chuck Underwood. All rights reserved.
//

import Foundation

class Response {
    
    var sessionId: String
    var expiration: Date
    var accountKey: String
    
    init(sessionId: String, expirationString: String, accountKey: String) {
        self.sessionId = sessionId
        self.accountKey = accountKey
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        dateFormatter.timeZone = TimeZone.current
    
        let defaultExpiration = Calendar.current.date(byAdding: .hour, value: 1, to: Date())
        
        self.expiration =  dateFormatter.date(from: expirationString) ?? defaultExpiration!
    }
    
    init(_ dictionary: NSDictionary) {
        let account: NSDictionary = dictionary[Api.UdacityAuth.KEY_ACCOUNT] as! NSDictionary
        self.accountKey = account[Api.UdacityAuth.KEY_ACC_KEY] as! String
        
        let session: NSDictionary = dictionary[Api.UdacityAuth.KEY_SESSION] as! NSDictionary
        self.sessionId = session[Api.UdacityAuth.KEY_ID] as! String
        
        let expirationString: String = session[Api.UdacityAuth.KEY_EXPIRATION] as! String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        dateFormatter.timeZone = TimeZone.current
        
        let defaultExpiration = Calendar.current.date(byAdding: .hour, value: 1, to: Date())
        
        self.expiration =  dateFormatter.date(from: expirationString) ?? defaultExpiration!
    }
    
    func dateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        dateFormatter.timeZone = TimeZone.current
        
        return dateFormatter.string(from: self.expiration)
    }
    
    func isExpired() -> Bool {
        return Date() > self.expiration
    }
}
