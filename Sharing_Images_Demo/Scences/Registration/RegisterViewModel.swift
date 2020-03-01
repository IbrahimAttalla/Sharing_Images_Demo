//
//  RegisterViewModel.swift
//  Sharing_Images_Demo
//
//  Created by it thinkers on 2/29/20.
//  Copyright © 2020 ibrahim-attalla. All rights reserved.
//

import Foundation


class RegistrViewModel {
    
    
    
    let registerGateway: APIRegisterServiceProtocol
    
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
    
    init( registerGateway: APIRegisterServiceProtocol = RegisterGetway()) {
        self.registerGateway = registerGateway
    }
   
    
    func initRegister(email:String , password:String) {
        state = .loading
        registerGateway.register(email: email, password: password) { [weak self] (success, error) in
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

