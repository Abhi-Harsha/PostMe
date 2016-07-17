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
import FirebaseAuth


class ViewController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginBtnPressed(sender: UIButton!) {
        
        if let name = userName.text where userName.text != "", let pwd = password.text where password.text != "" {
            FIRAuth.auth()?.createUserWithEmail(name, password: pwd, completion: { user, error in
                
                if error != nil {
                    switch error!.code {
                        
                    case 17026: print("weak password")
                                break;
                    default: print("default")
                                break
                    }
                    
                } else {
                    self.performSegueWithIdentifier(LoggedIn, sender: sender)
                }
                
            })
        }
        
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
            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
                print(credential)
                
                FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                    //creating user on firebase?
                    
                    if error != nil {
                        print(error.debugDescription)
                    } else {
                        print("user created on firebase\(user.debugDescription)")
                    }
                }
                self.performSegueWithIdentifier(LoggedIn, sender: sender)
                
            }
        }
    }
    



}

