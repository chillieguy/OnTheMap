//
//  Errors.swift
//  OnTheMap
//
//  Created by Chuck Underwood on 10/7/18.
//  Copyright © 2018 Chuck Underwood. All rights reserved.
//

import Foundation

enum Errors: String {
    case CredentialError = "Account not found or wrong login information."
    case CredentialExpired = "Please try logging in again."
    case NetworkError = "No Network Available."
    case ServerError = "Invalid Server Response."
    case UnknownError = "Unknow Error.  Sorry I am not more helpful."
}
