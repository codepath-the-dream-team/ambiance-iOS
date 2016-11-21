//
//  WakeUpPresenter.swift
//  Ambiance
//
//  Created by Matthew Carroll on 11/20/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import Foundation

class WakeUpPresenter {
    
    public func createWakeUpClockViewModel() -> WakeUpClockViewModel {
        return WakeUpClockViewModel(time: "--:--", amPm: AmPm.am, message: NSAttributedString(string: "No Alarm Scheduled."))
    }
    
    public func createWakeUpDayViewModel(dayIndex: Int) -> WakeUpDayListItemViewModel {
        
        // Pass AlarmSchedule in constructor.
        let alarmSchedule = User.currentUser!.alarmSchedule
        
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
        
        let startRiseTime = getStartRiseTime(alarm: alarm)
        let finishRiseTime = getFinishRiseTime(alarm: alarm)
        
        return WakeUpDayListItemViewModel(dayName: dayName, isEnabled: nil != alarm, startRiseTime: startRiseTime, finishRiseTime: finishRiseTime)
    }
    
    private func getStartRiseTime(alarm: DayAlarm?) -> String {
        if let alarm = alarm {
            let riseStartInMinutes = alarm.alarmTimeInMinutes - alarm.alarmRiseDurationInMinutes
            let hourCount = riseStartInMinutes / 60
            let minuteCount = riseStartInMinutes % 60
            
            return getTime(fromHours: hourCount, andMinutes: minuteCount)
        } else {
            return ""
        }
    }
    
    private func getFinishRiseTime(alarm: DayAlarm?) -> String {
        if let alarm = alarm {
            let hourCount = alarm.alarmTimeInMinutes / 60
            let minuteCount = alarm.alarmTimeInMinutes % 60
            
            return getTime(fromHours: hourCount, andMinutes: minuteCount)
        } else {
            return ""
        }
    }
    
    private func getTime(fromHours hours: Int, andMinutes minutes: Int) -> String {
        let amPm = hours >= 12 ? "pm" : "am"
        
        return String.init(format: "%02d:%02d%@", hours, minutes, amPm)
    }
}
