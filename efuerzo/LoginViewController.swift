//
//  LoginViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 01/02/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // Storyboard outlet declaration
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // Function once login button is pressed
    @IBAction func LoginButtonTapped(_ sender: Any) {
    
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        /*
         * Input validations for the username and password text fields
         * Check if the fields are empty and compare with current array to see if username is taken
         */
        
        // If the fields are empty, display an alert and return
        if (username.isEmpty || password.isEmpty) {
            displayAlertMessage(alertAction: "Return", userMessage: "Complete all the fields")
            return;
        }
        
        /*
         * Begin a POST request to the PHP Script
         * Begin a task to send the request
         */
        let myUrl = NSURL(string: "https://www.noumanmehmood.com/scripts/userLogin.php");
        let request = NSMutableURLRequest(url:myUrl as! URL)
        
        // POST request
        activityIndicator.startAnimating();
        request.httpMethod = "POST";
        let postString = "username=\(username)&password=\(password)";
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        // Start a task to send the request
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in

            if error != nil {
                print("error=\(error)")
                return
            }
            
            /*
             * Parse the results of the JSON request 
             * If the result fails, display error message and return
             * If successful, navigate to main
             */
            
        
            var err: NSError?
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                if let parseJSON = json {
                
                    let resultValue:String = parseJSON["status"] as! String;
//                    if (resultValue == "Error"){
//                        self.displayAlertMessage(alertAction: "Try again", userMessage: "Credentials not found")
//                        return
//                    }
                    
                    /*
                     * If the result is successful, save all of the fields into an array
                     * Save this array using User Defaults to user storage
                     * Navigate to the main tab of application
                     */
                    
                    if (resultValue == "Success"){
                        
                        let storedUsername: String = parseJSON["username"] as! String;
                        let storedFullName: String = parseJSON["full_name"] as! String;
                        let storedUniName: String = parseJSON["uni_name"] as! String;
                        let storedUniCourse: String = parseJSON["uni_course"] as! String;
                        let array = [storedUsername, storedFullName, storedUniName, storedUniCourse];
                        
                        UserDefaults.standard.set(array, forKey: "UserDetailsArray");
                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn");
                        UserDefaults.standard.synchronize();
                        
                        self.activityIndicator.stopAnimating()
                        
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

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func displayAlertMessage(alertAction:String, userMessage:String){
        let theAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: alertAction, style:UIAlertActionStyle.default, handler:nil)
        theAlert.addAction(okAction)
        self.present(theAlert, animated: true, completion: nil)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
