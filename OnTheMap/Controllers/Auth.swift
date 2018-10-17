//
//  Auth.swift
//  OnTheMap
//
//  Created by Chuck Underwood on 10/7/18.
//  Copyright © 2018 Chuck Underwood. All rights reserved.
//

import Foundation

class Auth: BaseAuthHandler {

    private let AUTH_ENDPOINT_URL: URL = URL(string:"https://www.udacity.com/api/session")!
    private let USER_ENDPOINT_URL: URL = URL(string:"https://www.udacity.com/api/users")!

    static let shared = Auth()

    private override init() {}

    func autoLogin(_ onComplete: @escaping (Errors?) -> Void) {
        
        let authReponse = Data.shared.getUser()
        if authReponse == nil || (authReponse?.isExpired())! {
            onComplete(Errors.CredentialExpired)
            return
        }
        
        
        getUserData(authResponse: authReponse!, onComplete: onComplete)
    }
    
    func loginUser(email: String, password: String,
                       onComplete: @escaping (Errors?) -> Void) {
        var request = URLRequest(url: AUTH_ENDPOINT_URL)
        
        request.httpMethod = Api.Method.POST
        request.addValue(Api.HeaderValue.MIME_TYPE_JSON, forHTTPHeaderField: Api.HeaderKey.CONTENT_TYPE)
        request.addValue(Api.HeaderValue.MIME_TYPE_JSON, forHTTPHeaderField: Api.HeaderKey.ACCEPT)
        
        let credentials = [Api.UdacityAuth.KEY_UDACITY : [ Api.UdacityAuth.KEY_USERNAME : email, Api.UdacityAuth.KEY_PASSWORD: password]]
        let authData = credentials.json()
        request.httpBody = authData.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil {
                self.handleError(error: error, onComplete: onComplete)
                return
            }
            
            let range = 5..<data!.count
            
            let subData = data?.subdata(in: range)
            
            let responseDict = try! JSONSerialization.jsonObject(with: subData!, options: .allowFragments) as! NSDictionary
            
            if responseDict[Api.UdacityAuth.KEY_ACCOUNT] != nil && responseDict[Api.UdacityAuth.KEY_SESSION] != nil {
                
                let authResponse = Response(responseDict)
                Data.shared.storeUser(authResponse)
            
                self.getUserData(authResponse: authResponse, onComplete: onComplete)
                return
            } else if responseDict[Api.UdacityAuth.KEY_STATUS] != nil {
                let status = responseDict[Api.UdacityAuth.KEY_STATUS] as! Int
                if status == 403 {
                    onComplete(Errors.CredentialError)
                    return
                }
            } else {
                
                onComplete(Errors.UnknownError)
            }
        }
        task.resume()
    }
    
    func logoutUser(_ onComplete: @escaping (Errors?) -> Void) {
        var request = URLRequest(url: AUTH_ENDPOINT_URL)
        request.httpMethod = Api.Method.DELETE
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                self.handleError(error: error, onComplete: onComplete)
                return
            }
            
            Cache.shared.clear()
            Data.shared.clearUser()
            
            onComplete(nil)
        }
        task.resume()
    }
    
    private func getUserData(authResponse: Response, onComplete: @escaping (Errors?) -> Void) {
        
        var currentUserEndpointUrl: URL = USER_ENDPOINT_URL
        currentUserEndpointUrl.appendPathComponent(authResponse.accountKey)
        
        let request = URLRequest(url: currentUserEndpointUrl)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                self.handleError(error: error, onComplete: onComplete)
                return
            }
            let range = 5..<data!.count
            let subData = data?.subdata(in: range)
            
            let responseDict = try! JSONSerialization.jsonObject(with: subData!, options: .allowFragments) as! NSDictionary
            
            let user = User(responseDict)
            if user.isValid() {
                Cache.shared.userInfo = user
                onComplete(nil)
            } else {
                onComplete(Errors.ServerError)
            }
        }
        
        task.resume()
    }

}
