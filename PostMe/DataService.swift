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


class DataService {
    static let dataservice = DataService()
    
    private var _BASE_URL = FIRDatabase.database().referenceFromURL("//https://postme-30d0e.firebaseio.com")
    
    var BASE_URL: FIRDatabaseReference {
    return _BASE_URL
    }
}