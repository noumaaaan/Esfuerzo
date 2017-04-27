//
//  LogTableViewCell.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 24/04/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit

class LogTableViewCell: UITableViewCell {

    // Outlets for the table view in the log view controller
    @IBOutlet weak var subjectNameLabel: UILabel!
    @IBOutlet weak var hoursWorkedLabel: UILabel!
    @IBOutlet weak var totalHoursLabel: UILabel!
    @IBOutlet weak var logIDLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
