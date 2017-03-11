//
//  AddClassViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 06/03/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit

class AddClassViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.retrieveSubjects()
    }

    let userDetails: [String] = UserDefaults.standard.stringArray(forKey:"UserDetailsArray")!
    var subjectsDict: [String:AnyObject]?

    // Function to retrieve the subjects
    func retrieveSubjects(){
        
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
                    let checker:String = parseJSON["status"] as! String;
                    if(checker == "Success"){
                        let resultValue = parseJSON["subjects"] as! [String:AnyObject]
                        self.subjectsDict = resultValue
                    }
                }
            } catch let error as NSError {
                err = error
                print(err!);
            }
        }
        task.resume();
    }

    // Function to retrieve the instructors
    func retrieveTeachers(){
        
    }
    
    // Function to retrieve the locations
    func retrieveLocations(){
    
    }
    
}




