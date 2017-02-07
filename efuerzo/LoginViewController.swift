//
//  LoginViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 01/02/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // Initialise the outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // Function for when the login button is pressed
    @IBAction func LoginButtonTapped(_ sender: Any) {
    
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        // If the fields are empty, display an alert and return
        if (username.isEmpty || password.isEmpty) {
            // Display an alert message
            return;
        }
        
        // Provided there is no error, check the database for the given valeus
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
        
            var err: NSError?
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary

                if let parseJSON = json {
                    
                    // Parse the result string
                    let resultValue:String = parseJSON["status"] as! String;
                    let messageValue:String = parseJSON["message"] as! String;
                    print("The status is: \(resultValue)");
                    print("The message is: \(messageValue)");
                 
                    // login if success
                    if (resultValue == "Success"){
                        
                        // Set the local variable to logged in
                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn");
                        UserDefaults.standard.synchronize();
                        
                        DispatchQueue.main.async{
                            // Navigate to the tabbed part of the application
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
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
