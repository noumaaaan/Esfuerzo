//
//  ForgotPassViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 02/02/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

// http://stackoverflow.com/questions/28963514/sending-email-with-swift

class ForgotPassViewController: UIViewController {

    // Initialise the variables
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var memorableTextField: UITextField!
    
    // Function to reset the password
    @IBAction func resetButtonTapped(_ sender: Any) {
        
        let email = emailTextField.text!
        let memorable = memorableTextField.text!
        
        // Display alert message if empty
        if (email.isEmpty) || (memorable.isEmpty){
            return;
        }
        
        // If everything is okay, send details to the server
        let myUrl = NSURL(string: "https://www.noumanmehmood.com/scripts/userForgot.php");
        let request = NSMutableURLRequest(url:myUrl as! URL)
        request.httpMethod = "POST";
        
        let postString = "email=\(email)&memorable=\(memorable)";
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
                    
                    if (resultValue == "success"){
                        DispatchQueue.main.async{
                            // Display alert with the confirmation
                            let theAlert = UIAlertController(title:"Reset Successful", message: "An email has been sent to \(email) with details about your account.", preferredStyle: UIAlertControllerStyle.alert)
                            
                            let okAction = UIAlertAction(title:"Dismiss", style:UIAlertActionStyle.default){
                                action in
                                self.dismiss(animated: true, completion: nil)
                            }
                            
                            theAlert.addAction(okAction);
                            self.present(theAlert, animated: true, completion: nil)
                        }
                    
                    // Incase the email reset was not successful
                    } else {
                        let theAlert = UIAlertController(title:"Failed", message: "The Email and memorable word combination was incorrect.", preferredStyle: UIAlertControllerStyle.alert)
                        
                        let okAction = UIAlertAction(title:"Try Again", style:UIAlertActionStyle.default){
                            action in
                            return
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
        task.resume();    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ForgotPassViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

}
