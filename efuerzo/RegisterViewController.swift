//
//  RegisterViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 02/02/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Function when the view looads
    override func viewDidLoad() {
        super.viewDidLoad()
        ScrollView.contentSize.height = 1800;
        self.hideKeyboardWhenTappedAround()
        self.dismissKeyboard()
        
        // Bind the text field to the picker view
        picker.dataSource = self
        picker.delegate = self
        SelectUniversityTextField.inputView = picker
    }
    
    // Create an array for the different Universities in the UK
    let picker = UIPickerView()
    let Universities = ["Aberdeen", "Abertay", "Aberystwyth", "Anglia Ruskin", "Arts University Bournemouth", "Aston", "Bangor", "Bath", "Bath Spa", "Bedfordshire", "Birmingham", "Birmingham City", "Bishop Grosseteste", "Bolton", "Bournemouth", "Bradford", "Brighton", "Bristol", "Brunel University London", "Buckingham", "Buckinghamshire New", "Cambridge", "Canterbury Christ Church", "Cardiff", "Cardiff Metropolitan", "Central Lancashire", "Chester", "Chichester", "City, University of London", "Coventry", "Cumbria", "De Monfort", "Derby", "Dundee", "Durham", "East Anglia (UEA)", "East London", "Edge Hill", "Edinburgh", "Edinburgh Napier", "Essex", "Exeter", "Falmouth", "Glasgow", "Glasgow Caledonian", "Gloucestershire", "Glyndwr", "Goldsmiths, University of London", "Greenwich", "Harper Adams", "Heriot-Watt", "Hertfordshire", "Huddersfield", "Hull", "Imperial College London", "Keele", "Kent", "King's College London", "Kingston", "Lancaster", "Leeds", "Leeds Beckett", "Leeds Trinity", "Leicester", "Lincoln", "Liverpool", "Liverpool Hope", "Liverpool John Moores", "London Metropolitan", "London School of Economics", "London South Bank", "Loughborough", "Manchester", "Manchester Metropolitan", "Middlesex", "Newcastle", "Newman", "Northampton", "Northumbria", "Norwich University of the Arts", "Nottingham", "Nottingham Trent", "Oxford", "Oxford Brookes", "Plymouth", "Portsmouth", "Queen Margaret", "Queen Mary, University of London", "Queen's, Belfast", "Reading", "Robert Gordon", "Roehampton", "Royal Agricultural University", "Royal Holloway, University of London", "Salford", "Sheffield", "Sheffield Hallam", "SOAS University of London", "South Wales", "Southampton", "Southampton Solent", "St Andrews", "St George's, University of London", "St Mark and St John", "St Mary's, Twickenham", "Staffordshire", "Stirling", "Strathclyde", "Sunderland", "Surrey", "Sussex", "Swansea", "Teesside", "Ulster", "University College London", "University for the Creative Arts", "University of the Arts, London", "University of Wales Trinity Saint David", "Warwick", "West London", "West of England, Bristol", "West of Scotland", "Westminister", "Winchester", "Worcester", "York", "York St John"]
    
    
    // Picker view (drop down selection) functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Universities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Universities[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        SelectUniversityTextField.text = Universities[row]
        self.view.endEditing(false)
    }
    
    // Initalise storyboard outlets
    @IBOutlet weak var ScrollView: UIScrollView!
    
    @IBOutlet weak var FirstnameTextField: UITextField!
    @IBOutlet weak var SurnameTextField: UITextField!
    @IBOutlet weak var SelectUniversityTextField: UITextField!
    @IBOutlet weak var CourseTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var ConfirmPasswordTextField: UITextField!
    @IBOutlet weak var MemorableTextField: UITextField!
    
    // Function run when register button pressed
    @IBAction func RegisterButtonTapped(_ sender: Any) {
        
        let firstname = FirstnameTextField.text!
        let surname = SurnameTextField.text!
        let uniName = SelectUniversityTextField.text!
        let uniCourse = CourseTextField.text!
        let email = EmailTextField.text!
        let username = usernameTextField.text!
        let password = PasswordTextField.text!
        let confirmPassword = ConfirmPasswordTextField.text!
        let memorable = MemorableTextField.text!

        // Check that none of the fields are empty
        if (firstname.isEmpty) || (surname.isEmpty) || (uniName.isEmpty) || (uniCourse.isEmpty) || (username.isEmpty) || (password.isEmpty) || (confirmPassword.isEmpty) {
            displayAlertMessage(userTitle: "Error", userMessage: "All of the fields are required", alertAction: "Return")
            return;
        }

        // Check that the provided passwords match
        if (password != confirmPassword){
            displayAlertMessage(userTitle: "Password Error", userMessage: "The password combination does not match!", alertAction: "Return")
            return;
        }
        
        // Check that the username length is at least 6 characters
        if (username.characters.count < 6){
            displayAlertMessage(userTitle: "Username too short!", userMessage: "Your username needs to be at least 6 characters long!", alertAction: "Try again")
            return;
        }
        
        // Check that the password length is at least 6 characters
        if (password.characters.count < 6){
            displayAlertMessage(userTitle: "Password too short!", userMessage: "Your password needs to be at least 6 characters long!", alertAction: "Try again")
            return;
        }
        
        // Check that the email is in correct format
        let regularExpressions = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", regularExpressions);
        let emailCheck = emailTest.evaluate(with: email)
        if (!emailCheck){
            displayAlertMessage(userTitle: "Not a Valid Email", userMessage: "The email address provided is not a real email!", alertAction: "Return")
            return;
        }
        
        // If everything is okay, send details to the server
        let myUrl = NSURL(string: "https://www.noumanmehmood.com/scripts/userRegister.php");
        let request = NSMutableURLRequest(url:myUrl as! URL)
        request.httpMethod = "POST";
        
        let postString = "firstname=\(firstname)&surname=\(surname)&uniName=\(uniName)&uniCourse=\(uniCourse)&username=\(username)&password=\(password)&memorable=\(memorable)&email=\(email)";
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            var err: NSError?
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    let resultValue:String = parseJSON["status"] as! String
                    
                    print(resultValue)
                    
                    // If the username already exists, return to the appication
                    if (resultValue == "User exists"){
                        DispatchQueue.main.async{
                            self.displayAlertMessage(userTitle: "Error", userMessage: "The chosen username already exists", alertAction: "Try again")
                            return;
                        }
                    }
                    
                    // Check that email is not already registered
                    if (resultValue == "Email exists"){
                        DispatchQueue.main.async{
                            self.displayAlertMessage(userTitle: "Error", userMessage: "This email is alrady registered. Use another email", alertAction: "Try again")
                            return;
                        }
                    }
                    
                    if(resultValue == "success") {
                        
                        let mailValue:String = parseJSON["mail"] as! String
                        print(mailValue)
                        
                        DispatchQueue.main.async{
                            // Display alert with the confirmation
                            let theAlert = UIAlertController(title:"Complete", message: "Registration complete. Check your email", preferredStyle: UIAlertControllerStyle.alert)
                            
                            let okAction = UIAlertAction(title:"Verify your email", style:UIAlertActionStyle.default){
                                action in
                                self.dismiss(animated: true, completion: nil)
                            }
                            theAlert.addAction(okAction);
                            self.present(theAlert, animated: true, completion: nil)
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
    
    // Function to display an alert message parameters for the title, message and action type
    func displayAlertMessage(userTitle: String, userMessage:String, alertAction:String){
        let theAlert = UIAlertController(title: userTitle, message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: alertAction, style:UIAlertActionStyle.default, handler:nil)
        theAlert.addAction(okAction)
        self.present(theAlert, animated: true, completion: nil)
    }

}

