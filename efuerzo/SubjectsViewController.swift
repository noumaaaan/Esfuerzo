//
//  SubjectsViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 19/02/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit

class SubjectsViewController: UIViewController{

    // Initialise components of the view
    let UserDetails = UserDefaults.standard.stringArray(forKey: "UserDetailsArray") ?? [String]()
    @IBOutlet weak var SubjectNameTextField: UITextField!
    @IBOutlet weak var SubjectTypeTextField: UITextField!
    
    // Function that is called when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSubjects(callback: {(resultValue)-> Void in
            print(resultValue)
        })
    }
    
    // Function when subjects are added
    @IBAction func AddSubjectTapped(_ sender: Any) {
    }
    
    // Function to retieve the subjects for the user
    func getSubjects(callback: @escaping (NSDictionary)-> Void){
        
        let myUrl = NSURL(string: "https://www.noumanmehmood.com/scripts/retrieveSubjects.php");
        let request = NSMutableURLRequest(url:myUrl as! URL)
        let user_id = UserDetails[0]
        request.httpMethod = "POST";
        let postString = "user_id=\(user_id)";
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
                    let resultValue: NSDictionary = parseJSON["subjects"] as! NSDictionary
                    callback(resultValue)
                }
            } catch let error as NSError {
                err = error
                print(err!);
            }
        }
        task.resume();
    }
    
    
    
    
    
    
}







