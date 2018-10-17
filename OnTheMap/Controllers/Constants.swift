//
//  Constants.swift
//  OnTheMap
//
//  Created by Chuck Underwood on 10/7/18.
//  Copyright © 2018 Chuck Underwood. All rights reserved.
//

import Foundation

struct Api {
    
    static let PARSE_ENPOINT_URL = "https://parse.udacity.com/parse/classes"
    static let PARSE_APP_ID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let REST_API_KEY = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    struct Method {
        static let GET: String = "GET"
        static let POST: String = "POST"
        static let DELETE: String = "DELETE"
    }
    
    struct HeaderKey {
        static let CONTENT_TYPE = "Content-Type"
        static let ACCEPT = "Accept"
    }
    
    struct HeaderValue {
        static let MIME_TYPE_JSON = "application/json"
    }
    
    struct UdacityAuth {
        static let KEY_UDACITY = "udacity"
        static let KEY_USERNAME = "username"
        static let KEY_PASSWORD = "password"
        
        static let KEY_STATUS = "status"
        static let KEY_ACCOUNT = "account"
        static let KEY_ACC_KEY = "key"
        static let KEY_SESSION = "session"
        static let KEY_ID = "id"
        static let KEY_EXPIRATION = "expiration"
    }
}
