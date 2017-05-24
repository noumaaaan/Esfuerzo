//
//  editDeadlinesViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 17/04/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit
import M13Checkbox

class editDeadlinesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // Initialise the storyboard outlets
    @IBOutlet weak var checkboxOutlet: M13Checkbox!
    
    @IBOutlet weak var subjectNameTextField: UITextField!
    @IBOutlet weak var deadlineTitleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var dueDateTextField: UITextField!
    @IBOutlet weak var dueTimeTextField: UITextField!
    
    // Instantiating variables to be used within the class
    var arr = [String]() // Defining the array from the previous controller
    let UserDetails = UserDefaults.standard.stringArray(forKey: "UserDetailsArray") ?? [String]()
    let SubjectsPicker = UIPickerView()
    
    let dateTimePicker = UIDatePicker()
    let timeDatePicker = UIDatePicker()
    
    var subjectsDict: [String:AnyObject]?

    // Run this function when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setDefaultValues()
        self.setTextViewProperties()
        
        self.retrieveSubjects()
        
        // Bind the text field to the picker view
        SubjectsPicker.tag = 1
        SubjectsPicker.dataSource = self
        SubjectsPicker.delegate = self
        subjectNameTextField?.inputView = SubjectsPicker
        
        createDatePicker()
        createTimePicker()
    }
    
    // Function to create the date picker
    func createDatePicker(){
        let toolbar = UIToolbar() // Create the toolbar
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(finishDatePicker)) // Create the bar button item and call function
        toolbar.setItems([doneButton], animated: false)
        
        dateTimePicker.datePickerMode = .date
        
        dateTimePicker.tag = 2
        dueDateTextField.inputAccessoryView = toolbar // Assign the toolbar to the picker
        dueDateTextField?.inputView = dateTimePicker // Assign the date picker to the textfield
    }
    
    // Function to create the time picker
    func createTimePicker(){
        let toolbar = UIToolbar() // Create the toolbar
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(finishTimePicker)) // Create the bar button item and call function
        toolbar.setItems([doneButton], animated: false)
        
        timeDatePicker.datePickerMode = .time
        timeDatePicker.locale = Locale(identifier: "en_GB") // using Great Britain for this example
        
        timeDatePicker.tag = 3
        dueTimeTextField.inputAccessoryView = toolbar // Assign the toolbar to the picker
        dueTimeTextField?.inputView = timeDatePicker // Assign the date picker to the textfield
    }
    
    // Function run when the user selects the date from the picker
    func finishDatePicker(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        dueDateTextField.text = dateFormatter.string(from: dateTimePicker.date)
        self.view.endEditing(true)
    }
    
    // Function run when the user selects the time from the picker
    func finishTimePicker(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "HH:mm"
        
        dueTimeTextField.text = dateFormatter.string(from: timeDatePicker.date)
        self.view.endEditing(true)
    }
    
    
    // Picker view (drop down selection) functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The count of rows to be displayed in the picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 1){
            if (self.subjectsDict != nil){
                return self.subjectsDict!.count
            }
        }
        return 1
    }
    
    // The text titles for each of the rows in the picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var stringValue = String()
        
        if (pickerView.tag == 1){
            if let array = self.subjectsDict?[String(row + 1)] as? [String] {
                stringValue = array[0] + " - " + array[1]
            }
        }
        return stringValue
    }
    
    // When the row is selected, what should happen
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 1){
            if let array = self.subjectsDict?[String(row + 1)] as? [String] {
                subjectNameTextField?.text = array[0] + " - " + array[1]
            }
        }
        self.view.endEditing(false)
    }
    
    // Function to set the properties of the UITextview
    func setTextViewProperties(){
        let borderColor = UIColor.init(red: 212/255, green: 212/255, blue: 212/255, alpha: 0.5)
        self.descriptionTextField.layer.borderColor = borderColor.cgColor
        self.descriptionTextField.layer.borderWidth = 0.8
        self.descriptionTextField.layer.cornerRadius = 5
        self.descriptionTextField.layer.backgroundColor = UIColor.clear.cgColor
    }
    
    // Function to set default values for the textfields
    func setDefaultValues(){
        subjectNameTextField.text = arr[0]
        deadlineTitleTextField.text = arr[1]
        descriptionTextField.text = arr[2]
        dueDateTextField.text = arr[5]
        dueTimeTextField.text = arr[4]
        
        // Set the checkbox value deepending on task completion
        if (arr[3] == "1") {
            checkboxOutlet.setCheckState(.checked, animated: true)
        } else {
            checkboxOutlet.setCheckState(.unchecked, animated: true)
        }
    }
    
    // Run this function to save the values
    @IBAction func saveDeadlineDetailsToServer(_ sender: Any) {

        let subject = subjectNameTextField.text!
        let title = deadlineTitleTextField.text!
        let description = descriptionTextField.text!
        let due_date = dueDateTextField.text!
        let due_time = dueTimeTextField.text!
        let user_id = UserDetails[0]
        let completion = checkboxOutlet._IBCheckState
        
        // Check that the values are not the same as before
        if ((subject == arr[0]) && (title == arr[1]) && (description == arr[2]) && (due_date == arr[4] + " " + arr[5]) ){
            print("No changes made in Edit the deadline")
            displayAlertMessage(userTitle: "No changes", userMessage: "These details are already saved", alertAction: "Return")
            return;
        }
        
        // If the fields are empty, display an alert and return
        if (subject.isEmpty || title.isEmpty || description.isEmpty || due_date.isEmpty || due_time.isEmpty) {
            print("Error: All of the fields must be completed")
            displayAlertMessage(userTitle: "Empty", userMessage: "All of the fields must be completed", alertAction: "Return to edit")
            return;
        }
        
        // If not empty, do a post request to the server with the details
        let myUrl = NSURL(string: "https://www.noumanmehmood.com/scripts/editDeadlines.php");
        let request = NSMutableURLRequest(url:myUrl! as URL)
        
        request.httpMethod = "POST";
        let postString = "subject=\(subject)&title=\(title)&description=\(description)&due_date=\(due_date)&due_time=\(due_time)&user_id=\(user_id)&completion=\(completion)&deadline_id=\(arr[8])"
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
                    
                    // If successful, initiate session and satore all the fields into an array
                    if (resultValue == "Success"){
                        
                        let resultMessage:String = parseJSON["message"] as! String;
                        print(resultMessage)
                        
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
