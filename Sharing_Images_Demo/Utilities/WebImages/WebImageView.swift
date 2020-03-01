//
//  WebImageView.swift
//  Cars
//
//  Created by Khaled on 5/5/17.
//  Copyright © 2017 Khaled. All rights reserved.
//

import UIKit


extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}

extension UIImage {
    
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    func toData() -> Data? {
        return self.pngData()
    }
    
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return  self.jpegData(compressionQuality: jpegQuality.rawValue)
    }
    
}

extension Data {
    func sizeWithMega()-> String{
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
        bcf.countStyle = .file
        let size = bcf.string(fromByteCount: Int64(self.count))
        return size
    }
}

