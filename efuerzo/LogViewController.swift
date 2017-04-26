//
//  LogViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 24/04/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit

class LogViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // Initialise the storyboard outlets
    @IBOutlet weak var weekCommencingLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // Instantiate variables to be used within this class
    let UserDetails = UserDefaults.standard.stringArray(forKey: "UserDetailsArray") ?? [String]()
    var subjectsLogDict: [String:AnyObject]?
    
    // Run this function everytime that the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weekCommencingLabel.text = "Week " + UserDetails[9] + " - " + UserDetails[10] // Set the date label
        self.subjectsLogDict = [String:AnyObject]()
        
        loadingAlert()
        self.retrieveSubjectsLog()
        dismiss(animated: false, completion: nil)
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.hideKeyboardWhenTappedAround()
        self.dismissKeyboard()
    }
    
    // Run this function when the view loads
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
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
        return 180
    }
    
    
    // The number of rows that will be in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.subjectsLogDict!.count
    }
    
    // Navigate to the view controllers dependant upon what table in cell has been selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "editLog", sender: self)
    }
    
    // Populate the table with data from the arrays
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LogTableViewCell
        
        if let array = self.subjectsLogDict?[String(indexPath.row + 1)] as? [String] {
            print(array)
            cell.subjectNameLabel.text = array[1]
        }
        return cell
    }
    
    /*
     *  - END UITABLE FUNCTIONS
     */
    
    // Retrieve the subjects which will populate the table
    func retrieveSubjectsLog(){
        let myUrl = NSURL(string: "https://www.noumanmehmood.com/scripts/retrieveSubjectLog.php");
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
                    
                    print(checker)
                    
                    if(checker == "Success"){
                        let resultValue = parseJSON["subjects_log"] as! [String:AnyObject]
                        self.subjectsLogDict = resultValue
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
}
