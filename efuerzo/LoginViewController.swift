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
    
    // Function once login button is pressed
    @IBAction func LoginButtonTapped(_ sender: Any) {
    
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        // If the fields are empty, display an alert and return
        if (username.isEmpty || password.isEmpty) {
            displayAlertMessage(alertAction: "Return", userMessage: "Complete all the fields")
            return;
        }
        
        // If not empty, do a post request to the server with the details
        let myUrl = NSURL(string: "https://www.noumanmehmood.com/scripts/userLogin.php");
        let request = NSMutableURLRequest(url:myUrl as! URL)
        
        request.httpMethod = "POST";
        let postString = "username=\(username)&password=\(password)";
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in

            if error != nil {
                print("error=\(error)")
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
                        let theAlert = UIAlertController(title:"Alert", message: "Credentials not found", preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title:"Try again", style:UIAlertActionStyle.default)
                        theAlert.addAction(okAction);
                        self.present(theAlert, animated: true, completion: nil)
                        return
                    }
                
                    // If successful, initiate session and satore all the fields into an array
                    if (resultValue == "Success"){
                        
                        let storedUsername: String = parseJSON["username"] as! String;
                        let storedFullName: String = parseJSON["full_name"] as! String;
                        let storedUniName: String = parseJSON["uni_name"] as! String;
                        let storedUniCourse: String = parseJSON["uni_course"] as! String;
                        let storedEmail: String = parseJSON["email"] as! String;
                        
                        let array = [storedUsername, storedFullName, storedUniName, storedUniCourse, storedEmail];
                        
                        UserDefaults.standard.set(array, forKey: "UserDetailsArray");
                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn");
                        UserDefaults.standard.synchronize();
                        
                        DispatchQueue.main.async{
                            let mainTabBar = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBar") as! UITabBarController;
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate;
                            appDelegate.window?.rootViewController = mainTabBar
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

    // Once the view loads, by default call dismiss keyboard to hide keyboard once the screen is tapped
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // Generic function to display an alert message
    // Takes parameters for the action to the alert and the message of the alert
    func displayAlertMessage(alertAction:String, userMessage:String){
        let theAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: alertAction, style:UIAlertActionStyle.default, handler:nil)
        theAlert.addAction(okAction)
        self.present(theAlert, animated: true, completion: nil)
    }
    
    // End keyboard editing
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
