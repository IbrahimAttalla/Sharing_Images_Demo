//
//  ProfileViewModel.swift
//  Sharing_Images_Demo
//
//  Created by it thinkers on 2/29/20.
//  Copyright © 2020 ibrahim-attalla. All rights reserved.
//

import Foundation
import Firebase


enum APIError: String, Error {
    case noNetwork = "No Network"
    case serverOverload = "Server is overloaded"
    case permissionDenied = "You don't have permission"
    case noSimilarData = " no similar data founed "
    
}

let DB_BASE = Database.database().reference()
var USER_EMAIL = "email"
var USER_PROFILE_IMG = "profileIMG"



protocol APILoginServiceProtocol {
    func login(email:String , password:String, complete: @escaping (_ success:Bool?, _ serverError:String?)->() )
}

protocol APIRegisterServiceProtocol {
    func register(email:String , password:String, complete: @escaping (_ success:Bool?, _ serverError:String?)->() )
}

protocol APIProfileServiceProtocol {
    func getUserData( withUserId userId:String , complete: @escaping ( _ user:User? , _ serverError:String?)->() )
    func getUserImages( withUserId userId:String , complete: @escaping (_ imags:[UserImages], _ serverError:String?)->() )
    
    func saveProfileImage( withUserId userId:String ,imgUrl:String, complete: @escaping (_ success:Bool?, _ serverError:String?)->() )
    
    func updateImageStatus(imageId:String , imageStatus :Bool, complete: @escaping (_ success:Bool?, _ serverError:String?)->())
    
}

protocol APISharingServiceProtocol {
    
    func postImages(withUserId userId: String , imgUrl:String,sharing:Bool ,user:User, complete: @escaping (_ success:Bool?, _ serverError:String?)->() )
}

protocol APIHomeServiceProtocol {
    func getHomeImages(  complete: @escaping (_ imags:[UserImages], _ serverError:String?)->() )
    
}


// MARK:- Login Gateway class

class AuthGateway: APILoginServiceProtocol {
    
    func login(email:String , password:String,complete: @escaping (_ success:Bool?, _ serverError:String?) -> ()) {
        
        
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            
            if error != nil {
                print("login error == > " , error!)
                complete(false,error!.localizedDescription)
                return
            }
            complete(true, nil)
        }
    }
    
    
}




// MARK:- Register Getway class

class RegisterGetway: APIRegisterServiceProtocol {
    
    func  register(email:String , password:String,complete: @escaping (_ success:Bool?, _ serverError:String? ) -> ())  {
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            guard let user = authResult?.user else {
                complete(false, error!.localizedDescription)
                return
            }
            
            let userData = ["provider": user.providerID, "email": user.email]
            //             to create a user
            DataService.instance.createDBUser(uid: user.uid , userData: userData)
            complete(true, nil)
        }
        
    }
    
    
}



// MARK:- Profile Getway class

class ProfileGetway: APIProfileServiceProtocol {
    func updateImageStatus(imageId: String, imageStatus: Bool, complete: @escaping (Bool?, String?) -> ()) {
        print("good")
    }
    
    
    
    
    
    static  var _REF_USERS = DB_BASE.child("users")
    var REF_BASE: DatabaseReference {
        return ProfileGetway._REF_USERS
    }
    
    static var _REF_IMAGES = DB_BASE.child("images")
    var REF_FEED: DatabaseReference {
        return ProfileGetway._REF_IMAGES
    }
    
    
    func getUserData(withUserId userId: String, complete: @escaping ( _ user:User? , _ serverError:String?) -> ()) {
        
        ProfileGetway._REF_USERS.observe( .value) { (profileSnapShot) in
            print("profileSnapShot   " , profileSnapShot)
            guard let result = profileSnapShot.value as? [String: Any]
                else {
                    complete(nil,nil)
                    return
            }
            
            print("result = profileSnapShot = ",result)
            let userObj = result[userId] as? [String: Any]
            print("userObj " , userObj)
            let userEmail = userObj?[USER_EMAIL] as? String
            let profileImage = userObj?[USER_PROFILE_IMG] as? String
            let user = User(name: userEmail, profileImgUrl: profileImage, Album: nil)
            complete(user ,nil )
            
            
        }
    }
    
    func getUserImages(withUserId userId: String, complete: @escaping ([UserImages], String?) -> ()) {
        
       
        ProfileGetway._REF_IMAGES.observe(.value) { (imagesSnapShot) in
            print("imagesSnapShot == ppp ", imagesSnapShot)
            guard let imagesSnapShot = imagesSnapShot.children.allObjects as? [DataSnapshot] else {
                return
                
            }
            var imagesArr = [UserImages]()

            // to get all data about each group
            for image in imagesSnapShot{
                
                if image.childSnapshot(forPath: "ownerId").value as! String == userId{
                    print("imageId yes ", image )
                    let imageId = image.key
                    let imageownerId = image.childSnapshot(forPath: "ownerId").value as! String
                    let imageUrl = image.childSnapshot(forPath: "imgUrl").value as! String
                    let imageSharing = image.childSnapshot(forPath: "sharing").value as! Bool
                    let userIamge = UserImages(id: imageId, ownerId: imageownerId, imgUrl: imageUrl, sharing: imageSharing)
                    imagesArr.insert(userIamge, at: 0)
                }
            }
            complete(imagesArr, nil)
            
        }
        
    }
    
    func saveProfileImage(withUserId userId: String,imgUrl:String, complete: @escaping (Bool?, String?) -> ()) {
        ProfileGetway._REF_USERS.child(Auth.auth().currentUser!.uid).child(USER_PROFILE_IMG).setValue(imgUrl)
        complete(true,nil)
    }
    
    
    
}


// MARK:- Sharing Getway class
class SharingGetway: APISharingServiceProtocol {
    
    static  var _REF_USERS = DB_BASE.child("users")
    var REF_BASE: DatabaseReference {
        return ProfileGetway._REF_USERS
    }
    
    static var _REF_IMAGES = DB_BASE.child("images")
    var REF_FEED: DatabaseReference {
        return ProfileGetway._REF_IMAGES
    }
    
    func postImages(withUserId userId: String, imgUrl: String, sharing: Bool,user:User, complete: @escaping (Bool?, String?) -> ()) {
        let imageData : [String:Any] = ["ownerId":userId,"imgUrl":imgUrl,"sharing":sharing,"ownerImg":user.profileImgUrl,"ownerName":user.name] as [String : Any]
        //        ProfileGetway._REF_IMAGES.updateChildValues(imageData)
        ProfileGetway._REF_IMAGES.childByAutoId().updateChildValues(imageData)
        complete(true,nil)
        
    }
    
}


// MARK:- Profile Getway class

class HomeGetway: APIHomeServiceProtocol {
    
    
    
    static  var _REF_USERS = DB_BASE.child("users")
    var REF_BASE: DatabaseReference {
        return ProfileGetway._REF_USERS
    }
    
    static var _REF_IMAGES = DB_BASE.child("images")
    var REF_FEED: DatabaseReference {
        return ProfileGetway._REF_IMAGES
    }
    
    
    
    func getHomeImages( complete: @escaping ([UserImages], String?) -> ()) {
        
        //              ProfileGetway._REF_IMAGES.queryOrdered(byChild: "id").queryEqual(toValue: imageId)
        ProfileGetway._REF_IMAGES.observe(.value) { (imagesSnapShot) in
            print("imagesSnapShot == ", imagesSnapShot)
            guard let imagesSnapShot = imagesSnapShot.children.allObjects as? [DataSnapshot]
                else {return}
            var imagesArr = [UserImages]()

            for image in imagesSnapShot{
                
                if image.childSnapshot(forPath: "sharing").value as! Bool == true {
                    print("image for  public  == ", image )
                    let imageId = image.key
                    let imageownerId = image.childSnapshot(forPath: "ownerId").value as! String
                    let imageUrl = image.childSnapshot(forPath: "imgUrl").value as! String
                    let imageSharing = image.childSnapshot(forPath: "sharing").value as! Bool
                    let ownerImg = image.childSnapshot(forPath: "ownerImg").value as? String
                    let ownerName = image.childSnapshot(forPath: "ownerName").value as? String
                    
                    let userIamge = UserImages(id: imageId, ownerId: imageownerId, imgUrl: imageUrl, sharing: imageSharing,ownerName:ownerName, ownerImg:ownerImg )
                    imagesArr.insert(userIamge, at: 0)
                }
            }
            complete(imagesArr, nil)
            
        }
        
    }
    
    
    
}
