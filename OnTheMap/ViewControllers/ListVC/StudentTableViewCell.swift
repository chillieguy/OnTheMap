//
//  StudentTableViewCell.swift
//  OnTheMap
//
//  Created by Chuck Underwood on 10/8/18.
//  Copyright © 2018 Chuck Underwood. All rights reserved.
//

import UIKit

class StudentTableViewCell: UITableViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setup(studentInfo: StudentInfo) {
        nameLabel.text = "\(studentInfo.firstName) \(studentInfo.lastName)"
        urlLabel.text = studentInfo.mediaURL
    }

}
