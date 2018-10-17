//
//  ListVC.swift
//  OnTheMap
//
//  Created by Chuck Underwood on 10/7/18.
//  Copyright © 2018 Chuck Underwood. All rights reserved.
//

import UIKit

class ListVC: UIViewController {

    @IBOutlet weak var studentList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        studentList.delegate = self
        studentList.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        Parse.shared.getStudents(limit: 100, skip: 0, onComplete: {error in
            DispatchQueue.main.async(execute: {
                self.studentList.reloadData()
            })
        })
        
    }
    

}

extension ListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension ListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Cache.shared.studentLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! StudentTableViewCell
        
        cell.setup(studentInfo: Cache.shared.studentLocations[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = Cache.shared.studentLocations[indexPath.row]
        openLinkInSafari(url: student.mediaURL)
        studentList.deselectRow(at: indexPath, animated: true)
    }
    
}
