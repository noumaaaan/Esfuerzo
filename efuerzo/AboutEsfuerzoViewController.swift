//
//  AboutEsfuerzoViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 10/04/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit

class AboutEsfuerzoViewController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Send the users to the calendar framework page
    @IBAction func ShowCalendarFramework(_ sender: Any) {
        let githubPage = URL(string: "https://patchthecode.github.io/")!
        UIApplication.shared.open(githubPage)
    }

}
