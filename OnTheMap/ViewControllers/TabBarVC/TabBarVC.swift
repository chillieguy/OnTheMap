//
//  TabBarVC.swift
//  OnTheMap
//
//  Created by Chuck Underwood on 10/7/18.
//  Copyright © 2018 Chuck Underwood. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    private func presentAddPinVC() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "addStudentView") as! AddStudentVC
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func addPin(_ sender: Any) {
        presentAddPinVC()
    }
    
    @IBAction func logout(_ sender: Any) {
        Auth.shared.logoutUser { (error) in
            if error != nil {
                self.showAlert(title: "Logout Problem", message: "Error logging out of account", dismissHandler: nil)
                return
            }
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
}
