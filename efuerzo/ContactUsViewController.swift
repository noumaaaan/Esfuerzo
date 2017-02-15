//
//  ContactUsViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 15/02/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController {

    // Initialise the outlets
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextView!
    
    // Function when the submit button is clicked
    @IBAction func submitButtonTapped(_ sender: Any) {
        
        let subject = subjectTextField.text!
        let message = messageTextField.text!
        
        if (subject.isEmpty || message.isEmpty){
            // display error message
            return
        }

        // Do the post request here
        // Parse JSON Result
        // Display alert to the user 
        // Return to preferences tab
    }
    
    // Function to set the properties of the UITextview
    func setTextViewProperties(){
        let borderColor = UIColor.init(red: 212/255, green: 212/255, blue: 212/255, alpha: 0.5)
        
        self.messageTextField.layer.borderColor = borderColor.cgColor
        self.messageTextField.layer.borderWidth = 0.8
        self.messageTextField.layer.cornerRadius = 5
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextViewProperties()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
