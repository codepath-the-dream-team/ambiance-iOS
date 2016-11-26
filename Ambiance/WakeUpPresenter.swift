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
