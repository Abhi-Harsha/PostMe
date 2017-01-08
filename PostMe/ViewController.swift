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

    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.value(forKey: USER_ID) != nil {
            self.performSegue(withIdentifier: LoggedIn, sender: nil)
        }
    }
    
    @IBAction func onLoginBtnPressed(sender: UIButton!) {
        
        if let email = userName.text, userName.text != "", let pwd = password.text, password.text != "" {
            FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { user, creationerror in
                
                if let errorcode =  creationerror {
                    
                    switch errorcode {
                        
                        case FIRAuthErrorCode.errorCodeWeakPassword:
                                                                                print("weak password\(errorcode)")
                                                                               self.showAlertPopUp(title: "Password is weak", message: "Please provide password of length greater than 6 characters")
                                                                               break;
                        case FIRAuthErrorCode.errorCodeInvalidEmail:
                                                                                print("invalid email")
                                                                              self.showAlertPopUp(title: "Invalid Email Id", message: "Please check your emailid and try again")
                                                                              break;
                        case FIRAuthErrorCode.errorCodeEmailAlreadyInUse:
                                                                            print("Email Id already exists")
                                                                            self.showAlertPopUp(title: "Email Id already exists", message: "Please try with a different emailid")
                                                                                break;
                        case FIRAuthErrorCode.errorCodeNetworkError:
                                                                                print("Network error")
                                                                                self.showAlertPopUp(title: "Network error!", message: "Please check your internet connection and try again")
                                                                                break;
                        default:
                                 self.showAlertPopUp(title: "Some error occured while signing up", message: "Please try again.")
                                 print(errorcode.localizedDescription)
                                break
                    }
                    
                } else {
                    if let user = user {
                        let userdict = ["provider" : "email", "test" : "testchild"]
                        print("\(userdict)")
                        DataService.ds.CreateFireBaseUser(uid: user.uid, User: userdict)
                        UserDefaults.standard.setValue(user.uid, forKey: USER_ID)
                    }
                    self.performSegue(withIdentifier: LoggedIn, sender: sender)
                }
                
            })
        }
        
    }
    
    @IBAction func onFbBtnPressed(sender: UIButton!) {
       let fbmanager = FBSDKLoginManager()
        
        fbmanager.logIn(withReadPermissions: ["email"], from: self) { (result: FBSDKLoginManagerLoginResult?, error: Error?) in
            if error != nil {
                print("There was an error while loggin in \(error.debugDescription)")
            } else if (result?.isCancelled)! {
                print("Facebook login was cancelled")
            } else {
                print("logged into facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                print(credential)
                
                FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                    if let errorcode = error {
                        print(errorcode.localizedDescription)
                    } else {
                        print("user created on firebase\(user.debugDescription)")
                        if let user = user {
                            let userdict = ["provider": "facebook"]
                            DataService.ds.CreateFireBaseUser(uid: user.uid, User: userdict)
                            
                            UserDefaults.standard.setValue(user.uid, forKey: USER_ID)
                        }
                        
                    }
                }
                self.performSegue(withIdentifier: LoggedIn, sender: sender)
            }
        }
    }
    
    func showAlertPopUp(title: String, message: String) {
       let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
       let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

}

