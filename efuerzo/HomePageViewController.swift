//
//  HomePageViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 07/02/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {
    
    
    // Initialise storyboard outlets
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    // Retrive the saved user details
    let userDetails: [String] = UserDefaults.standard.stringArray(forKey:"UserDetailsArray")!
    
    // Run this function when the view loads
    override func viewDidLoad() {

        super.viewDidLoad()

        self.DisplayTheDate()
        self.quoteLabel.text = userDetails[8]
        self.welcomeLabel.text = "Welcome " + userDetails[2] + "!"
        
        self.hideKeyboardWhenTappedAround()
        self.dismissKeyboard()
        
    }
    
    // Function to display the date at start
    func DisplayTheDate(){
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_GB") as Locale!
        dateFormatter.dateFormat = "EEEE d MMMM yyyy"
        let convertedDate = dateFormatter.string(from: currentDate as Date)
        DateLabel.text = convertedDate;
    }
    
    /*
     * Motivational quotes have been taken from this website
     * http://www.timothysykes.com/blog/the-best-motivational-quotes-part-2/
     */
  
}
