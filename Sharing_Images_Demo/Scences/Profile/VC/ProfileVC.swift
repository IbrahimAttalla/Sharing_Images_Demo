//
//  ProfileVC.swift
//  Sharing_Images_Demo
//
//  Created by it thinkers on 2/27/20.
//  Copyright © 2020 ibrahim-attalla. All rights reserved.
//

import UIKit
import Firebase
import AMShimmer
import SDWebImage


class ProfileVC: UIViewController  , UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    /**
     ImageToSave : for cashing img to present it to Xibs
     */
    var ImageToSave:Data?
    lazy var viewModel: ProfileViewModel = {
        return ProfileViewModel()
    }()

    @IBOutlet weak var profile_ImgV: UIImageView!
    @IBOutlet weak var photosCollection: UICollectionView!
    @IBOutlet weak var progress: UIActivityIndicatorView!
    
    @IBOutlet weak var nameTF: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        view.accessibilityIdentifier = "view_Profileboard"
        if #available(iOS 13.0, *) {
                   initVM()
               }
        else {
                   // Fallback on earlier versions
               }
        
    }
    
    
    @available(iOS 13.0, *)
    func initVM() {
        self.progress.startAnimating()
        self.progress.isHidden = false

        viewModel.initProfile(withUserId: Auth.auth().currentUser!.uid)
        viewModel.getUserimages()
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }
        
        viewModel.reloadImagesCollection = {
            [weak self] () in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                [weak self] in
                               guard let self = self else {
                                   return
                               }
                            self.photosCollection.reloadData()

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

                }
            }
        }
        
        viewModel.reloadProfileData = {
        [weak self] in
            guard let self = self else {
                return
            }
            // TODO :- Update user image and user name with email
            self.nameTF.text = self.viewModel.user?.name
            let imageURL = URL(string: self.viewModel.user!.profileImgUrl ?? "")
            AMShimmer.start(for: self.profile_ImgV)
            self.profile_ImgV.sd_setImage(with: imageURL, completed: {
                (image, error, cacheType, url) in
                if error != nil {
                    self.profile_ImgV.image = UIImage(named: "photos") // add placeholder
                }
                AMShimmer.stop(for: self.profile_ImgV)
            })
        }
        
    }
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func logoutBtnPressed(_ sender: UIButton) {
        try! Auth.auth().signOut()

                            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginVC") 
            vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: false, completion: nil)
               
    }
    
    @IBAction func editProfileImgBtnPressed(_ sender: Any) {
         CameraHandler.shared.showActionSheet(vc: self)
         CameraHandler.shared.imagePickedBlock = { (image) in
             self.ImageToSave? = image.jpeg(.lowest)!
            
            self.profile_ImgV.image = image
            if let data = image.jpeg(.lowest) {
                self.viewModel.uplaodImages(imageData: data)
            }
              }
        

    }
    
    
    @available(iOS 13.0, *)
    @IBAction func cameraBtnPressed(_ sender: UIButton) {
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            self.ImageToSave? = image.jpeg(.low)!
            SAVED_IMAGES = image.jpeg(.low)!
            POST_OWNER = self.viewModel.user
            let sharingVC = SharingVC(nibName: "SharingVC", bundle: nil)
            sharingVC.ImageToSave = self.ImageToSave
            sharingVC.modalPresentationStyle = .overCurrentContext

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.present(sharingVC, animated: true, completion: nil)
                }
             }
       
    }
    

 
}

extension ProfileVC: UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imagesCount()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPhotoCell", for: indexPath) as! MyPhotoCell
        let cellVM = viewModel.getCellViewModel( at: indexPath )
        cell.imagscellVM = cellVM
    

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
      {
          return CGSize(width: (collectionView.bounds.width / 2.08), height: 240.0)
      }
    
    
}
