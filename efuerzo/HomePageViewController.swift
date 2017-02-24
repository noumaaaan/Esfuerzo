//
//  HomePageViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 07/02/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {
    
    @IBOutlet weak var DateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DisplayTheDate()
    }
    
    // Function to display the date at start
    func DisplayTheDate(){
        
        let currentDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_GB") as Locale!
        dateFormatter.dateStyle = DateFormatter.Style.full
        let convertedDate = dateFormatter.string(from: currentDate as Date)
        DateLabel.text = convertedDate;
    }
    
}
