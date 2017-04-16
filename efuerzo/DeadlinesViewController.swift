//
//  DeadlinesViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 06/02/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit

class DeadlinesViewController: UIViewController {
    
    // Initialisation of the storyboard outlets
    @IBOutlet weak var completeView: UIView!
    @IBOutlet weak var IncompleteView: UIView!
    
    // Run this function when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.dismissKeyboard()
    }
    
    // Function to switch the segmented control view
    @IBAction func SwitchDeadlines(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0, animations: {
                self.completeView.alpha = 0
                self.IncompleteView.alpha = 1
            })
        } else {
            UIView.animate(withDuration: 0, animations: {
                self.completeView.alpha = 1
                self.IncompleteView.alpha = 0
            })
        }
    }

}
