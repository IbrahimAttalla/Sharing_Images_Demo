//
//  ImagesCellViewModel.swift
//  Sharing_Images_Demo
//
//  Created by it thinkers on 3/1/20.
//  Copyright © 2020 ibrahim-attalla. All rights reserved.
//

import UIKit

class ImagesCellViewModel {
    
    let loadImg = LoadImage()
    var postImg :Data?
    var sharing : Bool?
    var setImgToView:(()->())?
    var updateLoadingStatus: (()->())?
    var updateSwitchview:(()->())?

    // callback for interfaces
    var state: State = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    let imageUrl: String
//    let imageSharing:Bool

    init (imageUrl: String , imageSharing:Bool){
        self.imageUrl = imageUrl
        self.sharing = imageSharing
    }
    
    func fetchImg(){
        state = .loading

        let imgUrl = URL(string: "\(imageUrl)")
        loadImg.downloadImage(from: imgUrl!) {[weak self] (image) in
            
            guard let self = self  else{return}
            guard let newImage = image else{return}
            
            self.state = .populated
            self.postImg = newImage
            self.setImgToView?()
            self.updateLoadingStatus?()
            self.updateSwitchview?()
        }
    }
    
}
