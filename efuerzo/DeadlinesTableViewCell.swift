//
//  DeadlinesTableViewCell.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 14/04/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit

class DeadlinesTableViewCell: UITableViewCell {

    // Outlets for the deadlines controller in the table
    @IBOutlet weak var subjectNameLabel: UILabel!
    @IBOutlet weak var descriptionNameLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var timeDueLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var titleNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
