//
//  AlarmScheduler.swift
//  Ambiance
//
//  Created by Chihiro Saito on 11/22/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import Foundation
import UIKit

class AlarmScheduler: NSObject {
    
    var mainVc : UIViewController?
    let dayOfTheWeek = [
        "sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"
    ]
    
    let calendar = Calendar(identifier: .gregorian)
    var alarmObject: AlarmObject!
    
    override init() {
        super.init()
        // FIXME - sound file location needs to be set from Parse        
        self.alarmObject = AlarmObject(itemToPlay: URL(string:
            "https://dream-team-bucket.s3-us-west-1.amazonaws.com/music/morning-forest.mp3")!)
        self.alarmObject.addObserver(self, forKeyPath: "status", options: [.new], context: nil)
    }
    
    func scheduleNextAlarm() -> Date? {
        let nextAlarm = self.getNextDayAlarm(startingDate: Date())
        if let nextAlarm = nextAlarm {
            // FIXME - volume needs to come from Parse
            self.alarmObject.setVolumeIncreaseFeature(toMaxVolumeInMinutes: nextAlarm.1.alarmRiseDurationInMinutes, maxVolume: 1.0)
            self.alarmObject.setVolume(0.1)
            self.alarmObject.scheduleAt(when: nextAlarm.0)
            return nextAlarm.0
        }
        // Just for testing, start alarm in 20 seconds
        /**
        self.alarmObject.setVolumeIncreaseFeature(toMaxVolumeInMinutes: 3, maxVolume: 1.0)
        self.alarmObject.setVolume(0.1)
        let testDate = Date(timeIntervalSinceNow: TimeInterval(20));
        self.alarmObject.scheduleAt(when: testDate)
        return testDate
        **/
        return nil
    }
    
    // Observe for the Alarm status change.
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "status") {
            if let alarm = object as? AlarmObject {
                if (alarm == self.alarmObject) {
                    if alarm.status == AlarmObject.Status.started {
                        self.showAlarmOn(self.alarmObject)
                    }
                }
            }
        }
    }
    
    // Broadcast change
    func showAlarmOn(_ alarm: AlarmObject) {
        let alarmDict:[String: AlarmObject] = ["alarm": alarm]
        NotificationCenter.default.post(name: .alarmStartedNotification, object: nil, userInfo: alarmDict)
    }
    
    
    // Inspect the current user's AlarmSchedule, search for the next alarm that is scheduled,
    // and return it as an (alarm start Date, DayAlarm) pair, or nil if not found.
    func getNextDayAlarm(startingDate: Date) -> (Date, DayAlarm)? {
        let alarmSchedule = UserSession.shared.loggedInUser?.alarmSchedule
        if let alarmSchedule = alarmSchedule {
            
            // First check for the alarm that happens at startingDate.
            // Return it if it's in the future
            var dayIndex = self.getDayOfWeek(startingDate)! - 1
            let dayAlarm = alarmSchedule.getAlarm(for: self.dayOfTheWeek[dayIndex])
            if let dayAlarm = dayAlarm {
                let diffInMinutes = self.getDiffInMinutes(fromDate: startingDate, toAlarm: dayAlarm)
                if (diffInMinutes > 0) {
                    return (
                        startingDate.addingTimeInterval(TimeInterval(diffInMinutes * 60)),
                        dayAlarm)
                }
            }
            
            // Alarm for the startingDate is already done or missing.  Iterate through the week and get
            // the next DayAlarm to be scheduled
            var topOfTheDay = self.calendar.startOfDay(for: startingDate)
            var dayComponent = DateComponents()
            dayComponent.day = 1
            
            var i = 0;
            while (i < self.dayOfTheWeek.count) {
                dayIndex = (dayIndex+1 == self.dayOfTheWeek.count) ? 0 : dayIndex + 1
                topOfTheDay = self.calendar.date(byAdding: dayComponent, to: topOfTheDay)!
                let dayAlarm = alarmSchedule.getAlarm(for: self.dayOfTheWeek[dayIndex])
                if let dayAlarm = dayAlarm {
                    return (
                        topOfTheDay.addingTimeInterval(TimeInterval(dayAlarm.alarmStartTimeInMinutes * 60)),
                        dayAlarm)
                }
                i = i+1
            }
        }
        
        // No alarm schedule found for the entire week.
        return nil
    }
    
    // Returns true if date's hour/minutes is less than the dayAlarm's ambiant start time, false otherwise.
    private func isBefore(fromDate: Date, toAlarm: DayAlarm) -> Bool {
        let hour = self.calendar.component(.hour, from: fromDate)
        let minute = self.calendar.component(.minute, from: fromDate)
        return (hour * 60 + minute) < toAlarm.alarmStartTimeInMinutes
    }
    
    // Returns the difference in minutes between the given date/s hour/minutes and dayAlarm's minutes
    // by subtracting date's hour/minutes from the dayAlarm's ambient sound start time.
    private func getDiffInMinutes(fromDate: Date, toAlarm: DayAlarm) -> Int {
        let hour = self.calendar.component(.hour, from: fromDate)
        let minute = self.calendar.component(.minute, from: fromDate)
        return toAlarm.alarmStartTimeInMinutes - (hour * 60 + minute)
    }
    
    // Returns the weekday of the given Date, in [1-7], in which 1 is Sunday and 7 is Saturday.
    func getDayOfWeek(_ date: Date) -> Int? {
        let weekDay = self.calendar.component(.weekday, from: date)
        return weekDay
    }
    
}


extension Notification.Name {
    static let alarmStartedNotification = Notification.Name("alarmStarted")
}
