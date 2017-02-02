//
//  LoginViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 01/02/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBAction func LoginButtonTapped(_ sender: Any) {
        
        var mainTabBar = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBar") as! UITabBarController;
        
        var appDelegate = UIApplication.shared.delegate as! AppDelegate;
        
        appDelegate.window?.rootViewController = mainTabBar;
        
        
        
    }
   
}
