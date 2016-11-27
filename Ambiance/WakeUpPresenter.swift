//
//  WakeUpPresenter.swift
//  Ambiance
//
//  Created by Matthew Carroll on 11/20/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import Foundation
import UIKit

class WakeUpPresenter {
    
    public func createWakeUpClockViewModel(alarmSchedule: AlarmSchedule, riseTimeInMinutes: Int) -> WakeUpClockViewModel {
        let nextAlarm = getNextAlarm(alarmSchedule: alarmSchedule)
        
        if let nextAlarm = nextAlarm {
            var hours = nextAlarm.1.alarmTimeHours % 12
            hours = 0 == hours ? 12 : hours
            let timeDisplay = String.init(format: "%d:%02d", hours, nextAlarm.1.alarmTimeMinutes)
            let amPm = nextAlarm.1.alarmTimeHours >= 12 ? AmPm.pm : AmPm.am
            
            let alarmMessage = createAlarmMessage(nextAlarmDay: nextAlarm.0, nextAlarm: nextAlarm.1, riseTimeInMinutes: riseTimeInMinutes)
            
            return WakeUpClockViewModel(time: timeDisplay, amPm: amPm, message: alarmMessage)
        } else {
            return WakeUpClockViewModel(time: "--:--", amPm: AmPm.am, message: NSAttributedString(string: "No Alarm Scheduled."))
        }
    }
    
    private func getNextAlarm(alarmSchedule: AlarmSchedule) -> (String, DayAlarm)? {
        let next7Days = getNext7Days()
        
        var alarmThatAlreadyPassedToday: (String, DayAlarm)?
        for day in next7Days {
            let alarmForDay = alarmSchedule.getAlarm(for: day)
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
    
    private func createAlarmMessage(nextAlarmDay: String, nextAlarm: DayAlarm, riseTimeInMinutes: Int) -> NSAttributedString {
        // Time to alarm description
        var timeToAlarm = ""
        var alarmDate = getDateFor(nextDay: nextAlarmDay, alarm: nextAlarm)!
        alarmDate = Calendar.current.date(bySettingHour: nextAlarm.alarmTimeHours, minute: nextAlarm.alarmTimeMinutes, second: 0, of: alarmDate)!
        let now = Date()
        
        var secondsToAlarm = Int(alarmDate.timeIntervalSince(now))
        
        let secondsPerDay = 24 * 60 * 60
        let daysToAlarm = secondsToAlarm / secondsPerDay
        secondsToAlarm -= daysToAlarm * secondsPerDay
        
        let secondsPerHour = 60 * 60
        let hoursToAlarm = secondsToAlarm / secondsPerHour
        secondsToAlarm -= hoursToAlarm * secondsPerHour
        
        let secondsPerMinute = 60
        let minutesToAlarm = secondsToAlarm / secondsPerMinute
        
        if daysToAlarm > 0 {
            if daysToAlarm == 1 {
                timeToAlarm += "1 day, "
            } else {
                timeToAlarm += "\(daysToAlarm) days, "
            }
        }
        
        if hoursToAlarm > 0 {
            if hoursToAlarm == 1 {
                timeToAlarm += "1 hour, "
            } else {
                timeToAlarm += "\(hoursToAlarm) hours, "
            }
        }
        
        if minutesToAlarm == 1 {
            timeToAlarm += "1 minute"
        } else {
            timeToAlarm += "\(minutesToAlarm) minutes"
        }
        
        // Time to rise desciption
        var riseTime = ""
        if (riseTimeInMinutes >= 60) {
            let hours = riseTimeInMinutes / 60
            let minutes = riseTimeInMinutes % 60
            
            riseTime = "\(hours) hour"
            if minutes > 0 {
                riseTime += " \(minutes) minute"
            }
            riseTime += " rise"
        } else {
            riseTime = "\(riseTimeInMinutes) minute rise"
        }
        
        
        let mutableAttString = NSMutableAttributedString(string: "You will wake up in \(timeToAlarm) with a \(riseTime).")
        
        // Make the timeToAlarm text white.
        mutableAttString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: mutableAttString.mutableString.range(of: timeToAlarm))
        
        // Make the risetime text white.
        mutableAttString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: mutableAttString.mutableString.range(of: riseTime))
        
        return mutableAttString
    }
    
    private func getDateFor(nextDay: String, alarm: DayAlarm) -> Date? {
        let next7Days = getNext7Days()
        var didAlarmAlreadyPassToday: Bool = false
        var date = Date()
        
        for day in next7Days {
            if day == nextDay {
                if isToday(day: day) {
                    if isAlarmInTheFuture(dayOfWeek: day, dayAlarm: alarm) {
                        // Found an Alarm scheduled for later today. Return today.
                        return date
                    } else {
                        // Found an Alarm that already passed today. Mark it as found
                        // just in case its the only alarm scheduled.
                        didAlarmAlreadyPassToday = true
                    }
                } else {
                    // Found an Alarm scheduled after today. Return it.
                    return date
                }
            }
            
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        }
        
        // If we've gotten down here then it means we didn't find a scheduled Alarm
        // any time in the next 7 days.  The only possibility that we haven't considered
        // yet is an alarm that is scheduled today, but has already passed.  We didn't
        // want to select this alarm initially because its only in the "future" if no
        // other Alarm is scheduled.  But we didn't find any other Alarm so now we'll
        // check to see if there is an alarm scheduled for earlier today.  If so, we'll
        // treat it as a future alarm 7 days from now.
        if didAlarmAlreadyPassToday {
            return date
        }
        
        return nil
    }
    
    public func createWakeUpDayViewModel(dayIndex: Int) -> WakeUpDayListItemViewModel {
        
        // TODO: Pass AlarmSchedule in constructor.
        let alarmSchedule = UserSession.shared.loggedInUser!.alarmSchedule
        
        var dayName = "_"
        var alarm: DayAlarm?
        switch (dayIndex) {
        case 0:
            dayName = "Monday"
            alarm = alarmSchedule.getAlarm(for: "monday")
            break
        case 1:
            dayName = "Tuesday"
            alarm = alarmSchedule.getAlarm(for: "tuesday")
            break
        case 2:
            dayName = "Wednesday"
            alarm = alarmSchedule.getAlarm(for: "wednesday")
            break
        case 3:
            dayName = "Thursday"
            alarm = alarmSchedule.getAlarm(for: "thursday")
            break
        case 4:
            dayName = "Friday"
            alarm = alarmSchedule.getAlarm(for: "friday")
            break
        case 5:
            dayName = "Saturday"
            alarm = alarmSchedule.getAlarm(for: "saturday")
            break
        case 6:
            dayName = "Sunday"
            alarm = alarmSchedule.getAlarm(for: "sunday")
            break
        default:
            break
        }
        
        let hasAlarm = alarm != nil
        NSLog("Creating day ViewModel. \(dayName): \(hasAlarm)")
        // TODO: REMOVE HARD CODED RISE TIME
        let startRiseTime = getStartRiseTime(alarm: alarm, riseTimeInMinutes: 30)
        let finishRiseTime = getFinishRiseTime(alarm: alarm)
        
        return WakeUpDayListItemViewModel(dayName: dayName, isEnabled: nil != alarm, startRiseTime: startRiseTime, finishRiseTime: finishRiseTime)
    }
    
    private func getStartRiseTime(alarm: DayAlarm?, riseTimeInMinutes: Int) -> String {
        if let alarm = alarm {
            let alarmTime = Calendar.current.date(bySettingHour: alarm.alarmTimeHours, minute: alarm.alarmTimeMinutes, second: 0, of: Date())!
            
            let riseTime = Calendar.current.date(byAdding: .minute, value: -riseTimeInMinutes, to: alarmTime)!
            
            let hours = Calendar.current.component(.hour, from: riseTime)
            let minutes = Calendar.current.component(.minute, from: riseTime)
            
            return getTime(fromHours: hours, andMinutes: minutes)
        } else {
            return ""
        }
    }
    
    private func getFinishRiseTime(alarm: DayAlarm?) -> String {
        if let alarm = alarm {
            return getTime(fromHours: alarm.alarmTimeHours, andMinutes: alarm.alarmTimeMinutes)
        } else {
            return ""
        }
    }
    
    private func getTime(fromHours hours: Int, andMinutes minutes: Int) -> String {
        let amPm = hours >= 12 ? "pm" : "am"
        
        return String.init(format: "%d:%02d%@", hours, minutes, amPm)
    }
}
