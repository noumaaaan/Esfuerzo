//
//  PasswordChangeViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 21/02/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit

class PasswordChangeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Initialise the components on storyboard
    
    @IBOutlet weak var OldPasswordTextField: UITextField!
    @IBOutlet weak var NewPasswordTextField: UITextField!
    @IBOutlet weak var RepeatPasswordTextField: UITextField!
    
    // Attain username from the session information
    let UserDetails = UserDefaults.standard.stringArray(forKey: "UserDetailsArray") ?? [String]()
    
    // Function to change the password
    @IBAction func UpdateButtonTapped(_ sender: Any) {
        
        let OldPass = OldPasswordTextField.text!
        let NewPass = NewPasswordTextField.text!
        let Repeat = RepeatPasswordTextField.text!
        
        // Check that all of the fields have been completed
        if (NewPass.isEmpty || Repeat.isEmpty || OldPass.isEmpty) {
            displayAlertMessage(userTitle: "Error", userMessage: "All of the fields are required", alertAction: "Return")
            return;
        }
        
        // Check that the old and new password are not the same
        if (NewPass == OldPass){
            displayAlertMessage(userTitle: "Passwords identical!", userMessage: "The old and new password are the same!", alertAction: "Return")
            return
        }
        
        // Check that the password combination is the same
        if (Repeat != NewPass){
            displayAlertMessage(userTitle: "Password Error", userMessage: "The password combination does not match!", alertAction: "Return")
            return
        }
        
        // Check that the password length is at least 6 characters
        if (NewPass.characters.count < 6){
            displayAlertMessage(userTitle: "Password too short!", userMessage: "Your password needs to be at least 6 characters long!", alertAction: "Try again")
            return;
        }
        
        // If everything is okay, send details to the server
        let myUrl = NSURL(string: "https://www.noumanmehmood.com/scripts/passwordChange.php");
        let request = NSMutableURLRequest(url:myUrl as! URL)
        request.httpMethod = "POST";
        
        // Attain the username from the session information
        let username = self.UserDetails[0]
        
        let postString = "newPass=\(NewPass)&OldPass=\(OldPass)&username=\(username)";
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
                    
                    // If the original password is incorrect, throw an error
                    if (resultValue == "Error"){
                        DispatchQueue.main.async{
                            self.displayAlertMessage(userTitle: "Error", userMessage: "The password typed is not associated with this account", alertAction: "Try again")
                            return;
                        }
                    }

                    // If change is successful, throw alert and send email (in PHP)
                    if(resultValue == "success") {
                        
                        let mailValue:String = parseJSON["mail"] as! String
                        print(mailValue)
                        
                        DispatchQueue.main.async{
                            // Display alert with the confirmation
                            let theAlert = UIAlertController(title:"Complete", message: "Password change Successful", preferredStyle: UIAlertControllerStyle.alert)
                            
                            let okAction = UIAlertAction(title:"Done", style:UIAlertActionStyle.default){
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
