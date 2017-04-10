//
//  CurrentEventsViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 13/03/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit

class CurrentEventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // Outlets on the storyboard
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkLabel: UILabel!
    
    // Initialise the variables used
    let userDetails: [String] = UserDefaults.standard.stringArray(forKey:"UserDetailsArray")!
    var passingValue: String!
    var dataDict: [String:AnyObject]?
    
    // Function when the view laods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataDict = [String:AnyObject]()
        self.getEvents()
        DisplayTheDate(StringDateValue: passingValue)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.hideKeyboardWhenTappedAround()
        self.dismissKeyboard()
    }
    
    func checkIfThereisData(){
        if (dataDict?.count == 0){
            checkLabel.text = "There are no events scheduled for today.";
        } else {
            checkLabel.text = "";
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
        checkIfThereisData()
    }
    
    // Convert the date from String back to date and display the complete date
    func DisplayTheDate(StringDateValue: String){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let date = dateFormatter.date(from: StringDateValue)

        dateFormatter.dateStyle = DateFormatter.Style.full
        let convertedDate = dateFormatter.string(from: date! as Date)
        selectedDateLabel.text = convertedDate;
    }
    
    // Get the events from the database for the selected date
    func getEvents() {
        let myUrl = NSURL(string: "https://www.noumanmehmood.com/scripts/retrieveEventsForDay.php");
        let request = NSMutableURLRequest(url:myUrl! as URL)
        let user_id = userDetails[0]
        request.httpMethod = "POST";
        let postString = "user_id=\(user_id)&requested_time=\(passingValue!)";
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
        return self.dataDict!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        if let array = self.dataDict?[String(indexPath.row + 1)] as? [String] {
            cell.subjectNameLabel.text = array[1]
            cell.classTypeLabel.text = "Type: " + array[2]
            cell.instructorNameLabel.text = "Instructor: " + array[3]
            cell.locationNameLabel.text = "Location: " + array[4]
            cell.startTimeLabel.text = "Start: " + array[5]
            cell.endTimeLabel.text = "End: " + array[6]
            cell.classLengthLabel.text = array[7] + " Hrs"
            cell.timeRemaining.text = array[8]
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
    
}

  
