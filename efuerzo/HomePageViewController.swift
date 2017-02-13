//
//  HomePageViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 07/02/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var activityController: UIActivityIndicatorView!
    
    let UserDetails = UserDefaults.standard.stringArray(forKey: "UserDetailsArray") ?? [String]()
    let homeArray = ["Add Subjects", "Add Instructors", "Days of the week",  "","Change my details", "About"]
    
    // Log out of the application once the logout button has been tapped
    @IBAction func LogoutButtonTapped(_ sender: Any) {
        self.activityController.startAnimating();
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn");
        UserDefaults.standard.synchronize();
        self.performSegue(withIdentifier: "LoginViewController", sender: self);
        self.activityController.stopAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return UserDetails.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = UserDetails[indexPath.row]
        return cell
    }
    
    
    
}
