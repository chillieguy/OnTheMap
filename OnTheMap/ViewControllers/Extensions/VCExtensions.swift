//
//  VCExtensions.swift
//  OnTheMap
//
//  Created by Chuck Underwood on 10/7/18.
//  Copyright © 2018 Chuck Underwood. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String, dismissHandler: ((UIAlertAction) -> Void)?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: dismissHandler))
        self.present(alertVC, animated: true)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func openLinkInSafari(url: String?) {
        if let url = URL(string: url!) {
            let app = UIApplication.shared
            app.open(url, options: [:], completionHandler: nil)
        } else {
            showAlert(title: "Ooops!", message: "The media URL provided by this student is not a valid URL", dismissHandler: nil)
        }
    }
    
}
