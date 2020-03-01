//
//  SharingViewModel.swift
//  Sharing_Images_Demo
//
//  Created by it thinkers on 3/1/20.
//  Copyright © 2020 ibrahim-attalla. All rights reserved.
//

import Foundation
import Firebase

class SharingViewModel {
    
    let sharingGateway: APISharingServiceProtocol
    
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
    var user:User?
    
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    var dismissView:(()->())?
    
    init( sharingGateway: APISharingServiceProtocol = SharingGetway()) {
        self.sharingGateway = sharingGateway
    }
    
    
    func postImages(imageData :Data , sharing:Bool, ownerId:String , user:User){
        print("sharing value  == ..  ",sharing)
        state = .loading
        var imageName = "\(Date().timeIntervalSinceNow )"
        imageName.append(String("\(arc4random_uniform(9999))"))
        FirebaseStorageManager().uploadImageData(data: imageData, serverFileName: "images \(imageName).png") { (isSuccess, url) in
            print("uploadImageData: \(isSuccess), \(url)")
            if  isSuccess {
                // TODO : -  save image
                self.sharingGateway.postImages(withUserId: Auth.auth().currentUser!.uid, imgUrl: url!, sharing: sharing ,user:user) { (success, error) in
                    
                    if let result  = success {
                        self.state = .populated
                    }
                }
            }else{
                self.state = .error
            }
        }
    }
    
}
