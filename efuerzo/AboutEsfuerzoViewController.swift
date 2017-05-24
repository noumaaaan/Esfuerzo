//
//  AboutEsfuerzoViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 10/04/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit

class AboutEsfuerzoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Send the users to the calendar framework page
    @IBAction func ShowCalendarFramework(_ sender: Any) {
        let githubPage = URL(string: "https://github.com/patchthecode/JTAppleCalendar")!
        UIApplication.shared.open(githubPage)
    }

    // Send the users to the Checkbox framework page
    @IBAction func showCheckboxFramework(_ sender: Any) {
        let githubPage = URL(string: "https://github.com/Marxon13/M13Checkbox")!
        UIApplication.shared.open(githubPage)
    }
}
 
