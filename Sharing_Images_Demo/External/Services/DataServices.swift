
//
//  DataService.swift
//  Sharing_Images_Demo
//
//  Created by it thinkers on 2/28/20.
//  Copyright © 2020 ibrahim-attalla. All rights reserved.
//

import Foundation
import Firebase
import SVProgressHUD



//let DB_BASE = Database.database().reference()

class DataService {
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_GROUPS = DB_BASE.child("groups")
    private var _REF_FEED = DB_BASE.child("images")
    
    
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_GROUPS: DatabaseReference {
        return _REF_GROUPS
    }
    
    var REF_FEED: DatabaseReference {
        return _REF_FEED
    }
    
    
    
    
    
    //MARK: - all firebase
    
    //   to create a user
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    
    
    
    
    // here we thing what is the post shouldm have
//  1 message
//  2 each post
//  3 each user who post it
//  4 if this message is posting to  publicFeed or to group

    
    func upLoadPost(withMessage message:String , forUID uid:String , withGroupKey groupKey:String? , sendCompletion: @escaping (_ status:Bool)->() ){
        SVProgressHUD.show()
        if groupKey != nil{
            // if this func have the groupkey as a parameter the message will passed to groups view
             // send to group
            
            REF_GROUPS.child(groupKey!).child("messages").childByAutoId().updateChildValues(["content" : message , "sendID":  uid])
            SVProgressHUD.dismiss()
            sendCompletion(true)
        }else{
            
            // if this func don't have the groupkey as a parameter the message will passed to feed view
            
            // this will generate a unique id for evey message and update this chiled value
            // and here the message that go need to things  1 the content   2 the send id
            
            REF_FEED.childByAutoId().updateChildValues(["content" : message , "sendID":  uid])
            // and then call completionhandler
            sendCompletion(true)
            SVProgressHUD.dismiss()
        }
        
        
    }
    
    
    
    
    
     /*
    // get feed messages
    func getAllFeedMessage(handler:@escaping (_ message:[Message])->()){
        SVProgressHUD.show()
//        var messageArray = [Message]()
//        to obserev and get all data form feed table at fireabse
        
//        REF_FEED.child(<#T##pathString: String##String#>)
        REF_FEED.observeSingleEvent(of: .value) { (feedMessageSnapShot) in
            guard let feedMessageSnapShot = feedMessageSnapShot.children.allObjects as? [DataSnapshot] else{return}
            for message in feedMessageSnapShot {
                let content = message.childSnapshot(forPath: "content").value as! String
                let senderID = message.childSnapshot(forPath: "sendID").value as! String
                
                let message = Message(content: content, senderID: senderID)
                messageArray.append(message)
            }
            handler(messageArray)
        }
        SVProgressHUD.dismiss()
    }
    
    */
    
    
    
    // to get user name or email throw the id
    func getUserName(forUID uid:String , handler: @escaping (_ userName :String)->()){
        REF_USERS.observeSingleEvent(of: .value) { (userSnapShot) in
            guard let userSnapShot = userSnapShot.children.allObjects as? [DataSnapshot] else {return}
            
            for user in userSnapShot {
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "email").value as! String)
                }
            }
        }
    }
    
    
    
    
    
//    to search for user to add them to group
    func getEmail(forSearchQuery query: String , handler : @escaping( _ emailArray:[String])->() ){
        var emailArray = [String]()
        REF_USERS.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                let email = user.childSnapshot(forPath: "email").value as! String
                
                if email.contains(query) == true && email != Auth.auth().currentUser?.email {
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }
    
    
    
    
    // to get the id from user email that selected
    func getIDS(forUserNames userNames: [String] , handler :@escaping (_ uidArray: [String])->() ){
        REF_USERS.observe(.value) { (userSnapShot) in
            var idArray = [String]()
            guard let userSnapShot = userSnapShot.children.allObjects as? [DataSnapshot] else{return}
            for user in userSnapShot {
                let email = user.childSnapshot(forPath: "email").value as! String
                if userNames.contains(email){
                    idArray.append(user.key)
                }
            }
            handler(idArray)
        }
    }
    
    
    
    
    
//     to create agroup
    func createGroup(wihtTitle title:String , andDescription description :String , forUserIDs ids:[String] , handler:@escaping ( _ groupCreated:Bool)->()){
        
        REF_GROUPS.childByAutoId().updateChildValues(["title": title , "description" : description ,"member": ids])
        handler(true )
    }
    
    
    
    
    /*
     
    // to get all groups from fireBase ......
    
    func getAllGroups(handler:@escaping(_ groupArray:[Group])->()){
        // this array for pass it again to the completion handler
        var groupArray = [Group]()
        // to get all data from group table at firebase
        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapShot) in
            // caseting this data to DataSnapshot to work on it's data
            guard let groupSnapShot = groupSnapShot.children.allObjects as? [DataSnapshot] else {return}
            
            // to get all data about each group
            for group in groupSnapShot{
                // get all member from this group table at column "member"
                let memberArray  = group.childSnapshot(forPath: "member").value as! [String]
                // to get all groups all i'm one fo it's members throught my id at fireBase
                if memberArray.contains((Auth.auth().currentUser?.uid)!){
                    let title  = group.childSnapshot(forPath: "title").value as! String
                    let description = group.childSnapshot(forPath: "description").value as! String
                    let key = group.key
                    // from group model passign this data
                    let thisGroup  = Group(title: title, description: description, key: key, memberCount: memberArray.count, members: memberArray)
                    groupArray.append(thisGroup)
                }
            }
//            and passing the groupArry at the end of the observer of fireBase
            handler(groupArray)
        }
        
    }
 
     */
    
    
    
    
    // to get the group members throught ids
    
    func getGroupMembers(forUserIds userIds: [String] , handler :@escaping (_ userNameArray: [String])->() ){
        REF_USERS.observe(.value) { (userSnapShot) in
            var userArray = [String]()
            guard let userSnapShot = userSnapShot.children.allObjects as? [DataSnapshot] else{return}
            for user in userSnapShot {
                if userIds.contains(user.key){
                    let email = user.childSnapshot(forPath: "email").value as! String
                    userArray.append(email)
                }
            }
            handler(userArray)
        }
    }
    
    
   /*
     
// get all group  message
    func getGroupMessages( selectedGroup: Group , handler: @escaping (_ messageArray:[Message])->()){
        
      var groupMessagearray = [Message]()
        REF_GROUPS.child(selectedGroup.key).child("messages").observe(.value) { (groupMessageSnapShot) in
            guard let groupMessageSnapShot = groupMessageSnapShot.children.allObjects as? [DataSnapshot] else {return}
            for chatMessage in groupMessageSnapShot{
                
                let content = chatMessage.childSnapshot(forPath: "content").value as! String
                let senderID = chatMessage.childSnapshot(forPath: "sendID").value as! String
                let groupMessage =  Message(content: content, senderID: senderID)
                groupMessagearray.append(groupMessage)
                
            }
            handler(groupMessagearray)
        }
    }
    */
    
    // to get the provider
    
    func getUserProvider(forUID uid:String , handler: @escaping (_ userProvider :String)->()){
        REF_USERS.observeSingleEvent(of: .value) { (userSnapShot) in
            guard let userSnapShot = userSnapShot.children.allObjects as? [DataSnapshot] else {return}
            
            for user in userSnapShot {
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "provider").value as! String)
                }
            }
        }
    }

    
    
    
    
}





