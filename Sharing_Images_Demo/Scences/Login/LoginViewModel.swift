//
//  LoginViewModel.swift
//  Sharing_Images_Demo
//
//  Created by it thinkers on 2/29/20.
//  Copyright © 2020 ibrahim-attalla. All rights reserved.
//

import Foundation

class LoginViewModel {
    
    
    
    let authGateway: APILoginServiceProtocol
    
    // callback for interfaces
    var state: State = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    var goToHomeScreen:(()->())?
    
    init( authGateway: APILoginServiceProtocol = AuthGateway()) {
        self.authGateway = authGateway
    }
   
    
    func initLogin(email:String , password:String) {
        state = .loading
        authGateway.login(email: email, password: password) { [weak self] (success, error) in
            guard let self = self else {return}
            guard error == nil else {
                self.state = .error
                self.alertMessage = error
                return
            }
            self.goToHomeScreen?()
            }
    }
    
    
}

