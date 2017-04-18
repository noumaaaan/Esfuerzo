//
//  editDeadlinesViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 17/04/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit
import M13Checkbox

class editDeadlinesViewController: UIViewController {

    // Initialise the storyboard outlets
    @IBOutlet weak var checkboxOutlet: M13Checkbox!
    
    @IBOutlet weak var subjectNameTextField: UITextField!
    @IBOutlet weak var deadlineTitleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var dueDateTextField: UITextField!
    
    // Defining the array from the previous controller
    var arr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(arr[0])
        
//        self.setDefaultValues()
    }
    
    // Function to add the select values to the textfields
    func setDefaultValues(){
        

    
        
        subjectNameTextField.text = arr[0]
        deadlineTitleTextField.text = arr[1]
        descriptionTextField.text = arr[2]
        dueDateTextField.text = arr[4]
    }

    // Run this function when the checkbox state is changed
    @IBAction func checkboxStateChanged(_ sender: Any) {
        print(checkboxOutlet._IBCheckState)
        checkboxOutlet.toggleCheckState()
        print(checkboxOutlet._IBCheckState)
    }
    
    
    
}
