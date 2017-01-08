//
//  DataService.swift
//  PostMe
//
//  Created by Abhishek H P on 7/16/16.
//  Copyright © 2016 Abhishek H P. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

let _BASE_URL = "https://postme-30d0e.firebaseio.com"

class DataService {
    static let ds = DataService()
    
    private var _Post_URL = FIRDatabase.database().reference(fromURL: "\(_BASE_URL)/Posts")
    private var _User_URL = FIRDatabase.database().reference(fromURL: "\(_BASE_URL)/Users")
    
    var POST_URL: FIRDatabaseReference {
     return _Post_URL
    }
    
    var USER_URL: FIRDatabaseReference {
        return _User_URL
    }
    
    func CreateFireBaseUser(uid: String, User: Dictionary<String,String>) {
        USER_URL.child(uid).setValue(User)
    }
}
