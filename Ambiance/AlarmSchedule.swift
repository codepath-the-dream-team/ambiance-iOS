//
//  AlarmSchedule.swift
//  Ambiance
//
//  Created by Ryan Chee on 11/16/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//


import UIKit
import Parse

// Represents a week of daily alarm configurations.
class AlarmSchedule: NSObject {
    private var dayAlarms: [String: DayAlarm]
    
    override init() {
        dayAlarms = [String:DayAlarm]()
        super.init()
    }
    
    init?(dictionary: [String : Any]) {
        dayAlarms = [String:DayAlarm]()
        
        if let dayAlarmData: [String : AnyObject] = dictionary["monday"] as? [String : AnyObject] {
            dayAlarms["monday"] = DayAlarm(dictionary: dayAlarmData)
        }
        if let dayAlarmData: [String : AnyObject] = dictionary["tuesday"] as? [String : AnyObject] {
            dayAlarms["tuesday"] = DayAlarm(dictionary: dayAlarmData)
        }
        if let dayAlarmData: [String : AnyObject] = dictionary["wednesday"] as? [String : AnyObject] {
            dayAlarms["wednesday"] = DayAlarm(dictionary: dayAlarmData)
        }
        if let dayAlarmData: [String : AnyObject] = dictionary["thursday"] as? [String : AnyObject] {
            dayAlarms["thursday"] = DayAlarm(dictionary: dayAlarmData)
        }
        if let dayAlarmData: [String : AnyObject] = dictionary["friday"] as? [String : AnyObject] {
            dayAlarms["friday"] = DayAlarm(dictionary: dayAlarmData)
        }
        if let dayAlarmData: [String : AnyObject] = dictionary["saturday"] as? [String : AnyObject] {
            dayAlarms["saturday"] = DayAlarm(dictionary: dayAlarmData)
        }
        if let dayAlarmData: [String : AnyObject] = dictionary["sunday"] as? [String : AnyObject] {
            dayAlarms["sunday"] = DayAlarm(dictionary: dayAlarmData)
        }
    }
    
    init?(pfObject: PFObject) {
        dayAlarms = [String:DayAlarm]()
        
        if let dayAlarmData = pfObject.value(forKey: "monday") {
            dayAlarms["monday"] = DayAlarm(dictionary: dayAlarmData as! [String: Any])
        }
        if let dayAlarmData = pfObject.value(forKey: "tuesday") {
            dayAlarms["tuesday"] = DayAlarm(dictionary: dayAlarmData as! [String: Any])
        }
        if let dayAlarmData = pfObject.value(forKey: "wednesday") {
            dayAlarms["wednesday"] = DayAlarm(dictionary: dayAlarmData as! [String: Any])
        }
        if let dayAlarmData = pfObject.value(forKey: "thursday") {
            dayAlarms["thursday"] = DayAlarm(dictionary: dayAlarmData as! [String: Any])
        }
        if let dayAlarmData = pfObject.value(forKey: "friday") {
            dayAlarms["friday"] = DayAlarm(dictionary: dayAlarmData as! [String: Any])
        }
        if let dayAlarmData = pfObject.value(forKey: "saturday") {
            dayAlarms["saturday"] = DayAlarm(dictionary: dayAlarmData as! [String: Any])
        }
        if let dayAlarmData = pfObject.value(forKey: "sunday") {
            dayAlarms["sunday"] = DayAlarm(dictionary: dayAlarmData as! [String: Any])
        }
    }
    
    public func getAlarm(for day: String) -> DayAlarm? {
        return dayAlarms[day]
    }
    
    public func setAlarm(for day:String, alarm: DayAlarm?) {
        dayAlarms[day] = alarm
    }
    
    public func serializeToDictionary() -> [String : [String : Int]] {
        var dictionary = [String : [String : Int]]()
        
        dictionary["monday"] = dayAlarms["monday"]?.serializeToDictionary()
        dictionary["tuesday"] = dayAlarms["tuesday"]?.serializeToDictionary()
        dictionary["wednesday"] = dayAlarms["wednesday"]?.serializeToDictionary()
        dictionary["thursday"] = dayAlarms["thursday"]?.serializeToDictionary()
        dictionary["friday"] = dayAlarms["friday"]?.serializeToDictionary()
        dictionary["saturday"] = dayAlarms["saturday"]?.serializeToDictionary()
        dictionary["sunday"] = dayAlarms["sunday"]?.serializeToDictionary()
        
        return dictionary
    }
}

// Represents an alarm for a single day
class DayAlarm: NSObject {
    
    public let alarmTimeHours: Int // 24 hour format
    public let alarmTimeMinutes: Int
    
    init(alarmTimeHours: Int, alarmTimeMinutes: Int) {
        self.alarmTimeHours = alarmTimeHours
        self.alarmTimeMinutes = alarmTimeMinutes
    }
    
    init?(dictionary: [String : Any]) {
        let hours = dictionary["alarmTimeHours"] as? Int
        let minutes = dictionary["alarmTimeMinutes"] as? Int
        
        if let hours = hours, let minutes = minutes {
            self.alarmTimeHours = hours
            self.alarmTimeMinutes = minutes
        } else {
            return nil
        }
    }
    
    public func serializeToDictionary() -> [String : Int] {
        var dictionary = [String : Int]()
        
        dictionary["alarmTimeHours"] = alarmTimeHours
        dictionary["alarmTimeMinutes"] = alarmTimeMinutes
        
        return dictionary
    }
}
