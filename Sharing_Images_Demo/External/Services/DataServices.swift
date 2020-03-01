
//
//  DataService.swift
//  Sharing_Images_Demo
//
//  Created by it thinkers on 2/28/20.
//  Copyright © 2020 ibrahim-attalla. All rights reserved.
//

import Foundation
import Firebase
import SVProgressHUD



//let DB_BASE = Database.database().reference()

class DataService {
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_GROUPS = DB_BASE.child("groups")
    private var _REF_FEED = DB_BASE.child("images")
    
    
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_GROUPS: DatabaseReference {
        return _REF_GROUPS
    }
    
    var REF_FEED: DatabaseReference {
        return _REF_FEED
    }
    
    
    
    
    
    //MARK: - all firebase
    
    //   to create a user
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    
}





