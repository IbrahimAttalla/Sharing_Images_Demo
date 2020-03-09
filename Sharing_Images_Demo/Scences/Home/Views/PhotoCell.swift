//
//  PhotoCell.swift
//  Sharing_Images_Demo
//
//  Created by it thinkers on 2/27/20.
//  Copyright © 2020 ibrahim-attalla. All rights reserved.
//

import UIKit
import SDWebImage
import AMShimmer

class PhotoCell: UITableViewCell {

    @IBOutlet weak var postOwnerImgV: UIImageView!
    @IBOutlet weak var postOwnerName: UILabel!
    @IBOutlet weak var postImgV: UIImageView!
    
    
    var photocellVM : PhotoCellViewModel?{
        didSet{
            // to reset all views til loading a new one
            postOwnerImgV.image = nil
            postImgV.image = nil
            self.selectionStyle = .none

            
            
            postImgV.loadImgThroughSDWebImage(ImgUrl: self.photocellVM!.postImgUrl, avatar: "photos")
            
            postOwnerImgV.loadImgThroughSDWebImage(ImgUrl: self.photocellVM!.ownerImg, avatar: "photos")
            
            if let ownerName = self.photocellVM?.ownerName {
                self.postOwnerName.text = ownerName
            }

            
            
            //            photocellVM!.setImgToView = { [weak self] () in
            //                guard let self = self else {return}
            //                DispatchQueue.main.async {
            //                    if let postimage = self.photocellVM!.postImgData{
            //                        self.postImgV.image = UIImage(data: postimage)
            //                    }
            //                    if let image = self.photocellVM!.postOwnerImgData{
            //                        self.postOwnerImgV.image = UIImage(data: image)
            //                    }
            //                    if let ownerName = self.photocellVM?.ownerName {
            //                        self.postOwnerName.text = ownerName
            //                    }
            //
            //
            //                }
            //            }

            //            photocellVM!.fetchImgs()
            
            //            photocellVM!.updateLoadingStatus = { [weak self] () in
            //                guard let self = self else {
            //                    return
            //                }
            //
            //                DispatchQueue.main.async { [weak self] in
            //                    guard let self = self else { return }
            //                    switch self.photocellVM!.state {
            //                    case .empty, .error:
            //                        self.loadingHud.stopAnimating()
            //                        self.loadingHud.isHidden = true
            //                    case .loading:
            //                        self.loadingHud.startAnimating()
            //                        self.loadingHud.isHidden = false
            //                    case .populated:
            //                        self.loadingHud.stopAnimating()
            //                        self.loadingHud.isHidden = true
            //
            //                    }
            //                }
            //            }

            }

        }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(){
        self.selectionStyle = .none
    }

}

