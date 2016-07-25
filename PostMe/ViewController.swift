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

    override func viewDidAppear(animated: Bool) {
        if NSUserDefaults.standardUserDefaults().valueForKey(USER_ID) != nil {
            
        }
    }
    
    @IBAction func onLoginBtnPressed(sender: UIButton!) {
        
        if let email = userName.text where userName.text != "", let pwd = password.text where password.text != "" {
            FIRAuth.auth()?.createUserWithEmail(email, password: pwd, completion: { user, creationerror in
                
                if let errorcode =  creationerror {
                    
                    switch errorcode.code {
                        
                        case FIRAuthErrorCode.ErrorCodeWeakPassword.rawValue : print("weak password\(errorcode.debugDescription)")
                                                                               self.showAlertPopUp("Password is weak", message: "Please provide password of length greater than 6 characters")
                                                                               break;
                        case FIRAuthErrorCode.ErrorCodeInvalidEmail.rawValue: print("invalid email")
                                                                              self.showAlertPopUp("Invalid Email Id", message: "Please check your emailid and try again")
                                                                              break;
                        case FIRAuthErrorCode.ErrorCodeEmailAlreadyInUse.rawValue : print("Email Id already exists")
                                                                           self.showAlertPopUp("Email Id already exists", message: "Please try with a different emailid")
                                                                                break;
                        case FIRAuthErrorCode.ErrorCodeNetworkError.rawValue: print("Network error")
                                                                                self.showAlertPopUp("Network error!", message: "Please check your internet connection and try again")
                                                                                break;
                        default: print("Some error occured while signing up\(errorcode.debugDescription)")
                                 self.showAlertPopUp("Some error occured while signing up", message: "Please try again.")
                                break
                    }
                    
                } else {
                    if let user = user {
                        let userdict = ["provider" : "email", "test" : "testchild"]
                        print("\(userdict)")
                        DataService.ds.CreateFireBaseUser(user.uid, User: userdict)
                        NSUserDefaults.standardUserDefaults().setValue(user.uid, forKey: USER_ID)
                    }
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
                    
                    if let errorcode = error {
                        print(errorcode.debugDescription)
                    } else {
                        print("user created on firebase\(user.debugDescription)")
                        if let user = user {
                            let userdict = ["provider": "facebook"]
                            DataService.ds.CreateFireBaseUser(user.uid, User: userdict)
                            
                            NSUserDefaults.standardUserDefaults().setValue(user.uid, forKey: USER_ID)
                        }
                        
                    }
                }
                self.performSegueWithIdentifier(LoggedIn, sender: sender)
            }
        }
    }
    
    func showAlertPopUp(title: String, message: String) {
       let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
       let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }

}

