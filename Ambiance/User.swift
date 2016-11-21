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
    
    init(parseUser: PFUser) {
        NSLog("Creating a new User from Parse User: \(parseUser)")
        self.parseUser = parseUser
    }
}
