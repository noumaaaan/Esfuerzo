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
        self.welcomeMessageLabel.text  = "Welcome " + UserDetails[1] + "!"
    }
    
    // Initialising the outlets in the view
    @IBOutlet weak var welcomeMessageLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // The saveed user details which is an array
    let UserDetails = UserDefaults.standard.stringArray(forKey: "UserDetailsArray") ?? [String]()
    
    // Creating the arrays to populate the table
    let walkthrough = ["How to use this app", "Add your own timetable"]
    let walkthroughDetails = ["Learn how to use this application in detail", "Add your own timetable if you're from Aston"]
    
    let prefArray1  = ["Add Subjects", "Add Instructors", "Add Locations", "Days of the week", "Notification Settings"]
    let prefArrat1Details = ["Manage the subjects that make your timetable", "Manage the different lecturers or tutors that teach your subjects", "Manage the different locations at which you take your classes", "How many days of the week will the timetable run for", "Manage the notifications that you will receive from this app"]
    
    let prefArray2  = ["Manage Account", "Change your password", "Contact Us", "Privacy Policy", "About Esfuerzo"]
    let prefArray2Details = ["Manage the details that are associated with your account", "Change the password associated with this account", "Any questions or want a feature impleemnted then let us know", "We take security very seriously. See our Privacy Policy", "The inspiration behind the app"]
    
    let prefArray3  = ["Like us on Facebook", "Follow us on Twitter"]
    let prefArray3Details = ["Like and follow our Facebook page for updates", "Follow us on Twitter to find out more"]
    
    // Log out of the application once the logout button has been tapped
    @IBAction func LogoutButtonTapped(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn");
        UserDefaults.standard.removeObject(forKey: "UserDetailsArray")
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
        
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        
        if (indexPath.section == 0){
            cell.textLabel?.text = walkthrough[indexPath.row]
            cell.detailTextLabel?.text = walkthroughDetails[indexPath.row]
            cell.detailTextLabel?.textColor = UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 1.0)
            
        } else if (indexPath.section == 1){
            cell.textLabel?.text = prefArray1[indexPath.row]
            cell.detailTextLabel?.text = prefArrat1Details[indexPath.row]
            cell.detailTextLabel?.textColor = UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 1.0)
            
        } else if (indexPath.section == 2){
            cell.textLabel?.text = prefArray2[indexPath.row]
            cell.detailTextLabel?.text = prefArray2Details[indexPath.row]
            cell.detailTextLabel?.textColor = UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 1.0)
        
        } else {
            cell.textLabel?.text = prefArray3[indexPath.row]
            cell.detailTextLabel?.text = prefArray3Details[indexPath.row]
            cell.detailTextLabel?.textColor = UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 1.0)
        }
        return cell
    }
    
    // Function to set the header information for the different sections
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Explore"
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
        
        // Beginning of the section, walkthrough of the app and add timetable if existing uni student
        if (indexPath.section == 0){
            switch indexPath.row {
                case 0:
                    segueIdentifier = "appWalkthroughView"
                case 1:
                    segueIdentifier = "addOwnTimetable"
                default:
                    segueIdentifier = "aboutEsfuerzoView"
                
            }
            self.performSegue(withIdentifier: segueIdentifier, sender: self)
            
        // Timetable specific controls where user can add subjects, locations and instructors
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
            
        // Account specific controls where the user can change their details
        } else if (indexPath.section == 2){
            switch indexPath.row {
            case 0:
                segueIdentifier = "changeDetailsView"
            case 1:
                segueIdentifier = "ChangePassView"
            case 2:
                segueIdentifier = "makeSuggestView"
            case 3:
                segueIdentifier = "privacyPolicyView"
            case 4:
                segueIdentifier = "aboutEsfuerzoView"
            default:
                segueIdentifier = "aboutEsfuerzoView"
            }
            self.performSegue(withIdentifier: segueIdentifier, sender: self)
        
        // Social Media Links
        } else {
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
