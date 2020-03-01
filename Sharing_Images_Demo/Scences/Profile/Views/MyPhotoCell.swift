//
//  MyPhotoCell.swift
//  Sharing_Images_Demo
//
//  Created by it thinkers on 2/27/20.
//  Copyright © 2020 ibrahim-attalla. All rights reserved.
//

import UIKit

class MyPhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var sharingSwitchOutLet: UISwitch!
    
    @IBOutlet weak var loadingHud: UIActivityIndicatorView!
    
    var imagscellVM : ImagesCellViewModel?{
        didSet{
            // to reset all views til loading a new one
            image.image = nil

            imagscellVM!.updateLoadingStatus = { [weak self] () in
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    switch self.imagscellVM!.state {
                    case .empty, .error:
                        self.loadingHud.stopAnimating()
                        self.loadingHud.isHidden = true
                        
                    case .loading:
                        self.loadingHud.startAnimating()
                        self.loadingHud.isHidden = false
                    case .populated:
                        self.loadingHud.stopAnimating()
                        self.loadingHud.isHidden = true

                    }
                }
            }
            
            imagscellVM!.setImgToView = { [weak self] () in
                guard let self = self else {return}
                DispatchQueue.main.async {
                    if let image = self.imagscellVM!.postImg{
                        self.image.image = UIImage(data: self.imagscellVM!.postImg!)
                    }
                    
                    self.sharingSwitchOutLet.setOn(self.imagscellVM?.sharing ?? false, animated: true)
                }
            }
            
            imagscellVM!.fetchImg()
            }

        }

    @IBAction func changeStaus(_ sender: UISwitch) {
//        imagscellVM!.
    }
}