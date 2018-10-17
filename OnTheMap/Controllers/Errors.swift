//
//  Errors.swift
//  OnTheMap
//
//  Created by Chuck Underwood on 10/7/18.
//  Copyright © 2018 Chuck Underwood. All rights reserved.
//

import Foundation

enum Errors: String {
    case WrongCredentialError = "Account not found or invalid credentials."
    case CredentialExpiredError = "Login expired. Please login again."
    case NetworkError = "Please check your network and try again."
    case ServerError = "Server messed up. Please contact developer."
    case UnknownError = "The app is messed up. Please contact developer."
}
