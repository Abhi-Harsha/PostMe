//
//  ViewController.swift
//  PostMe
//
//  Created by Abhishek H P on 6/30/16.
//  Copyright © 2016 Abhishek H P. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import FBSDKCoreKit
import FBSDKLoginKit


class ViewController: UIViewController {
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onFbBtnPressed(sender: UIButton!) {
       let fbmanager = FBSDKLoginManager()
        
        fbmanager.logInWithReadPermissions(["email"], fromViewController: self) { (result: FBSDKLoginManagerLoginResult!, error: NSError!) in
            if error != nil {
                print("There was an error while loggin in \(error.debugDescription)")
            } else if result.isCancelled {
                print("Facebook login was cancelled")
            } else {
                print("logged into facebook")
            }
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if let err = error {
            print("Login failed with following error \(err.debugDescription)")
        } else {
         print("Inside loginButton protocol method")
            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
            print("User creds is \(credential)")
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }


}

