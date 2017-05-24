//
//  PreferencesViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 12/02/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//
// http://stackoverflow.com/questions/27960556/loading-an-overlay-when-running-long-tasks-in-ios
// For the alert

import UIKit

class DeadlinesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Initialising the outlets in the view
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var deadlinesLabel: UILabel!
    
    // Instantiate variables used within the class
    let UserDetails = UserDefaults.standard.stringArray(forKey: "UserDetailsArray") ?? [String]()
    var CompletedDeadlines: [String:AnyObject]!
    var IncompleteDeadlines: [String:AnyObject]!
    var arr = [String]()

    // On view load, do these functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.CompletedDeadlines = [String:AnyObject]()
        self.IncompleteDeadlines = [String:AnyObject]()
        
        loadingAlert()
        
        self.retrieveCompletedDeadlines()
        self.retrieveIncompletedDeadlines()
        
        dismiss(animated: false, completion: nil)
    }

    // Run this function when the view appears
    override func viewDidAppear(_ animated: Bool) {
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            deadlinesLabel.text = "Incomplete Deadlines"
            self.tableView.reloadData()
        case 1:
            deadlinesLabel.text = "Completed Deadlines"
            self.tableView.reloadData()
        default:
            break
        }
    }
    
    // Function to switch between the segmented control
    @IBAction func switchDeadlinesTableView(_ sender: Any) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            deadlinesLabel.text = "Incomplete Deadlines"
            self.tableView.reloadData()
        case 1:
            deadlinesLabel.text = "Completed Deadlines"
            self.tableView.reloadData()
        default:
            break
        }
    }
    
    // Present a loading alert at start
    func loadingAlert(){
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    /*
     *  - START UITABLE FUNCTIONS
     */
    
    // Return number of sections in the table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Set the height of the table rows
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    
    // The number of rows that will be in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var row_Count = 0
        
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            row_Count = IncompleteDeadlines!.count
        case 1:
            row_Count = CompletedDeadlines!.count
        default:
            break
        }
        
        return row_Count
    }
    
    // Navigate to the view controllers dependant upon what table in cell has been selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            if let array = self.IncompleteDeadlines?[String(indexPath.row + 1)] as? [String] {
                arr =  array
            }
            
        case 1:
            if let array = self.CompletedDeadlines?[String(indexPath.row + 1)] as? [String] {
                arr = array
            }
            
        default:
            break
        }
        self.performSegue(withIdentifier: "editDeadline", sender: self)
        
    }
    
    // Populate the table with data from the arrays
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DeadlinesTableViewCell
        
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            if let array = self.IncompleteDeadlines?[String(indexPath.row + 1)] as? [String] {
                cell.subjectNameLabel.text = array[0]
                cell.titleNameLabel.text = array[1]
                cell.descriptionNameLabel.text = array[2]
                cell.timeDueLabel.text = array[4]
                cell.dueDateLabel.text = array[5]
                
                if (array[7] == "yes") {
                    cell.timeRemainingLabel.textColor = UIColor.red
                } else {
                    cell.timeRemainingLabel.textColor = UIColor.green
                }
                if (array[6] == "Deadline missed"){
                    cell.timeRemainingLabel.text = "This deadline has now gone"
                    cell.timeDueLabel.textColor = UIColor.red
                    cell.dueDateLabel.textColor = UIColor.red
                    
                } else {
                    cell.timeRemainingLabel.text = "Time remaining " + array[6]
                }
                
            }
        case 1:
            if let array = self.CompletedDeadlines?[String(indexPath.row + 1)] as? [String] {
                
                cell.subjectNameLabel.text = array[0]
                cell.titleNameLabel.text = array[1]
                cell.descriptionNameLabel.text = array[2]
                cell.timeDueLabel.text = array[4]
                cell.dueDateLabel.text = array[5]
                cell.timeRemainingLabel.text = "Marked as Complete"
                cell.timeRemainingLabel.textColor = UIColor.red
            }
        default:
            break
        }
        return cell
    }
    
    // Prepare for segue by sending the array only if the segue is connecting to the edit deadline controller 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editDeadline" {
            let DVC = segue.destination as! editDeadlinesViewController
            DVC.arr = arr
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            // Incase of accidental delete, provide an alert to confirm the record will be delted
            let theAlert = UIAlertController(title: "Delete record?", message: "Are you sure you would like to delete this deadline?", preferredStyle: UIAlertControllerStyle.alert)
            
            theAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in

                switch (self.segmentedControl.selectedSegmentIndex) {
                case 0:
                    if let array = self.IncompleteDeadlines?[String(indexPath.row + 1)] as? [String] {
                        let subjectAndType = array[0]
                        let title = array[1]
                        let dueTime = array[4]
                        let dueDate = array[5]
                        
                        let myUrl = NSURL(string: "https://www.noumanmehmood.com/scripts/removeDeadline.php");
                        let request = NSMutableURLRequest(url:myUrl! as URL)
                        let user_id = self.UserDetails[0]
                        request.httpMethod = "POST";
                        let postString = "subjectAndType=\(subjectAndType)&title=\(title)&dueTime=\(dueTime)&dueDate=\(dueDate)&user_id=\(user_id)";
                        request.httpBody = postString.data(using: String.Encoding.utf8);
                        
                        let task = URLSession.shared.dataTask(with: request as URLRequest) {
                            data, response, error in
                            
                            if error != nil {
                                print("error=\(String(describing: error))")
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
                                            self.displayAlertMessage(userTitle: "Error", userMessage: "There was an error deleting the record from the database", alertAction: "Try again")
                                            return
                                        }
                                    }
                                    
                                    // If there is an error, display an alert message and return
                                    if (resultValue == "Success"){
                                        DispatchQueue.main.async{
                                            self.displayAlertMessage(userTitle: "Success", userMessage: "Successfully removed the deadline from the table", alertAction: "Return")
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

                case 1:
                    if let array = self.CompletedDeadlines?[String(indexPath.row + 1)] as? [String] {
                        let subjectAndType = array[0]
                        let title = array[1]
                        let dueTime = array[4]
                        let dueDate = array[5]
                        
                        let myUrl = NSURL(string: "https://www.noumanmehmood.com/scripts/removeDeadline.php");
                        let request = NSMutableURLRequest(url:myUrl! as URL)
                        let user_id = self.UserDetails[0]
                        request.httpMethod = "POST";
                        let postString = "subjectAndType=\(subjectAndType)&title=\(title)&dueTime=\(dueTime)&dueDate=\(dueDate)&user_id=\(user_id)";
                        request.httpBody = postString.data(using: String.Encoding.utf8);
                        
                        let task = URLSession.shared.dataTask(with: request as URLRequest) {
                            data, response, error in
                            
                            if error != nil {
                                print("error=\(String(describing: error))")
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
                                            self.displayAlertMessage(userTitle: "Error", userMessage: "There was an error deleting the record from the database", alertAction: "Try again")
                                            return
                                        }
                                    }
                                    
                                    // If there is an error, display an alert message and return
                                    if (resultValue == "Success"){
                                        DispatchQueue.main.async{
                                            self.displayAlertMessage(userTitle: "Success", userMessage: "Successfully removed the deadline from the table", alertAction: "Return")
                                            return
                                        }
                                    }
                                    
                                    self.viewDidAppear(true)
                                    self.viewDidLoad()
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
                    
                default:
                    break
                }

            }))
            
            theAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                return
            }))
            
            present(theAlert, animated: true, completion: nil)
            
        }
    }

    
    /*
     *  - END UITABLE FUNCTIONS
     */
    
    // Function to return the completed deadlines of the user
    func retrieveCompletedDeadlines(){
        let myUrl = NSURL(string: "https://www.noumanmehmood.com/scripts/retrieveCompletedDeadlines.php");
        let request = NSMutableURLRequest(url:myUrl! as URL)
        let user_id = UserDetails[0]
        request.httpMethod = "POST";
        let postString = "user_id=\(user_id)";
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            
            var err: NSError?
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                if let parseJSON = json {
                    let checker:String = parseJSON["status"] as! String;
                    
                    if(checker == "Success"){
                        let resultValue = parseJSON["deadlines"] as! [String:AnyObject]
                        self.CompletedDeadlines = resultValue
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } catch let error as NSError {
                err = error
                print(err!);
            }
        }
        task.resume();
        self.tableView.reloadData()
    }
    
    // Function to return the incompleted deadlines for the user
    func retrieveIncompletedDeadlines(){
        let myUrl = NSURL(string: "https://www.noumanmehmood.com/scripts/retrieveIncompleteDeadlines.php");
        let request = NSMutableURLRequest(url:myUrl! as URL)
        let user_id = UserDetails[0]
        request.httpMethod = "POST";
        let postString = "user_id=\(user_id)";
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            
            var err: NSError?
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                if let parseJSON = json {
                    let checker:String = parseJSON["status"] as! String;
                    
                    if(checker == "Success"){
                        let resultValue = parseJSON["deadlines"] as! [String:AnyObject]
                        self.IncompleteDeadlines = resultValue
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } catch let error as NSError {
                err = error
                print(err!);
            }
        }
        task.resume();
        self.tableView.reloadData()
    }
    
    // Function to display an alert message parameters for the title, message and action type
    func displayAlertMessage(userTitle: String, userMessage:String, alertAction:String){
        let theAlert = UIAlertController(title: userTitle, message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: alertAction, style:UIAlertActionStyle.default, handler:nil)
        theAlert.addAction(okAction)
        self.present(theAlert, animated: true, completion: nil)
    }

    
 
}
