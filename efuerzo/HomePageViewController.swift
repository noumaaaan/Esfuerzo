//
//  HomePageViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 07/02/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {

    // Log out of the application once the logout button has been tapped
    @IBAction func LogoutButtonTapped(_ sender: Any) {
        
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn");
        UserDefaults.standard.synchronize();
        self.performSegue(withIdentifier: "LoginViewController", sender: self);
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
