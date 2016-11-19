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
    var firstName: String?
    var lastName: String?
    var email: String?
    var id: String?
    var profileImageURL: URL?
    var dicitonary: NSDictionary
    var alarmSchedule: AlarmSchedule?
    static var _currentUser: User?

    init(dicitonary: NSDictionary) {
        self.dicitonary = dicitonary
        let picture:[String:AnyObject] = dicitonary["picture"] as! [String : AnyObject]
        let imageData:[String:AnyObject] = picture["data"] as! [String : AnyObject]
        firstName = dicitonary["first_name"] as? String
        lastName = dicitonary["last_name"] as? String
        email = dicitonary["email"] as? String
        id = dicitonary["id"] as? String
        alarmSchedule = AlarmSchedule()
        alarmSchedule?.dictionary = dicitonary["alarmSchedule"] as! [String:Array<Alarm>]
        print("alarm sched: \(alarmSchedule)")
        print("profile URL string is : \(imageData["url"])")
        let profileURLString = imageData["url"] as? String
        if let profileURLString = profileURLString {
            print("valid url string")
            profileImageURL = URL(string: profileURLString)
        }
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUser") as? Data
                
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData as Data, options: []) as! NSDictionary
                    _currentUser =  User(dicitonary: dictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dicitonary, options: [])
                defaults.set(data, forKey: "currentUser")
            } else {
                defaults.set(nil, forKey: "currentUser")
            }
            defaults.synchronize()
        }
    }
}
