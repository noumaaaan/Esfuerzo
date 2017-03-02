//
//  AddTimetableViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 02/03/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit

class AddTimetableViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    


    @IBAction func redirectToUniCalRequest(_ sender: Any) {
        let astonPage = URL(string: "http://celcatweb.aston.ac.uk/livetimetable/Default.aspx/")!
        UIApplication.shared.open(astonPage)
    }
}
