//
//  CamareHandler.swift
//  Jibley Customer App
//
//  Created by it thinkers on 10/2/18.
//  Copyright © 2018 ios thinkers. All rights reserved.
//

import Foundation
import UIKit


class CameraHandler: NSObject{
    static let shared = CameraHandler()
    
    fileprivate var currentVC: UIViewController!
    fileprivate var myPickerController: UIImagePickerController!
    //MARK: Internal Properties
    // this is aclosre to pass the image to the working view controller .....  :)
    var imagePickedBlock: ((UIImage) -> Void)?
    
    func camera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
             myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .camera
            currentVC.present(myPickerController, animated: true, completion: nil)
        }
        
    }
    
    func photoLibrary()
    {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
             myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .photoLibrary
            currentVC.present(myPickerController, animated: true, completion: nil)
        }
        
    }
    
    func showActionSheet(vc: UIViewController) {
        currentVC = vc
//        CAMERA = ""
//        GALLERY = ""
//        CANCEL_ACTION_SHEET = ""
//        
//        CAMERA = NSLocalizedString("camera", comment: "")
//        GALLERY = NSLocalizedString("gallery", comment: "")
//        CANCEL_ACTION_SHEET = NSLocalizedString("cancelActionSheet", comment: "")

        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "CAMERA", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "GALLERY", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
       
        actionSheet.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: nil))
        actionSheet.view.tintColor =  UIColor(named: "AppMainColor") != nil ? UIColor(named: "AppMainColor")! : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        actionSheet.popoverPresentationController?.sourceView = vc.view
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: vc.view.bounds.midX, y: (vc.view.frame.height)-100, width: 0, height: 0)
        actionSheet.popoverPresentationController?.permittedArrowDirections = []


        vc.present(actionSheet, animated: true, completion: nil)
    }
    
}


extension CameraHandler: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        myPickerController.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.imagePickedBlock?(image)
        }else{
            print("Something went wrong")
        }
        myPickerController.dismiss(animated: true, completion: nil)
    }
    
}
