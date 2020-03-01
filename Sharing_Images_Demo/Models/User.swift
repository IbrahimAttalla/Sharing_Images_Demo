//
//  User.swift
//  Sharing_Images_Demo
//
//  Created by it thinkers on 2/29/20.
//  Copyright © 2020 ibrahim-attalla. All rights reserved.
//

import Foundation
struct User{
    var name:String?
    var profileImgUrl:String?
    var Album:[UserImages]?
    
}

struct UserImages{
    var id:String?
    var ownerId:String?
    var imgUrl:String?
    var sharing:Bool?
    var ownerName:String?
    var ownerImg:String?
}
