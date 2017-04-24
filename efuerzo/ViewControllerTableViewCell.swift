//
//  ViewControllerTableViewCell.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 23/03/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit

class ViewControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var subjectNameLabel: UILabel!
    @IBOutlet weak var instructorNameLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var classTypeLabel: UILabel!
    @IBOutlet weak var classLengthLabel: UILabel!
    @IBOutlet weak var timeRemaining: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
