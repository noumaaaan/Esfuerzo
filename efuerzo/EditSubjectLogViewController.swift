//
//  EditSubjectLogViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 26/04/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit

class EditSubjectLogViewController: UIViewController {
    
    // Initialise the storyboard outlets
    @IBOutlet weak var subjectNameLabel: UILabel!
    
    @IBOutlet weak var recommendedHoursTextField: UITextField!
    @IBOutlet weak var savedHoursTextField: UITextField!
    @IBOutlet weak var hoursStudiedTextField: UITextField!
    
    
    // Variables to be used within the class
    var arr = [String]()
    let timeDatePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()

        setDefaultValues()
        createTimePicker()
    }
    
    // Set the default values for the labels from the passed array
    func setDefaultValues(){
        subjectNameLabel.text = arr[1]
        recommendedHoursTextField.text = arr[2]
        hoursStudiedTextField.text = arr[3]
    }

    // Function to create the date picker
    func createTimePicker(){
        let toolbar = UIToolbar() // Create the toolbar
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(finishTimePicker)) // Create the bar button item and call function
        toolbar.setItems([doneButton], animated: false)
        
        timeDatePicker.datePickerMode = .countDownTimer
        
        timeDatePicker.tag = 2
        recommendedHoursTextField.inputAccessoryView = toolbar // Assign the toolbar to the picker
        recommendedHoursTextField?.inputView = timeDatePicker // Assign the date picker to the textfield
    }
    
    // Function run when the user selects the date from the picker
    func finishTimePicker(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "HH:mm"
        
        recommendedHoursTextField.text = dateFormatter.string(from: timeDatePicker.date)
        self.view.endEditing(true)
    }
    
    
}
