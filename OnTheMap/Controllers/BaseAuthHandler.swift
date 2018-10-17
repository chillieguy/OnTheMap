//
//  BaseAuthHandler.swift
//  OnTheMap
//
//  Created by Chuck Underwood on 10/7/18.
//  Copyright © 2018 Chuck Underwood. All rights reserved.
//

import Foundation

class BaseAuthHandler: NSObject {
    
    typealias ErrorBlock = ((Errors?) -> Void)
    
    func handleError(error: Error!, onComplete: @escaping ErrorBlock) {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                onComplete(Errors.NetworkError)
                break
            default:
                onComplete(Errors.ServerError)
            }
        }
        onComplete(Errors.ServerError)
    }
    
}
