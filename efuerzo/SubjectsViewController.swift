//
//  SubjectsViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 19/02/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit

class SubjectsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dataDict: [String:AnyObject]?
    @IBOutlet var tableView: UITableView!
    let userDetails: [String] = UserDefaults.standard.stringArray(forKey:"UserDetailsArray")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataDict = [String:AnyObject]()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.getSubjects()
    }
    
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
            cell.detailTextLabel?.text = array[1]
        }
        return cell
    }
    
    func getSubjects() {
        
        let myUrl = NSURL(string: "https://www.noumanmehmood.com/scripts/retrieveSubjects.php");
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
                    let resultValue = parseJSON["subjects"] as! [String:AnyObject]
                    self.dataDict = resultValue
                    
                    print(self.dataDict)
                    self.tableView.reloadData()
                }
            } catch let error as NSError {
                err = error
                print(err!);
            }
        }
        task.resume();
    }
}
