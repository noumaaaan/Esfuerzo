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
    
    let timeDatePicker = UIDatePicker()
    
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
        
        createStartTimePicker()
        createEndTimePicker()
    }
    
    let SubjectsPicker = UIPickerView()
    let InstructorPicker = UIPickerView()
    let LocationPicker = UIPickerView()
    
    /*
     * START:- DATE AND TIME PICKER FUNCTIONS
     *
     */
    
    // Function to create the time picker
    func createStartTimePicker(){
        let toolbar = UIToolbar() // Create the toolbar
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(finishStartTimePicker)) // Create the bar button item and call function
        toolbar.setItems([doneButton], animated: false)
        
        timeDatePicker.datePickerMode = .time
        timeDatePicker.locale = Locale(identifier: "en_GB") // Local time always

        startTimeTextField.inputAccessoryView = toolbar // Assign the toolbar to the picker
        startTimeTextField?.inputView = timeDatePicker // Assign the date picker to the textfield
    }

    func createEndTimePicker(){
        let toolbar = UIToolbar() // Create the toolbar
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(finishEndTimePicker)) // Create the bar button item and call function
        toolbar.setItems([doneButton], animated: false)
        
        timeDatePicker.datePickerMode = .time
        timeDatePicker.locale = Locale(identifier: "en_GB") // Local time always
        
        endTimeTextField.inputAccessoryView = toolbar // Assign the toolbar to the picker
        endTimeTextField?.inputView = timeDatePicker // Assign the date picker to the textfield
    }
    
    // Function run when the user selects the time from the picker
    func finishStartTimePicker(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "HH:mm"
        
        startTimeTextField.text = dateFormatter.string(from: timeDatePicker.date)
        
        self.view.endEditing(true)
    }
    
    // Function run when the user selects the time from the picker
    func finishEndTimePicker(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "HH:mm"
        
        endTimeTextField.text = dateFormatter.string(from: timeDatePicker.date)
        
        self.view.endEditing(true)
    }
    
    /*
     * END:- DATE AND TIME PICKER FUNCTIONS
     *
     */

    
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
    
    // Function to add a timetable event
    @IBAction func addTimeTableEvent(_ sender: Any) {
    
        let subjectField = selectCourseTextField.text!
        let instructor = selectInstructorTextField.text!
        let location = selectLocationTextField.text!
        let startTime = startTimeTextField.text!
        let endTime = endTimeTextField.text!
        let user_id = userDetails[0]
        
        // If the fields are empty, display an alert and return
        if (subjectField.isEmpty || instructor.isEmpty || location.isEmpty || startTime.isEmpty || endTime.isEmpty) {
            print("Error: All of the fields must be completed")
            displayAlertMessage(userTitle: "Empty", userMessage: "All of the fields must be completed", alertAction: "Return")
            return;
        }
        
        // Check that the end time is greater than start
        if (endTime < startTime) {
            print("Error: End cannot be before start")
            displayAlertMessage(userTitle: "Error", userMessage: "The end time cannot be earlier than the start time", alertAction: "Return")
            return;
        }
        
        // If not empty, do a post request to the server with the details
        let myUrl = NSURL(string: "https://www.noumanmehmood.com/scripts/addTimetableEvent.php");
        let request = NSMutableURLRequest(url:myUrl! as URL)
        
        request.httpMethod = "POST";
        let postString = "subjectField=\(subjectField)&instructor=\(instructor)&location=\(location)&startTime=\(startTime)&endTime=\(endTime)&user_id=\(user_id)";
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
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
                    let resultmess:String = parseJSON["message"] as! String;
                    
                    print(resultmess)
                    // If successful, initiate session and satore all the fields into an array
                    if (resultValue == "Success"){
                        
                        DispatchQueue.main.async{
                            self.displayAlertMessage(userTitle: "Success", userMessage: "Successfully updated the database for this deadline", alertAction: "Return")
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    // Function to retrieve the subjects
    func retrieveSubjects(){
        let myUrl = NSURL(string: "https://www.noumanmehmood.com/scripts/retrieveSubjects.php");
        let request = NSMutableURLRequest(url:myUrl! as URL)
        let user_id = userDetails[0]
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

    // Function to retrieve the instructors
    func retrieveInstructors(){
        let myUrl = NSURL(string: "https://www.noumanmehmood.com/scripts/retrieveInstructors.php");
        let request = NSMutableURLRequest(url:myUrl! as URL)
        let user_id = userDetails[0]
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
        let request = NSMutableURLRequest(url:myUrl! as URL)
        let user_id = userDetails[0]
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
    
    // Function to display an alert message parameters for the title, message and action type
    func displayAlertMessage(userTitle: String, userMessage:String, alertAction:String){
        let theAlert = UIAlertController(title: userTitle, message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: alertAction, style:UIAlertActionStyle.default, handler:nil)
        theAlert.addAction(okAction)
        self.present(theAlert, animated: true, completion: nil)
    }
    
}

