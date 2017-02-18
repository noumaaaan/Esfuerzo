//
//  ManageAccountViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 13/02/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit

class ManageAccountViewController: UIViewController {

    // Initialise the outlets of the view
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var universityNameTextField: UITextField!
    @IBOutlet weak var courseNameTextField: UITextField!
    
    // Function once the login button is tapped
    @IBAction func submitButtonTapped(_ sender: Any) {
    
        
        
        
    
    }
    
    
    
    // Display the current saved session information into the outlets
    func displayUserInformation(){
        let UserDetails = UserDefaults.standard.stringArray(forKey: "UserDetailsArray") ?? [String]()
        fullNameTextField.text = UserDetails[1]
        universityNameTextField.text = UserDetails[2]
        courseNameTextField.text = UserDetails[3]
        emailTextField.text = UserDetails[4]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        displayUserInformation();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
