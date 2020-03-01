//
//  ProfileViewModel.swift
//  Sharing_Images_Demo
//
//  Created by it thinkers on 2/29/20.
//  Copyright © 2020 ibrahim-attalla. All rights reserved.
//

import Foundation
import Firebase

class ProfileViewModel {
    
    let profileGateway: APIProfileServiceProtocol
    
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
    private var cellViewModels: [ImagesCellViewModel] = [ImagesCellViewModel]() {
        didSet {
            self.reloadImagesCollection?()
        }
    }
    var user:User?
    var images:[UserImages]?
    
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    var reloadProfileData:(()->())?
    var reloadImagesCollection:(()->())?
    
    init( profileGateway: APIProfileServiceProtocol = ProfileGetway()) {
        self.profileGateway = profileGateway
    }
    
    func initProfile(withUserId:String) {
        print("withUserId = = " , withUserId)
        state = .loading
        profileGateway.getUserData(withUserId: withUserId) { [weak self] (user, error) in
            
            guard let self = self else {return}
            guard error == nil else {
                self.state = .error
                self.alertMessage = error
                return
            }
            self.user = user
            self.state = .populated
            self.reloadProfileData?()
        }
        
        
        
    }
    
    func uplaodImages(imageData :Data){
        state = .loading
        var imageName = "\(Date().timeIntervalSinceNow )"
        imageName.append(String("\(arc4random_uniform(6))"))
          FirebaseStorageManager().uploadImageData(data: imageData, serverFileName: "images \(imageName).png") { (isSuccess, url) in
                 print("uploadImageData: \(isSuccess), \(url)")
            if  isSuccess {
                // TODO : -  save image to user profile
                self.profileGateway.saveProfileImage(withUserId: Auth.auth().currentUser!.uid, imgUrl: url!) { (success, error) in
                    if let result  = success {
//                        self.state = .populated
                    }
                }
            }else{
                self.state = .error
            }
            
           }

        
    }
    
    func getUserimages(){
        state = .loading
        profileGateway.getUserImages(withUserId: Auth.auth().currentUser!.uid) { [weak self] (imagesArr, serverError) in
            guard let self = self else {return}
            self.images = imagesArr
            print("imagesArr == ", self.images)
//            self.reloadImagesCollection?()
            self.processFetchedImagesList(imageslist: self.images!)

            self.state = .populated

        }
        
    }
    
    
    // to load img
       private func processFetchedImagesList( imageslist:[UserImages] ) {
        self.images?.removeAll()
           self.images? = imageslist // Cache
           var vms = [ImagesCellViewModel]()
        for image in images! {
               vms.append( createCellViewModel(image: image) )
           }
           self.cellViewModels = vms
       }
    func imagesCount() -> Int{
        return images?.count ?? 0
    }
    
    
    func getCellViewModel( at indexPath: IndexPath ) -> ImagesCellViewModel {
        return cellViewModels[indexPath.row]
    }
        // be passed to cell for row
        func createCellViewModel( image: UserImages ) -> ImagesCellViewModel {
            return ImagesCellViewModel(imageUrl: image.imgUrl ?? "", imageSharing: image.sharing ?? false )
        }

    
    
    
//    func updateImageStatus(imageId:String , iamgeStatus:Bool){
//
//        state = .loading
//        profileGateway.getUserData(withUserId: withUserId) { [weak self] (user, error) in
//
//            guard let self = self else {return}
//            guard error == nil else {
//                self.state = .error
//                self.alertMessage = error
//                return
//            }
//            self.user = user
//            self.state = .populated
//            self.reloadProfileData?()
//        }
//
////        profileGateway.updateImageStatus(imageId: <#T##String#>, imageStatus: <#T##Bool#>, complete: <#T##(Bool?, String?) -> ()#>)
//
//    }
    
    
}
