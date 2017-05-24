//
//  LoginViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 01/02/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {
    
    
    // Initialise storyboard outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // Once the view loads, by default call dismiss keyboard to hide keyboard once the screen is tapped
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.dismissKeyboard()
        self.makeButtonRounded()
    }
    
    // Function to round the corner of the login button
    func makeButtonRounded(){
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor(red:0/255.0, green:30/255.0, blue:59/255.0, alpha: 1.0).cgColor
    }
    
    // Function once login button is pressed
    @IBAction func LoginButtonTapped(_ sender: Any) {
    
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        // If the fields are empty, display an alert and return
        if (username.isEmpty || password.isEmpty) {
            print("Error: All of the fields must be completed")
            displayAlertMessage(userTitle: "Empty", userMessage: "All of the fields must be completed", alertAction: "Return to Login")
            return;
        }
        
        // If not empty, do a post request to the server with the details
        let myUrl = NSURL(string: "https://www.noumanmehmood.com/scripts/userLogin.php");
        let request = NSMutableURLRequest(url:myUrl! as URL)
        
        request.httpMethod = "POST";
        let postString = "username=\(username)&password=\(password)";
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in

            if error != nil {
                print("error=\(String(describing: error))")
                DispatchQueue.main.async{
                    self.displayAlertMessage(userTitle: "Error", userMessage: "The internet connection appears to be offline", alertAction: "Try again")
                }
                return
            }
            
            // Parse the results of the JSON result and naivigate to app if success
            var err: NSError?
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                if let parseJSON = json {
                    
                    let resultValue:String = parseJSON["status"] as! String;
                    
                    // If there is an error, display an alert message and return
                    if (resultValue == "Error"){
                        print("Error: The fields passed were not found in the DB")
                        DispatchQueue.main.async{
                            self.displayAlertMessage(userTitle: "Error", userMessage: "The credentials entered were not found", alertAction: "Try again")
                            return
                        }
                    }
                    
                    // If the user types in the incorrect username and password combination
                    if (resultValue == "Failed"){
                        print("Error: The combination of username and password is wrong")
                        DispatchQueue.main.async{
                            self.displayAlertMessage(userTitle: "Failed", userMessage: "The user and pass combination do not match", alertAction: "Try again")
                            return
                        }
                    }
                    
                    // If the credentials are correct, however the email is not verified
                    if (resultValue == "Unverified"){
                        print("Error: The email associated with this account has not yet been verified")
                        DispatchQueue.main.async{
                            self.displayAlertMessage(userTitle: "Failed", userMessage: "The email associated with this account has not yet been verified", alertAction: "Return")
                            return
                        }
                    }

                    // If successful, initiate session and satore all the fields into an array
                    if (resultValue == "Success"){

                        let storedUserID: String = parseJSON["user_id"] as! String
                        let storedUsername: String = parseJSON["username"] as! String
                        let storedFirstname: String = parseJSON["firstname"] as! String
                        let storedSurname: String = parseJSON["surname"] as! String
                        let storedUniName: String = parseJSON["uni_name"] as! String
                        let storedUniCourse: String = parseJSON["uni_course"] as! String
                        let storedEmail: String = parseJSON["email"] as! String;
                        let storedVerificationCode: String = parseJSON["verification_code"] as! String
                        let theQuote: String = parseJSON["quote"] as! String
                        
                        let startWeek: String = parseJSON["monday"] as! String
                        let endWeek: String = parseJSON["sunday"] as! String
                        
                        let logsUpdate: String = parseJSON["logs_update"] as! String
                        
                        let array = [storedUserID, storedUsername, storedFirstname, storedSurname, storedUniName, storedUniCourse, storedEmail, storedVerificationCode, theQuote, startWeek, endWeek, logsUpdate]
                        
                        UserDefaults.standard.set(array, forKey: "UserDetailsArray");
                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn");
                        UserDefaults.standard.synchronize();
                        
                        print("User Details:")
                        print(array)
                        
                        DispatchQueue.main.async{
                            let mainTabBar = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBar") as! UITabBarController;
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate;
                            appDelegate.window?.rootViewController = mainTabBar
                        }
                    }
                }
            } catch let error as NSError {
                let dataSet = String(data: data!, encoding: .utf8)
                
                print("Trying again")
                if (dataSet?.isEmpty)!{
                    self.LoginButtonTapped(self)
                }

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



