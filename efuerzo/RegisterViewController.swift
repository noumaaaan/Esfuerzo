//
//  RegisterViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 02/02/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    // Initalise storyboard outlets
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var FullNameTextField: UITextField!
    @IBOutlet weak var UniversityTextField: UITextField!
    @IBOutlet weak var CourseTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var ConfirmPasswordTextField: UITextField!
    @IBOutlet weak var MemorableTextField: UITextField!
    
    // Function run when reguister button pressed
    @IBAction func RegisterButtonTapped(_ sender: Any) {
        
        let fullName = FullNameTextField.text!
        let uniName = UniversityTextField.text!
        let uniCourse = CourseTextField.text!
        let email = EmailTextField.text!
        let username = usernameTextField.text!
        let password = PasswordTextField.text!
        let confirmPassword = ConfirmPasswordTextField.text!
        let memorable = MemorableTextField.text!

        // Check that none of the fields are empty
        if (fullName.isEmpty) || (uniName.isEmpty) || (uniCourse.isEmpty) || (username.isEmpty) || (password.isEmpty) || (confirmPassword.isEmpty) {
            displayAlertMessage(userTitle: "Error", userMessage: "All of the fields are required", alertAction: "Return")
            return;
        }

        // Check that the provided passwords match
        if (password != confirmPassword){
            displayAlertMessage(userTitle: "Password Error", userMessage: "The password combination does not match!", alertAction: "Return")
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
        
        let postString = "fullName=\(fullName)&uniName=\(uniName)&uniCourse=\(uniCourse)&username=\(username)&password=\(password)&memorable=\(memorable)&email=\(email)";
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
                    let UserValueStatus: String = (parseJSON["user_check"] as? String)!
                    let EmailValueStatus: String = (parseJSON["email_check"] as? String)!
                    
                    print(UserValueStatus)
                    
                    // If the username already exists, return to the appication
                    if (UserValueStatus == "Failed"){
                        DispatchQueue.main.async{
                            self.displayAlertMessage(userTitle: "Error", userMessage: "The chosen username already exists", alertAction: "Try again")
                            return;
                        }
                    }
                    
                    // Check that email is not already registered
                    if (EmailValueStatus == "Email error"){
                        DispatchQueue.main.async{
                            self.displayAlertMessage(userTitle: "Error", userMessage: "This email is alrady registered. Use another email", alertAction: "Try again")
                            return;
                        }
                    }
                    
                    if(resultValue == "Success") {
                        DispatchQueue.main.async{
                            // Display alert with the confirmation
                            let theAlert = UIAlertController(title:"Complete", message: "Registration completed successfully", preferredStyle: UIAlertControllerStyle.alert)
                            
                            let okAction = UIAlertAction(title:"Take me to Login", style:UIAlertActionStyle.default){
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ScrollView.contentSize.height = 1000;
        self.hideKeyboardWhenTappedAround()
        self.dismissKeyboard()
    }
}

