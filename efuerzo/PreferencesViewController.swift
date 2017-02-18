//
//  PreferencesViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 12/02/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit

class PreferencesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // On view load, do these functions
    override func viewDidLoad() {
        super.viewDidLoad()
        let userFullName = UserDetails[1]
        self.welcomeMessageLabel.text = "Welcome " + userFullName + "!"
    }
    
    // Initialising the outlets in the view
    @IBOutlet weak var welcomeMessageLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // The saveed user details which is an array
    let UserDetails = UserDefaults.standard.stringArray(forKey: "UserDetailsArray") ?? [String]()
    
    // Creating two arrays to display within the table
    
    let walkthrough = ["How to use this app"]
    let prefArray1  = ["Add Subjects", "Add Instructors", "Add Locations", "Days of the week", "Notification Settings"]
    let prefArray2  = ["Manage Account", "Contact Us", "Privacy Policy", "About Esfuerzo"]
    let prefArray3  = ["Like us on Facebook", "Follow us on Twitter"]
    
    // Log out of the application once the logout button has been tapped
    @IBAction func LogoutButtonTapped(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn");
        // Need to remove the User default array for the details of the user that is logged in
        UserDefaults.standard.synchronize();
        self.performSegue(withIdentifier: "LoginViewController", sender: self);
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0){
            return walkthrough.count
        } else if (section == 1){
            return prefArray1.count
        } else if (section == 2){
            return prefArray2.count
        } else {
            return prefArray3.count
        }
    }
    
    // Return number of sections in the table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    // Populate the table with data from the arrays
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        
        if (indexPath.section == 0){
            cell.textLabel?.text = walkthrough[indexPath.row]
        } else if (indexPath.section == 1){
            cell.textLabel?.text = prefArray1[indexPath.row]
        } else if (indexPath.section == 2){
            cell.textLabel?.text = prefArray2[indexPath.row]
        } else {
            cell.textLabel?.text = prefArray3[indexPath.row]
        }
        return cell
    }
    
    // Function to set the header information for the different sections
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Walkthrough"
        case 1:
            return "Adjust Timetable"
        case 2:
            return "Account Settings"
        case 3:
            return "Social Media Links"
        default:
            return "Technically this shouldnt appear"
        }
    }
    
    // Navigate to the view controllers dependant upon what table in cell has been selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let segueIdentifier: String
        
        // App specific controls
        if (indexPath.section == 0){
            self.performSegue(withIdentifier: "walkthroughView", sender: self)
            
        } else if (indexPath.section == 1){
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
            
        } else if (indexPath.section == 2){
            
            // Account settings
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
        
        } else {
            
            // Social Media Links
            if(indexPath.row == 0){
                let facebookPage = URL(string: "https://www.facebook.com/EsfuerzoApp/")!
                UIApplication.shared.open(facebookPage)
                
            } else {
                let twitterPage = URL(string: "https://twitter.com/EsfuerzoApp")!
                UIApplication.shared.open(twitterPage)
            }
        }
    }
}
