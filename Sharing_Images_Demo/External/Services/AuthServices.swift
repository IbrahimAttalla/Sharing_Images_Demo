//
//  AuthServices.swift
//  Sharing_Images_Demo
//
//  Created by it thinkers on 2/28/20.
//  Copyright © 2020 ibrahim-attalla. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
    static let instance = AuthService()
    
    func registerUser(withEmail email: String, andPassword password: String, userCreationComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            guard let user = authResult?.user else {
                userCreationComplete(false, error)
                return
            }
            
            let userData = ["provider": user.providerID, "email": user.email]
//             to create a user
            DataService.instance.createDBUser(uid: user.uid , userData: userData)
            userCreationComplete(true, nil)
        }
    }
    
    func loginUser(withEmail email: String, andPassword password: String, loginComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if error != nil {
                print("login error == > " , error!)
                loginComplete(false, error)
                return
            }
            loginComplete(true, nil)
        }
    }
}





