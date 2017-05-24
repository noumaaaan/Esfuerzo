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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func requestTimetableButton(_ sender: Any) {
        if let url = URL(string: "http://celcatweb.aston.ac.uk/livetimetable/") {
            UIApplication.shared.open(url as URL)
        }
    }
    
    
    @IBAction func addTimetable(_ sender: Any) {
        if let url = URL(string: "https://esfuerzo.noumanmehmood.com/add_timetable.php") {
            UIApplication.shared.open(url as URL)
        }
    }

//webcals://celcatweb.aston.ac.uk/livetimetable/ical/VK5DBAFV285649/schedule.ics
}
