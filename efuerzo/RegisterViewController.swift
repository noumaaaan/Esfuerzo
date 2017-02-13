//
//  RegisterViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 02/02/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    // Initalise the outlets from register view
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var FullNameTextField: UITextField!
    @IBOutlet weak var UniversityTextField: UITextField!
    @IBOutlet weak var CourseTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var ConfirmPasswordTextField: UITextField!
    @IBOutlet weak var MemorableTextField: UITextField!
    
    // Function run when reguister button clicked
    @IBAction func RegisterButtonTapped(_ sender: Any) {
        
        // Store the outlets as constants as they dont change
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
            displayAlertMessage(userMessage: "All of the fields are required")
            return;
        }

        // Check that the provided passwords match
        if (password != confirmPassword){
            displayAlertMessage(userMessage: "The passwords do not match!")
            return;
        }
        
        // Check that the email is in correct format
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx);
        let emailCheck = emailTest.evaluate(with: email)
        if (!emailCheck){
            displayAlertMessage(userMessage: "The email address provided is not valid")
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
                    let resultValue:String = parseJSON["status"] as! String;
                    let UserValueStatus: String = (parseJSON["user_check"] as? String)!;
 
                    print("Result: \(resultValue)");
                    print("User check returned: \(UserValueStatus)");
                    
                    // If the username already exists, return to the appication
//                    if (UserValueStatus == "Failed"){
//                        self.displayAlertMessage(userMessage: "The provided username already exists")
//                        return;
//                    }
                    
                    // Check that email is not already registered
                    
                    if(resultValue == "Success") {
                        DispatchQueue.main.async{
                            // Display alert with the confirmation
                            let theAlert = UIAlertController(title:"Alert", message: "Registration completed successfully", preferredStyle: UIAlertControllerStyle.alert)
                            
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
    
    // This is the generic function to display an alert message
    func displayAlertMessage(userMessage:String){
        
        let theAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title:"OK", style:UIAlertActionStyle.default, handler:nil)
        theAlert.addAction(okAction)
        self.present(theAlert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ScrollView.contentSize.height = 1000;
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

