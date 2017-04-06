//
//  LocationsViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 30/03/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit

class LocationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Initialise the storyboard outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationNameTextField: UITextField!
    
    // Variable to be used within the class
    let userDetails: [String] = UserDefaults.standard.stringArray(forKey:"UserDetailsArray")!
    var dataDict: [String:AnyObject]?
    
    // Run this function when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataDict = [String:AnyObject]()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.getLocations()
        self.hideKeyboardWhenTappedAround()
        self.dismissKeyboard()
    }
    
    // Reload the data within the table
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    // Function to add a new location to the table
    @IBAction func addLocationButtonTapped(_ sender: Any) {
    
        let name = locationNameTextField.text!
        
        // Check if the fields passed are empty, display an alert and return
        if (name.isEmpty){
            displayAlertMessage(userTitle:"Error", userMessage:"Name field cannot be empty", alertAction: "Return")
            return
        }
        
        // If not empty, add the values to the database
        let myUrl = NSURL(string: "https://www.noumanmehmood.com/scripts/addLocations.php");
        let request = NSMutableURLRequest(url:myUrl as! URL)
        
        request.httpMethod = "POST";
        let user_id = userDetails[0]
        let postString = "user_id=\(user_id)&name=\(name)";
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            // Parse the results of the JSON result
            var err: NSError?
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                if let parseJSON = json {
                    
                    let resultValue:String = parseJSON["status"] as! String;
                    
                    // If there is an error, display an alert message and return
                    if (resultValue == "Empty"){
                        DispatchQueue.main.async{
                            self.displayAlertMessage(userTitle: "Empty", userMessage: "No values were sent to the server", alertAction: "Try again")
                            return
                        }
                    }
                    
                    // If there is a database erorr with the insertion, display an alert
                    if (resultValue == "Failed"){
                        DispatchQueue.main.async{
                            self.displayAlertMessage(userTitle: "Failed", userMessage: "There was an error completing the request", alertAction: "Try again")
                            return
                        }
                    }
                    
                    // If successful, display the alert message
                    if (resultValue == "Success"){
                        DispatchQueue.main.async{
                            self.displayAlertMessage(userTitle: "Success", userMessage: "The Location was successfully added to the table", alertAction: "Return")
                            self.viewDidAppear(true)
                            self.viewDidLoad()
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
    
    // Function to retrieve instructors from the table
    func getLocations() {
        
        let myUrl = NSURL(string: "https://www.noumanmehmood.com/scripts/retrieveLocations.php");
        let request = NSMutableURLRequest(url:myUrl as! URL)
        let user_id = userDetails[0]
        request.httpMethod = "POST";
        let postString = "user_id=\(user_id)";
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            var err: NSError?
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                if let parseJSON = json {
                    let checker:String = parseJSON["status"] as! String;
                    
                    if(checker == "Success"){
                        let resultValue = parseJSON["locations"] as! [String:AnyObject]
                        self.dataDict = resultValue
                    }
                    
                    self.tableView.reloadData()
                }
            } catch let error as NSError {
                err = error
                print(err!);
            }
        }
        task.resume();
        self.tableView.reloadData()
    }
    
    /*
     *  - START OF UITABLE FUNCTIONS
     */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataDict!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cell")
        
        if let array = self.dataDict?[String(indexPath.row + 1)] as? [String] {
            cell.textLabel?.text = array[0]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            // Incase of accidental delete, provide an alert to confirm the record will be delted
            let theAlert = UIAlertController(title: "Delete record?", message: "Are you sure you would like to delete this record?", preferredStyle: UIAlertControllerStyle.alert)
            
            theAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                
                if let array = self.dataDict?[String(indexPath.row + 1)] as? [String] {
                    let name = array[0]
                    
                    let myUrl = NSURL(string: "https://www.noumanmehmood.com/scripts/removeLocations");
                    let request = NSMutableURLRequest(url:myUrl as! URL)
                    let user_id = self.userDetails[0]
                    request.httpMethod = "POST";
                    let postString = "name=\(name)&user_id=\(user_id)";
                    request.httpBody = postString.data(using: String.Encoding.utf8);
                    
                    let task = URLSession.shared.dataTask(with: request as URLRequest) {
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
                                
                                // If there is an error, display an alert message and return
                                if (resultValue == "Empty"){
                                    DispatchQueue.main.async{
                                        self.displayAlertMessage(userTitle: "Empty", userMessage: "No values were sent to the server", alertAction: "Try again")
                                        return
                                    }
                                }
                                
                                // If there is an error, display an alert message and return
                                if (resultValue == "Error"){
                                    DispatchQueue.main.async{
                                        self.displayAlertMessage(userTitle: "Error", userMessage: "There was an error deleting the location from the database", alertAction: "Try again")
                                        return
                                    }
                                }
                                
                                // If there is an error, display an alert message and return
                                if (resultValue == "Success"){
                                    DispatchQueue.main.async{
                                        self.displayAlertMessage(userTitle: "Success", userMessage: "Successfully removed the location from the table", alertAction: "Return")
                                        self.viewDidAppear(true)
                                        self.viewDidLoad()
                                    }
                                }
                                
                                self.tableView.reloadData()
                            }
                        } catch let error as NSError {
                            err = error
                            print(err!);
                        }
                    }
                    task.resume();
                    self.tableView.reloadData()
                }
                
            }))
            
            theAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                return
            }))
            
            present(theAlert, animated: true, completion: nil)
            
        }
    }
    
    /*
     *  - END OF UITABLE FUNCTIONS
     */
    
    // Function to display an alert message parameters for the title, message and action type
    func displayAlertMessage(userTitle: String, userMessage:String, alertAction:String){
        let theAlert = UIAlertController(title: userTitle, message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: alertAction, style:UIAlertActionStyle.default, handler:nil)
        theAlert.addAction(okAction)
        self.present(theAlert, animated: true, completion: nil)
    }
}
