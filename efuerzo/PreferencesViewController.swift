//
//  PreferencesViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 12/02/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit

class PreferencesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // Initialising the outlets in the view
    @IBOutlet weak var welcomeMessageLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // The saveed user details which is an array
    let UserDetails = UserDefaults.standard.stringArray(forKey: "UserDetailsArray") ?? [String]()
    
    // Creating two arrays to display within the table
    
    let prefArray1 = ["Add Subjects", "Add Instructors", "Add Locations", "Days of the week", "Notification Settings"]
    let prefArray2 = ["Manage Account", "Contact Us", "Privacy Policy", "About Esfuerzo"]
    
    override func viewDidLoad() {
        setWelcomeMessage()
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setWelcomeMessage(){
        let userFullName = UserDetails[1]
        self.welcomeMessageLabel.text = "Welcome " + userFullName + "!"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0){
            return prefArray1.count
        } else {
            return prefArray2.count
        }
    }
    
    // Return number of sections in the table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // Populate the table with data from the arrays
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        
        if (indexPath.section == 0){
            cell.textLabel?.text = prefArray1[indexPath.row]
        } else {
            cell.textLabel?.text = prefArray2[indexPath.row]
        }
    
        return cell
    }
    
    // Navigate to the view controllers dependant upon what table in cell has been selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let segueIdentifier: String
        
        if (indexPath.section == 0){
            switch indexPath.row {
                case 0:
                    segueIdentifier = "addSubjectView"
                case 1:
                    segueIdentifier = "addInstructorView"
                case 2:
                    segueIdentifier = "addLocationsView"
                case 3:
                    segueIdentifier = "daysOfWeekView"
                case 4:
                    segueIdentifier = "NotifSettingsView"
                default:
                    segueIdentifier = "aboutEsfuerzoView"
            }
            self.performSegue(withIdentifier: segueIdentifier, sender: self)
            
        } else {
            switch indexPath.row {
                case 0:
                    segueIdentifier = "changeDetailsView"
                case 1:
                    segueIdentifier = "makeSuggestView"
                case 2:
                    segueIdentifier = "privacyPolicyView"
                case 3:
                    segueIdentifier = "aboutEsfuerzoView"
                default:
                    segueIdentifier = "aboutEsfuerzoView"
            }
            self.performSegue(withIdentifier: segueIdentifier, sender: self)
        }
    }
}
