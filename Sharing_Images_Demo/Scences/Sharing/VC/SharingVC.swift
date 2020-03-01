//
//  SharingVC.swift
//  Sharing_Images_Demo
//
//  Created by it thinkers on 2/27/20.
//  Copyright © 2020 ibrahim-attalla. All rights reserved.
//

import UIKit
import Firebase

class SharingVC: UIViewController {
    
    @IBOutlet weak var imageToPost: UIImageView!
    lazy var viewModel: SharingViewModel = {
        return SharingViewModel()
    }()
    
    @IBOutlet weak var progress: UIActivityIndicatorView!
    var ImageToSave: Data?
    
    @IBOutlet weak var sharingSwitchOutLet: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageToPost.image = UIImage(data: SAVED_IMAGES!)
        if #available(iOS 13.0, *) {
                          initVM()
                      }
               else {
                          // Fallback on earlier versions
                      }
    }
    
    @available(iOS 13.0, *)
    func initVM() {
        self.progress.stopAnimating()
        self.progress.isHidden = true

        
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] () in
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                switch self.viewModel.state {
                case .empty, .error:
                    self.progress.stopAnimating()
                    self.progress.isHidden = true
                case .loading:
                    self.progress.startAnimating()
                    self.progress.isHidden = false
                case .populated:
                    self.progress.stopAnimating()
                    self.progress.isHidden = true
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
//        viewModel.reloadProfileData = {
//        [weak self] in
//            guard let self = self else {
//                return
//            }
//            // TODO :- Update user image and user name with email
//            self.nameTF.text = self.viewModel.user?.name
//            let imageURL = URL(string: self.viewModel.user!.profileImgUrl ?? "")
//            AMShimmer.start(for: self.profile_ImgV)
//            self.profile_ImgV.sd_setImage(with: imageURL, completed: {
//                (image, error, cacheType, url) in
//                if error != nil {
//                    self.profile_ImgV.image = UIImage(named: "photos") // add placeholder
//                }
//                AMShimmer.stop(for: self.profile_ImgV)
//            })
//        }
        
    }
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func sharingSwitch(_ sender: UISwitch) {
   
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func DoneBtnPressed(_ sender: Any) {
        viewModel.postImages(imageData: SAVED_IMAGES!, sharing: sharingSwitchOutLet.isOn, ownerId: Auth.auth().currentUser!.uid ,user:POST_OWNER!)
    }
    
}
