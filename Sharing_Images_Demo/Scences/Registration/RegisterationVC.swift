//
//  RegisterationVC.swift
//  Sharing_Images_Demo
//
//  Created by it thinkers on 2/28/20.
//  Copyright © 2020 ibrahim-attalla. All rights reserved.
//

import UIKit

class RegisterationVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    
    lazy var viewModel: RegistrViewModel = {
        return RegistrViewModel()
    }()
    
    @IBOutlet weak var progress: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTF.delegate  = self
        passTF.delegate = self
        if #available(iOS 13.0, *) {
            initVM()
        } else {
            // Fallback on earlier versions
        }
        
        //TODO:
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewTapped))
        view.addGestureRecognizer(tapGesture)

    }
    //TODO:
       @objc func ViewTapped(){
           emailTF.endEditing(true)
           passTF.endEditing(true)
           print("111111111111111111111111")
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

                }
            }
        }
        
        viewModel.goToHomeScreen = {
        [weak self] in
        guard let self = self else { return }
        let homeVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "MainVC")
        homeVC.modalPresentationStyle = .fullScreen
        self.present(homeVC, animated: true, completion: nil)

    }
        
    }
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
    
    @IBAction func closeBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @available(iOS 13.0, *)
    @IBAction func registerBtnPressed(_ sender: Any) {
        
        viewModel.initRegister(email: emailTF.text!, password: passTF.text!)

    }
    
}
