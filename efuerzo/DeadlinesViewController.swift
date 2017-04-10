//
//  DeadlinesViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 06/02/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit

class DeadlinesViewController: UIViewController {
    
    // Initialise varibales used in the class
    let userDetails: [String] = UserDefaults.standard.stringArray(forKey:"UserDetailsArray")!
    var dataDict: [String:AnyObject]?
    
    // Initialisation of the storyboard outlets
    @IBOutlet weak var completeView: UIView!
    @IBOutlet weak var IncompleteView: UIView!
    
    // Run this function when te view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataDict = [String:AnyObject]()
        self.retriveAllDeadlines()
        self.hideKeyboardWhenTappedAround()
        self.dismissKeyboard()
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
    }
    
    
    // Run this functiuon when the view appeasrs
    override func viewDidAppear(_ animated: Bool) {
//        tableView.reloadData()
    }
    
    // Function to switch the segmented control view
    @IBAction func SwitchDeadlines(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0, animations: {
                self.completeView.alpha = 0
                self.IncompleteView.alpha = 1
            })
        } else {
            UIView.animate(withDuration: 0, animations: {
                self.completeView.alpha = 1
                self.IncompleteView.alpha = 0
            })
        }
    }
    
    // Function to retirve all the deadlines that the user has
    func retriveAllDeadlines(){
        let myUrl = NSURL(string: "https://www.noumanmehmood.com/scripts/retrieveDeadlines.php");
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
                        self.dataDict = resultValue
                    }
                    
//                    self.tableView.reloadData()
                }
            } catch let error as NSError {
                err = error
                print(err!);
            }
        }
        task.resume();
//        self.tableView.reloadData()
    }
    
    

}
