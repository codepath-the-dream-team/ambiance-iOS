//
//  User.swift
//  Ambiance
//
//  Created by Ryan Chee on 11/14/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit
import Parse

class User: NSObject {
//    var firstName: String?
//    var lastName: String?
//    var email: String?
//    var id: String?
//    var profileImageURL: URL?
//    var dicitonary: NSDictionary
//    var alarmSchedule: AlarmSchedule?
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
//            if _currentUser == nil {
//                let defaults = UserDefaults.standard
//                let userData = defaults.object(forKey: "currentUser") as? Data
//                
//                if let userData = userData {
//                    let dictionary = try! JSONSerialization.jsonObject(with: userData as Data, options: []) as! NSDictionary
//                    _currentUser =  User(dicitonary: dictionary)
//                }
//            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
//            let defaults = UserDefaults.standard
//            if let user = user {
//                let data = try! JSONSerialization.data(withJSONObject: user.dicitonary, options: [])
//                defaults.set(data, forKey: "currentUser")
//            } else {
//                defaults.set(nil, forKey: "currentUser")
//            }
//            defaults.synchronize()
        }
    }
    
    public var firstName: String {
        get {
            return parseUser.value(forKey: "firstName") as! String
        }
    }
    
    public var lastName: String {
        get {
            return parseUser.value(forKey: "lastName") as! String
        }
    }
    
    public var email: String {
        get {
            return parseUser.value(forKey: "email") as! String
        }
    }
    
    public var profileImageUrl: URL? {
        get {
            let avatarUrl = parseUser.value(forKey: "imageURLString") as! String?
            if let avatarUrl = avatarUrl {
                return URL(string: avatarUrl)
            } else {
                return nil
            }
        }
    }
    
    public var alarmSchedule: AlarmSchedule {
        get {
            let pfSchedule = parseUser["alarmSchedule"] as! PFObject
            NSLog("pfSchedule: \(pfSchedule)")
            
            let schedule = AlarmSchedule(pfObject: pfSchedule)!
            NSLog("AlarmSchedule: \(schedule)")
            
            return schedule
        }
    }
    
    
    private var parseUser: PFUser!

//    init(dicitonary: NSDictionary) {
//        self.dicitonary = dicitonary
//        let picture:[String:AnyObject] = dicitonary["picture"] as! [String : AnyObject]
//        let imageData:[String:AnyObject] = picture["data"] as! [String : AnyObject]
//        firstName = dicitonary["first_name"] as? String
//        lastName = dicitonary["last_name"] as? String
//        email = dicitonary["email"] as? String
//        id = dicitonary["id"] as? String
//        alarmSchedule = AlarmSchedule()
//        alarmSchedule?.dictionary = dicitonary["alarmSchedule"] as! [String:Array<Alarm>]
//        print("alarm sched: \(alarmSchedule)")
//        let profileURLString = imageData["url"] as? String
//        if let profileURLString = profileURLString {
//            profileImageURL = URL(string: profileURLString)
//        }
//    }
    
    init(parseUser: PFUser) {
        NSLog("Creating a new User from Parse User: \(parseUser)")
        self.parseUser = parseUser
    }
}
