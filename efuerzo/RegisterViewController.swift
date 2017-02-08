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

        // Check that none of the field are empty
        if (fullName.isEmpty) || (uniName.isEmpty) || (uniCourse.isEmpty) || (username.isEmpty) || (password.isEmpty) || (confirmPassword.isEmpty) {
    
            // Generate an alert meessage prompting user that all of the fields are required
            displayAlertMessage(userMessage: "All of the fields are required")
            return;
        }

        if (password != confirmPassword){
            
            // Generate an alert if the two passwords do not match
            displayAlertMessage(userMessage: "The passwords do not match")
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
                    
                    print("result: \(resultValue)");
                    
                    var isUserRegistered:Bool = false;
                    if(resultValue == "Success") {
                        isUserRegistered = true;
                    }
                    
                    var messageToDisplay:String = parseJSON["message"] as! String!
                    if(!isUserRegistered){
                        messageToDisplay = parseJSON["message"] as! String!
                    }
                    print(messageToDisplay)
                    
                    DispatchQueue.main.async{
                        // Display alert with the confirmation
                        let theAlert = UIAlertController(title:"Alert", message: "Registration completed successfully", preferredStyle: UIAlertControllerStyle.alert)
                        
                        let okAction = UIAlertAction(title:"OK", style:UIAlertActionStyle.default){
                            action in
                            self.dismiss(animated: true, completion: nil)
                        }
                        
                        theAlert.addAction(okAction);
                        self.present(theAlert, animated: true, completion: nil)
                    }
                }
                
            } catch let error as NSError {
                err = error
                print(err!);
            }
        }
        task.resume();
        
        // Once registration is successful, send the user to the login screen
        let theAlert = UIAlertController(title:"Alert", message: "Registration completed successfully", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title:"OK", style:UIAlertActionStyle.default){
            action in
            self.dismiss(animated: true, completion: nil)
        }
        
        theAlert.addAction(okAction);
        self.present(theAlert, animated: true, completion: nil)
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

