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
    
    public static let NOTIFICATION_USER_CHANGE = Notification.Name("user_change")
    
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
    
    public var alarmConfiguration: AlarmConfiguration {
        get {
            let pfAlarmConfiguration = parseUser["alarmConfiguration"] as! [String : AnyObject]
            NSLog("pfAlarmConfiguration: \(pfAlarmConfiguration)")
            
            return AlarmConfiguration(from: pfAlarmConfiguration)!
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
    
    public var sleepConfiguration: SleepConfiguration {
        get {
            let pfSleepConfiguration = parseUser["sleepConfiguration"] as! [String : AnyObject]
            NSLog("pfSleepConfiguration: \(pfSleepConfiguration)")
            
            return SleepConfiguration(fromDictionary: pfSleepConfiguration)!
        }
    }
    
    private var parseUser: PFUser!
    
    init(parseUser: PFUser) {
        NSLog("Creating a new User from Parse User: \(parseUser)")
        self.parseUser = parseUser
    }
    
    public func save(alarmSchedule: AlarmSchedule, onComplete: @escaping (Error?) -> ()) {
        let parseAlarmSchedule = PFObject(className: "AlarmSchedule", dictionary: alarmSchedule.serializeToDictionary())
        
        parseUser.setObject(parseAlarmSchedule, forKey: "alarmSchedule")
        parseUser.saveInBackground { (success: Bool, error: Error?) in
            onComplete(error)
            
            // Broadcast that the User has changed.
            NSLog("User: Broadcasting NOTIFICATION_USER_CHANGE event.")
            NotificationCenter.default.post(Notification(name: User.NOTIFICATION_USER_CHANGE))
        }
    }
    
    public func save(alarmConfiguration: AlarmConfiguration, onComplete: @escaping (Error?) -> ()) {
        let alarmConfigurationDictionary = alarmConfiguration.serializeToDictionary()
        NSLog("Attempting to save Alarm Configuration: \(alarmConfigurationDictionary)")
        
        parseUser.setValue(alarmConfigurationDictionary, forKey: "alarmConfiguration")
        parseUser.saveInBackground { (success: Bool, error: Error?) in
            onComplete(error)
            
            // Broadcast that the User has changed.
            NSLog("User: Broadcasting NOTIFICATION_USER_CHANGE event.")
            NotificationCenter.default.post(Notification(name: User.NOTIFICATION_USER_CHANGE))
        }
    }
    
    public func save(sleepConfiguration: SleepConfiguration, onComplete: @escaping (Error?) -> ()) {
        let sleepConfigurationDictionary = sleepConfiguration.serializeToDictionary()
        NSLog("Attempting to save Sleep Configuration: \(sleepConfiguration)")
        
        parseUser.setValue(sleepConfigurationDictionary, forKey: "sleepConfiguration")
        parseUser.saveInBackground { (success: Bool, error: Error?) in
            onComplete(error)
            
            // Broadcast that the User has changed.
            NSLog("User: Broadcasting NOTIFICATION_USER_CHANGE event.")
            NotificationCenter.default.post(Notification(name: User.NOTIFICATION_USER_CHANGE))
        }
    }
}
