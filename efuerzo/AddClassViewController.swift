//
//  AddClassViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 06/03/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit

class AddClassViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // Array with user information
    let userDetails: [String] = UserDefaults.standard.stringArray(forKey:"UserDetailsArray")!
    
    // Dictionaries to store the retrieved user data
    var subjectsDict: [String:AnyObject]?
    var instructDict: [String:AnyObject]?
    var locationDict: [String:AnyObject]?
    
    // Storyboard outlets
    @IBOutlet weak var selectCourseTextField: UITextField!
    @IBOutlet weak var selectInstructorTextField: UITextField!
    @IBOutlet weak var selectLocationTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    
    // Run when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        self.retrieveSubjects()
        self.retrieveLocations()
        self.retrieveInstructors()
        
        // Bind the text field to the picker view
        SubjectsPicker.tag = 1
        SubjectsPicker.dataSource = self
        SubjectsPicker.delegate = self
        selectCourseTextField?.inputView = SubjectsPicker
        
        InstructorPicker.tag = 2
        InstructorPicker.dataSource = self
        InstructorPicker.delegate = self
        selectInstructorTextField?.inputView = InstructorPicker
    
        LocationPicker.tag = 3
        LocationPicker.dataSource = self
        LocationPicker.delegate = self
        selectLocationTextField?.inputView = LocationPicker
    }
    
    let SubjectsPicker = UIPickerView()
    let InstructorPicker = UIPickerView()
    let LocationPicker = UIPickerView()
    
    
    // Picker view (drop down selection) functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 1){
            if (self.subjectsDict != nil){
                return self.subjectsDict!.count
            }
            
        } else if (pickerView.tag == 2) {
            if (self.instructDict != nil){
                return self.instructDict!.count
            }
            
        } else {
            if (self.locationDict != nil){
                return self.locationDict!.count
            }
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var stringValue = String()
        
        if (pickerView.tag == 1){
            if let array = self.subjectsDict?[String(row + 1)] as? [String] {
                stringValue = array[0] + " - " + array[1]
            }
            
        } else if (pickerView.tag == 2){
            if let array = self.instructDict?[String(row + 1)] as? [String] {
                stringValue = array[0] + " " + array[1]
            }
            
        } else {
            if let array = self.locationDict?[String(row + 1)] as? [String] {
                stringValue = array[0]
            }
        }
        return stringValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 1){
            if let array = self.subjectsDict?[String(row + 1)] as? [String] {
                selectCourseTextField?.text = array[0] + " - " + array[1]
            }
            
        } else if (pickerView.tag == 2){
            if let array = self.instructDict?[String(row + 1)] as? [String] {
                selectInstructorTextField.text = array[0] + " " + array[1]
            }
            
        } else {
            if let array = self.locationDict?[String(row + 1)] as? [String] {
                selectLocationTextField.text = array[0]
            }
        }
        self.view.endEditing(false)
    }
    

    // Function to retrieve the subjects
    func retrieveSubjects(){
        let myUrl = NSURL(string: "https://www.noumanmehmood.com/scripts/retrieveSubjects.php");
        let request = NSMutableURLRequest(url:myUrl as! URL)
        let user_id = userDetails[0]
        request.httpMethod = "POST";
        let postString = "user_id=\(user_id)";
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
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

    // Function to retrieve the instructors
    func retrieveInstructors(){
        let myUrl = NSURL(string: "https://www.noumanmehmood.com/scripts/retrieveInstructors.php");
        let request = NSMutableURLRequest(url:myUrl as! URL)
        let user_id = userDetails[0]
        request.httpMethod = "POST";
        let postString = "user_id=\(user_id)";
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            var err: NSError?
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                if let parseJSON = json {
                    let checker:String = parseJSON["status"] as! String;
                    if(checker == "Success"){
                        let resultValue = parseJSON["instructors"] as! [String:AnyObject]
                        self.instructDict = resultValue
                    }
                }
            } catch let error as NSError {
                err = error
                print(err!);
            }
        }
        task.resume();
    }
    
    // Function to retrieve the locations
    func retrieveLocations(){
        let myUrl = NSURL(string: "https://www.noumanmehmood.com/scripts/retrieveLocations.php");
        let request = NSMutableURLRequest(url:myUrl as! URL)
        let user_id = userDetails[0]
        request.httpMethod = "POST";
        let postString = "user_id=\(user_id)";
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            var err: NSError?
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                if let parseJSON = json {
                    let checker:String = parseJSON["status"] as! String;
                    if(checker == "Success"){
                        let resultValue = parseJSON["locations"] as! [String:AnyObject]
                        self.locationDict = resultValue
                    }
                }
            } catch let error as NSError {
                err = error
                print(err!);
            }
        }
        task.resume();
    }
    
}
