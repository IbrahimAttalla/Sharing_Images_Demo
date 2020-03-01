//
//  HomeViewModel.swift
//  Sharing_Images_Demo
//
//  Created by it thinkers on 3/1/20.
//  Copyright © 2020 ibrahim-attalla. All rights reserved.
//

import Foundation
class HomeViewModel{
    let homeGetway : APIHomeServiceProtocol
    
    
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
    private var cellViewModels: [PhotoCellViewModel] = [PhotoCellViewModel]() {
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
    var showImagesCollection:(()->())?
    var hideImagesCollection:(()->())?
    
    init( homeGetway: APIHomeServiceProtocol = HomeGetway()) {
        self.homeGetway = homeGetway
    }
    
    func initProfile() {
//        print("withUserId = = " , withUserId)
        state = .loading
      
        homeGetway.getHomeImages { [weak self] (imagsArr, error) in
                       
                       guard let self = self else {return}
                       guard error == nil else {
                           self.state = .error
                           self.alertMessage = error
                           return
                       }
            print("Home images == " , self.images)
            if imagsArr.count > 0{
                self.images?.removeAll()
                self.images = imagsArr
                self.processFetchedImagesList(imageslist: self.images!)
                self.state = .populated
            }else{
            self.state = .populated
            }
        }
    }
    
    func ImagesCollectionDispaly(){
        if   images?.count ?? 0 > 0 {
        self.showImagesCollection?()
        }else{
        self.hideImagesCollection?()
        }
        
    }
    // to load img
         private func processFetchedImagesList( imageslist:[UserImages] ) {
          self.images?.removeAll()
        self.cellViewModels.removeAll()
             self.images? = imageslist // Cache
             var vms = [PhotoCellViewModel]()
          for image in images! {
                 vms.append( createCellViewModel(image: image) )
             }
             self.cellViewModels = vms
         }
      func getImagesCount() -> Int{
          return images?.count ?? 0
      }
    
      
      
      func getCellViewModel( at indexPath: IndexPath ) -> PhotoCellViewModel {
          return cellViewModels[indexPath.row]
      }
          // be passed to cell for row
          func createCellViewModel( image: UserImages ) -> PhotoCellViewModel {
//              return PhotoCellViewModel(imageUrl: image.imgUrl ?? "", imageSharing: image.sharing ?? false )
            return PhotoCellViewModel(imageUrl: image.imgUrl ?? "", ownerImg: image.ownerImg ?? "", ownerName: image.ownerName ?? "")

          }

}
