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
    
    init?(from dictionary: [String : Any]) {
        if dictionary.count > 0 {
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
        } else {
            return nil
        }
    }
    
    public func getAlarm(for day: String) -> DayAlarm? {
        return dayAlarms[day]
    }
    
    public func setAlarm(for day:String, alarm: DayAlarm?) {
        dayAlarms[day] = alarm
    }
    
    public func serializeToDictionary() -> [String : AnyObject] {
        var dictionary = [String : AnyObject]()
        
        dictionary["type"] = "AlarmSchedule" as AnyObject
        dictionary["aNumber"] = 5 as AnyObject
        
        for (day, dayAlarm) in dayAlarms {
            dictionary[day] = dayAlarm.serializeToDictionary() as AnyObject
        }
        
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
