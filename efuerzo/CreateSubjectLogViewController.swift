//
//  CreateSubjectLogViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 25/04/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit

class CreateSubjectLogViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // Initialise the storyboard outlets
    @IBOutlet weak var subjectNameLabel: UITextField!
    @IBOutlet weak var PlannedStudyHoursLabel: UITextField!
    
    // Instantiating variables to be used within the class
    let SubjectsPicker = UIPickerView()
    let UserDetails = UserDefaults.standard.stringArray(forKey: "UserDetailsArray") ?? [String]()
    var subjectsDict: [String:AnyObject]?
    
    // Run this function when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.retrieveSubjects()
        
        SubjectsPicker.dataSource = self
        SubjectsPicker.delegate = self
        subjectNameLabel?.inputView = SubjectsPicker
    }

    // Function to check if a given string is an integer
    func isStringAnInt(string: String) -> Bool {
        return Int(string) != nil
    }
    
    // Function to be run when the create button is pressed
    @IBAction func createLogButtonTapped(_ sender: Any) {
        let subject = subjectNameLabel.text!
        let required = PlannedStudyHoursLabel.text!
        let user_id = UserDetails[0]
        let weekStart = UserDetails[9]
        let weekEnd = UserDetails[10]
        
        print("processing")
        
        // If the fields are empty, display an alert and return
        if (subject.isEmpty || required.isEmpty) {
            print("Error: All of the fields must be completed")
            displayAlertMessage(userTitle: "Empty", userMessage: "All of the fields must be completed", alertAction: "Return to edit")
            return;
        }
        
        if (!isStringAnInt(string: required)){
            print("The string passed is not an integer: " + required)
            displayAlertMessage(userTitle: "Error", userMessage: "Required hours can only be a number obviously", alertAction: "Return to edit")
            return;
        }
        
        // If not empty, do a post request to the server with the details
        let myUrl = NSURL(string: "https://www.noumanmehmood.com/scripts/addNewSubjectLog.php");
        let request = NSMutableURLRequest(url:myUrl! as URL)
        
        request.httpMethod = "POST";
        let postString = "subject=\(subject)&required=\(required)&user_id=\(user_id)&weekStart=\(weekStart)&weekEnd=\(weekEnd)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            
            // Parse the results of the JSON result and naivigate to app if success
            var err: NSError?
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                if let parseJSON = json {
                    
                    let resultValue:String = parseJSON["status"] as! String;
                    
                    if (resultValue == "Success"){
                        DispatchQueue.main.async{
                            self.displayAlertMessage(userTitle: "Success", userMessage: "Successfully created a new log for this subject", alertAction: "Return")
                            return
                        }
                    }
                }
            } catch let error as NSError {
                err = error
                print(err!);
            }
        }
        task.resume();
    }

    // Picker view (drop down selection) functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The count of rows to be displayed in the picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        if (self.subjectsDict != nil){
            return self.subjectsDict!.count
        }

        return 1
    }
    
    // The text titles for each of the rows in the picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var stringValue = String()
        
        if let array = self.subjectsDict?[String(row + 1)] as? [String] {
            stringValue = array[0] + " - " + array[1]
        }
        return stringValue
    }
    
    // When the row is selected, what should happen
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let array = self.subjectsDict?[String(row + 1)] as? [String] {
            subjectNameLabel?.text = array[0] + " - " + array[1]
        }
        self.view.endEditing(false)
    }
    
    // Function to retrieve the subjects
    func retrieveSubjects(){
        let myUrl = NSURL(string: "https://www.noumanmehmood.com/scripts/retrieveSubjects.php");
        let request = NSMutableURLRequest(url:myUrl! as URL)
        let user_id = UserDetails[0]
        request.httpMethod = "POST";
        let postString = "user_id=\(user_id)";
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            
            var err: NSError?
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                if let parseJSON = json {
                    let checker:String = parseJSON["status"] as! String;
                    if(checker == "Success"){
                        let resultValue = parseJSON["subjects"] as! [String:AnyObject]
                        self.subjectsDict = resultValue
                    }
                }
            } catch let error as NSError {
                err = error
                print(err!);
            }
        }
        task.resume();
    }

    // Function to display an alert message parameters for the title, message and action type
    func displayAlertMessage(userTitle: String, userMessage:String, alertAction:String){
        let theAlert = UIAlertController(title: userTitle, message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: alertAction, style:UIAlertActionStyle.default, handler:nil)
        theAlert.addAction(okAction)
        self.present(theAlert, animated: true, completion: nil)
    }
}
