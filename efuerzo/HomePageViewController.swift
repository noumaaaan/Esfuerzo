//
//  HomePageViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 07/02/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    // Initialise storyboard outlets
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var quoteLabel: UILabel!
    
    // Initialise variables being used
    let userDetails: [String] = UserDefaults.standard.stringArray(forKey:"UserDetailsArray")!
    var dataDict: [String:AnyObject]?
    var quoteVar: String = ""
    
    // Run this function when the view loads
    override func viewDidLoad() {
        self.retrieveMotivationalQuote()

        super.viewDidLoad()
        
        self.dataDict = [String:AnyObject]()
        self.DisplayTheDate()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.getEvents()
        self.hideKeyboardWhenTappedAround()
        self.dismissKeyboard()
    }
    
    // Function to display the date at start
    func DisplayTheDate(){
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_GB") as Locale!
        dateFormatter.dateStyle = DateFormatter.Style.full
        let convertedDate = dateFormatter.string(from: currentDate as Date)
        DateLabel.text = convertedDate;
    }
    
    // Get a quote from the database
    func retrieveMotivationalQuote(){
        
        let myUrl = NSURL(string: "https://www.noumanmehmood.com/scripts/retrieveQuoteOfTheDay.php");
        let request = NSMutableURLRequest(url:myUrl as! URL)
        
        request.httpMethod = "POSTs";
        let postString = "";
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            // Parse the results of the JSON result and naivigate to app if success
            var err: NSError?
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                if let parseJSON = json {
                    
                    let resultValue:String = parseJSON["status"] as! String;
                    print(resultValue)
                    
                    // If successful, initiate session and satore all the fields into an array
                    if (resultValue == "Success"){
                        let quoteValue: String = parseJSON["result"] as! String;
                        self.quoteVar = quoteValue
                        
                        DispatchQueue.main.async{
                            self.quoteLabel.text = self.quoteVar
                        }
                        return
                    }
                }
            } catch let error as NSError {
                err = error
                print(err!);
            }
        }
        task.resume();
    }
    
    // Get the events from the database for the selected date
    func getEvents() {
        
        // Get the current date top post
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let convertedDate = dateFormatter.string(from: currentDate as Date)
        
        let myUrl = NSURL(string: "https://www.noumanmehmood.com/scripts/retrieveEventsForDay.php");
        let request = NSMutableURLRequest(url:myUrl as! URL)
        let user_id = userDetails[0]
        request.httpMethod = "POST";
        let postString = "user_id=\(user_id)&requested_time=\(convertedDate)";
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
                        let resultValue = parseJSON["results"] as! [String:AnyObject]
                        print(resultValue)
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
     *  - START UITABLE FUNCTIONS
     */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (dataDict!.isEmpty){
            return 1
        } else {
            return self.dataDict!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        
        if (dataDict!.isEmpty){
            cell.textLabel?.text = "You have no events scheduled for today"
            cell.progressBar.isHidden = true
        } else{
            if let array = self.dataDict?[String(indexPath.row + 1)] as? [String] {
                cell.subjectNameLabel?.text = array[1]
                cell.classTypeLabel?.text = "Type: " + array[2]
                cell.instructorNameLabel?.text = "Instructor: " + array[3]
                cell.locationNameLabel?.text = "Location: " + array[4]
                cell.startTimeLabel?.text = "Start: " + array[5]
                cell.endTimeLabel?.text = "End: " + array[6]
                cell.classLengthLabel?.text = array[7] + " Hrs"
                cell.timeRemaining?.text = array[8]
            }
        }
        
        return cell
    }
    
    /*
     *  - END UITABLE FUNCTIONS
     */
    
    // Function to display an alert message parameters for the title, message and action type
    func displayAlertMessage(userTitle: String, userMessage:String, alertAction:String){
        let theAlert = UIAlertController(title: userTitle, message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: alertAction, style:UIAlertActionStyle.default, handler:nil)
        theAlert.addAction(okAction)
        self.present(theAlert, animated: true, completion: nil)
    }
    
    /*
     * Motivational quotes have been taken from this website
     * http://www.timothysykes.com/blog/the-best-motivational-quotes-part-2/
     */
  
}
