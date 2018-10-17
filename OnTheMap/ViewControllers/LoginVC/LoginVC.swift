//
//  LoginVC
//  OnTheMap
//
//  Created by Chuck Underwood on 10/7/18.
//  Copyright © 2018 Chuck Underwood. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTF.delegate = self
        passwordTF.delegate = self
        
        hideKeyboardWhenTappedAround()
        
        
        Auth.shared.autoLogin { (errors) in
            DispatchQueue.main.async {
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        subscribeToKeyboardNotifications()
        activityIndicator.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        unsubscribeFromKeyboardNotifications()
        
    }

    @IBAction func login(_ sender: Any) {
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        performLogin()
        
    
    }
    
    func performLogin() {
        
        let email = emailTF.text!
        let password = passwordTF.text!
        
        if email.isEmpty || password.isEmpty {
            showAlert(title: "Try Again", message: "Please enter both an email and password.", dismissHandler: nil)
            return
        }
        
        Auth.shared.loginUser(email: email, password: password, onComplete: {error in
            DispatchQueue.main.async(execute: {
                self.onLoginResult(error: error)
            })
        })
        
    }
    
    func onLoginResult(error: Errors?) {
        
        if error == nil {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") {
                present(vc, animated: true, completion: nil)
            }
            return
        }
        
        if error! == Errors.CredentialExpiredError {
            return
        }
        
        showAlert(title: "Error", message: (error)!.rawValue, dismissHandler: nil)
    }
    
}



extension LoginVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == emailTF) {
            passwordTF.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            performLogin()
        }
        return true
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillChange(_ notification:Notification) {
        
        let safeBottom = self.passwordTF.frame.maxY + 16
        
        let keyboardTop = self.view.frame.height - getKeyboardHeight(notification)
        
        let offset = safeBottom - keyboardTop
        
        if (offset <= 0) {
            return
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame.origin.y = 0
            self.view.frame.origin.y -= offset
        })
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame.origin.y = 0
        })
    }
    
    private func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
}

