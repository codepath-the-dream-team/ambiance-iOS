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
    
    public func getNextAlarm() -> (String, DayAlarm)? {
        let next7Days = getNext7Days()
        
        var alarmThatAlreadyPassedToday: (String, DayAlarm)?
        for day in next7Days {
            let alarmForDay = getAlarm(for: day)
            if let alarmForDay = alarmForDay {
                if isToday(day: day) {
                    if isAlarmInTheFuture(dayOfWeek: day, dayAlarm: alarmForDay) {
                        // Found an Alarm scheduled for later today. Return it.
                        return (day, alarmForDay)
                    } else {
                        // Store a reference to today's alarm that already passed. If we
                        // don't find any other alarm then we'll use this one.
                        alarmThatAlreadyPassedToday = (day, alarmForDay)
                    }
                } else {
                    // Found an Alarm scheduled after today. Return it.
                    return (day, alarmForDay)
                }
            }
        }
        
        // If we've gotten down here then it means we didn't find a scheduled Alarm
        // any time in the next 7 days.  The only possibility that we haven't considered
        // yet is an alarm that is scheduled today, but has already passed.  We didn't
        // want to select this alarm initially because its only in the "future" if no
        // other Alarm is scheduled.  But we didn't find any other Alarm so now we'll
        // check to see if there is an alarm scheduled for earlier today.  If so, we'll
        // treat it as a future alarm 7 days from now.
        if let alarmThatAlreadyPassedToday = alarmThatAlreadyPassedToday {
            return alarmThatAlreadyPassedToday
        }
        
        
        return nil
    }
    
    private func getNext7Days() -> [String] {
        // List of the next 7 days (starting with today).
        var next7Days:[String] = []
        
        // The Date that we cycle through 7 days, starting with today.
        var date = Date()
        
        // Cycle through the next 7 days and store their names in a list.
        for _ in 0...7 {
            let dayOfWeek = Calendar.current.component(.weekday, from: date)
            
            switch dayOfWeek {
            case 1:
                next7Days.append("sunday")
                break
            case 2:
                next7Days.append("monday")
                break
            case 3:
                next7Days.append("tuesday")
                break
            case 4:
                next7Days.append("wednesday")
                break
            case 5:
                next7Days.append("thursday")
                break
            case 6:
                next7Days.append("friday")
                break
            case 7:
                next7Days.append("saturday")
                break
            default:
                break
            }
            
            // Add a day to the Date
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        }
        
        return next7Days
    }
    
    private func isToday(day: String) -> Bool {
        let dayOfWeek = Calendar.current.component(.weekday, from: Date())
        
        switch dayOfWeek {
        case 1:
            return "sunday" == day
        case 2:
            return "monday" == day
        case 3:
            return "tuesday" == day
        case 4:
            return "wednesday" == day
        case 5:
            return "thursday" == day
        case 6:
            return "friday" == day
        case 7:
            return "saturday" == day
        default:
            return false
        }
    }
    
    private func isAlarmInTheFuture(dayOfWeek: String, dayAlarm: DayAlarm) -> Bool {
        if isToday(day: dayOfWeek) {
            // This Alarm is scheduled for today. If it's scheduled later than "now"
            // then its in the future, otherwise its in the past.
            let alarmTimeInMinutes = (dayAlarm.alarmTimeHours * 60) + dayAlarm.alarmTimeMinutes
            
            let now = Date()
            let nowTimeInMinutes = (Calendar.current.component(.hour, from: now) * 60) + Calendar.current.component(.minute, from: now)
            
            return alarmTimeInMinutes > nowTimeInMinutes
        } else {
            // We consider any Alarm that isn't scheduled for today as being schedule
            // in the future. For example, if today is Monday and there is an Alarm
            // scheduled for Sunday, we consider that Alarm to be scheduled 6 days in
            // the future rather than 1 day in the past.
            return true
        }
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
