//
//  PhotoCellModelView.swift
//  Sharing_Images_Demo
//
//  Created by it thinkers on 3/1/20.
//  Copyright © 2020 ibrahim-attalla. All rights reserved.
//

import UIKit
class PhotoCellViewModel {
    
    let loadImg = LoadImage()
    var postImgData :Data?
    var postOwnerImgData:Data?
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
    
    let postImgUrl: String
    let ownerImg:String
    let ownerName:String
//    let imageSharing:Bool

    init (imageUrl: String , ownerImg:String,ownerName:String){
        self.postImgUrl = imageUrl
        self.ownerImg = ownerImg
        self.ownerName = ownerName

    }
    
    func fetchImgs(){
        state = .loading

        if   let postImg = URL(string: "\(postImgUrl)") {
            
       
            loadImg.downloadImage(from: postImg) { [weak self] (image) in
            
            guard let self = self  else{return}
            guard let newImage = image else{return}
            
            self.state = .populated
            self.postImgData = newImage
            self.setImgToView?()
            self.updateLoadingStatus?()
            self.updateSwitchview?()
            }
         }
        
       if let postOwnerImg = URL(string: "\(ownerImg)") {
        loadImg.downloadImage(from: postOwnerImg) {
            [weak self] (image) in
            
            guard let self = self  else{return}
            guard let newImage = image else{return}
            self.state = .populated
            self.postOwnerImgData = newImage
            self.setImgToView?()
            self.updateLoadingStatus?()
            self.updateSwitchview?()
        }
        }
        
    }
    
}
