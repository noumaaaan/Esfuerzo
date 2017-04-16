//
//  IncompleteDeadlinesViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 08/02/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit

class IncompleteDeadlinesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Outlets on the storyboard
    @IBOutlet weak var tableView: UITableView!
    
    // Initialise the variables used
    let userDetails: [String] = UserDefaults.standard.stringArray(forKey:"UserDetailsArray")!
    var CompletedDeadlines: [String:AnyObject]?
    
    // Function when the view laods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CompletedDeadlines = [String:AnyObject]()
        self.retrieveCompletedDeadlines()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.hideKeyboardWhenTappedAround()
        self.dismissKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // Retrieve the completed deadlines for the user
    func retrieveCompletedDeadlines(){
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
    
    /*
     *  - START UITABLE FUNCTIONS
     */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.CompletedDeadlines!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DeadlinesTableViewCell
        if let array = self.CompletedDeadlines?[String(indexPath.row + 1)] as? [String] {
            cell.subjectNameLabel.text = array[0]
            cell.titleNameLabel.text = array[1]
            cell.descriptionNameLabel.text = array[2]
            cell.timeDueLabel.text = "Due " + array[4]
            cell.dueDateLabel.text = array[5]
            cell.timeRemainingLabel.text = "Time remaining: " + array[6]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "editDeadline", sender: self)
    }
            
    /*
     *  - END UITABLE FUNCTIONS
     */

}





