//
//  DeadlinesViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 06/02/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit

class DeadlinesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    // Initialise the storyboard outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deadlinesLabel: UILabel!
    
    // Instantiate variables
    let userDetails: [String] = UserDefaults.standard.stringArray(forKey:"UserDetailsArray")!
    var CompletedDeadlines: [String:AnyObject]?
    var IncompleteDeadlines: [String:AnyObject]?
    var arr = [String]()
    
    // Run this function when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.dismissKeyboard()

        self.CompletedDeadlines = [String:AnyObject]()
        self.IncompleteDeadlines = [String:AnyObject]()
        
        self.retrieveCompletedDeadlines()
        self.retrieveIncompletedDeadlines()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    // Run this function when the view appears
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
        self.deadlinesLabel.text = "Incompleted Deadlines"
    }
    
    // On the segmented deadlines action, reload the table and change the label
    @IBAction func switchDeadlinesTableView(_ sender: Any) {
        self.tableView.reloadData()
        
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            deadlinesLabel.text = "Incomplete Deadlines"
        case 1:
            deadlinesLabel.text = "Completed Deadlines"
        default:
            break
        }
        
    }
    
    
    /*
     *  - START UITABLE FUNCTIONS
     */
    
    // NUmber of sections in the table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // The number of rows that will be in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var returnValue = 0
        
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            returnValue = IncompleteDeadlines!.count
        case 1:
            returnValue = CompletedDeadlines!.count
        default:
            break
        }
        
        return returnValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DeadlinesTableViewCell
        
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            if let array = self.IncompleteDeadlines?[String(indexPath.row + 1)] as? [String] {
                cell.subjectNameLabel.text = array[0]
                cell.titleNameLabel.text = array[1]
                cell.descriptionNameLabel.text = array[2]
                cell.timeDueLabel.text = "Due " + array[4]
                cell.dueDateLabel.text = array[5]
                cell.timeRemainingLabel.text = "Time remaining: " + array[6]
            }
        case 1:
            if let array = self.CompletedDeadlines?[String(indexPath.row + 1)] as? [String] {
                cell.subjectNameLabel.text = array[0]
                cell.titleNameLabel.text = array[1]
                cell.descriptionNameLabel.text = array[2]
                cell.timeDueLabel.text = "Due " + array[4]
                cell.dueDateLabel.text = array[5]
                cell.timeRemainingLabel.text = "Time remaining: " + array[6]
            }
        default:
            break
        }
        return cell
    }
    
    // Set the height of the table rows
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 228
    }
    
    // Navigate to the view controllers dependant upon what table in cell has been selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            // Convert the dictionary to array
            for (value) in IncompleteDeadlines! {
                arr.append("\(value)")
            }
            
        case 1:
            // Convert the dictionary to array
            for (value) in CompletedDeadlines! {
                arr.append("\(value)")
            }
            
        default:
            break
        }
        self.performSegue(withIdentifier: "editDeadline", sender: self)

    }

    // Prepare for segue by sending the array
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let DVC = segue.destination as! editDeadlinesViewController
        DVC.arr = arr
    }
    
    /*
     *  - END UITABLE FUNCTIONS
     */
    
    // Function to return the completed deadlines of the user
    func retrieveCompletedDeadlines(){
        let myUrl = NSURL(string: "https://www.noumanmehmood.com/scripts/retrieveCompletedDeadlines.php");
        let request = NSMutableURLRequest(url:myUrl! as URL)
        let user_id = userDetails[0]
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
                        print(resultValue)
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
    
    // Function to return the incompleted deadlines for the user
    func retrieveIncompletedDeadlines(){
        let myUrl = NSURL(string: "https://www.noumanmehmood.com/scripts/retrieveIncompleteDeadlines.php");
        let request = NSMutableURLRequest(url:myUrl! as URL)
        let user_id = userDetails[0]
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
                        print(resultValue)
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
}
 
