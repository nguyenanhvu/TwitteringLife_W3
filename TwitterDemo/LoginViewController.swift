//
//  LoginViewController.swift
//  TwitterDemo
//
//  Created by Dave Vo on 7/17/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit
import AFNetworking
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogin(sender: UIButton) {
        print("login")
        // TODO: Get request token, redirect to authURL, convert requestToken -> accessToken
        let twitterClient = TwitterClient.getSession
        
        // To make sure whoever login before, logout first
            twitterClient.login({
            self.performSegueWithIdentifier("loginSegue", sender: nil)
        }) { (error: NSError) in
                print("\(error.localizedDescription)")
        }
    }
    
    
}
