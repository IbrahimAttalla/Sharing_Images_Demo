//
//  HomeVC.swift
//  Sharing_Images_Demo
//
//  Created by it thinkers on 2/26/20.
//  Copyright © 2020 ibrahim-attalla. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var photosTableV: UITableView!
    
    @IBOutlet weak var progress: UIActivityIndicatorView!
    lazy var viewModel: HomeViewModel = {
           return HomeViewModel()
       }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
                         initVM()
                     }
              else {
                         // Fallback on earlier versions
                     }
        configrationTableView()
    }
    
    func configrationTableView(){
        photosTableV.separatorStyle = .none
        photosTableV.rowHeight = UITableView.automaticDimension
        photosTableV.estimatedRowHeight = 350.0
    }
    
    @available(iOS 13.0, *)
    func initVM() {
        self.progress.startAnimating()
        self.progress.isHidden = false
        self.photosTableV.isHidden = true

        viewModel.initProfile()
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }
        viewModel.hideImagesCollection = {
            self.photosTableV.isHidden = true
        }
        viewModel.showImagesCollection = {
            self.photosTableV.isHidden = false
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
                    self.photosTableV.isHidden = false
                case .loading:
                    self.progress.startAnimating()
                    self.progress.isHidden = false
                    self.photosTableV.isHidden = true
                case .populated:
                    self.progress.stopAnimating()
                    self.progress.isHidden = true
                    self.viewModel.ImagesCollectionDispaly()
                }
            }
        }
        viewModel.reloadImagesCollection = {
            self.photosTableV.reloadData()
        }
        
    }
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
}
extension HomeVC : UITableViewDelegate , UITableViewDataSource
{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getImagesCount() 
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let cellVM = viewModel.getCellViewModel( at: indexPath )
        cell.photocellVM = cellVM
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
}
