//
//  AddTimetableViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 02/03/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit

class AddTimetableViewController: UIViewController {

    // The saveed user details which is an array
    let UserDetails = UserDefaults.standard.stringArray(forKey: "UserDetailsArray") ?? [String]()
    
    @IBOutlet weak var verificationCodeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.verificationCodeLabel.text  = UserDetails[7]
    }
    
    @IBAction func redirectToWebsite(_ sender: Any) {
        if let url = URL(string: "https://esfuerzo.noumanmehmood.com/add_timetable.php") {
            UIApplication.shared.open(url as URL)
        }
    }

    
}
