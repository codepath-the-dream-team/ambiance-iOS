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
    var morningAlarmObject: AlarmObject!
    var nightAlarmObject: AlarmObject!
    var currentlyActiveNextSchedule: (Date, DayAlarm)?
    
    override init() {
        super.init()
        
        let alarmConfiguration = UserSession.shared.loggedInUser?.alarmConfiguration
        let sleepConfiguration = UserSession.shared.loggedInUser?.sleepConfiguration
        
        let morningAlarmUrl = alarmConfiguration != nil ? alarmConfiguration!.soundUri : "https://dream-team-bucket.s3-us-west-1.amazonaws.com/music/morning-forest.mp3"
        //let nightAlarmUrl = sleepConfiguration != nil ? sleepConfiguration!.soundUri : "https://dream-team-bucket.s3-us-west-1.amazonaws.com/music/babbling-brook.mp3"
        let nightAlarmUrl = "https://dream-team-bucket.s3-us-west-1.amazonaws.com/music/babbling-brook.mp3"
        
        self.morningAlarmObject = AlarmObject(itemToPlay: URL(string: morningAlarmUrl)!)
        self.morningAlarmObject.addObserver(self, forKeyPath: "status", options: [.old, .new], context: nil)
        if let alarmConfiguration = alarmConfiguration {
            self.applyAlarmConfiguration(self.morningAlarmObject, configuration: alarmConfiguration)
        }

        self.nightAlarmObject = AlarmObject(itemToPlay: URL(string: nightAlarmUrl)!)
        self.nightAlarmObject.addObserver(self, forKeyPath: "status", options: [.old, .new], context: nil)
        if let sleepConfiguration = sleepConfiguration {
            self.applySleepConfiguration(self.nightAlarmObject, configuration: sleepConfiguration)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.observeAlarmScheduleChange), name: .alarmScheduleUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.observeSleepConfigurationChange), name: .sleepConfigurationUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.observeAlarmConfigurationChange), name: .alarmConfigurationUpdated, object: nil)
    }
    
    deinit {
        self.morningAlarmObject.removeObserver(self, forKeyPath: "status")
        self.nightAlarmObject.removeObserver(self, forKeyPath: "status")
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func startNightAlarm() -> AlarmObject? {
        if self.isAlarmPlaying(morningAlarmObject) {
            print("Morning alarm in action, cannot start night alarm")
            return nil
        }
        let testDate = Date(timeIntervalSinceNow: TimeInterval(0.5))
        self.nightAlarmObject!.scheduleAt(when: testDate)
        return self.nightAlarmObject!
    }
    
    @objc func observeAlarmScheduleChange() {
        let newSchedule = getNextDayAlarm(startingDate: Date())
        if let newSchedule = newSchedule {
            if let currentSchedule = self.currentlyActiveNextSchedule {
                if newSchedule.1.alarmTimeHours != currentSchedule.1.alarmTimeHours ||
                    newSchedule.1.alarmTimeMinutes != currentSchedule.1.alarmTimeMinutes {
                    // There was already a scheduled alarm, but it's different from the new one,
                    // cancel and reschedule.
                    cancelNextAlarm()
                    _ = scheduleNextAlarm(at: newSchedule)
                }
            } else {
                // There is now an alarm to schedule, do it
                _ = scheduleNextAlarm(at: newSchedule)
            }
        }
    }
    
    @objc func observeSleepConfigurationChange() {
        let sleepConfiguration = UserSession.shared.loggedInUser?.sleepConfiguration
        if let sleepConfiguration = sleepConfiguration {
            applySleepConfiguration(self.nightAlarmObject, configuration: sleepConfiguration)
        }
    }
    
    @objc func observeAlarmConfigurationChange() {
        let alarmConfiguration = UserSession.shared.loggedInUser?.alarmConfiguration
        if let alarmConfiguration = alarmConfiguration {
            applyAlarmConfiguration(self.morningAlarmObject, configuration: alarmConfiguration)
            self.observeAlarmScheduleChange() // alarmRise change can trigger schedule change
        }
    }
    
    private func scheduleNextAlarm() -> Date? {
        let schedule = getNextDayAlarm(startingDate: Date())
        return scheduleNextAlarm(at: schedule)
    }
    
    private func scheduleNextAlarm(at: (Date, DayAlarm)?) -> Date? {
        self.currentlyActiveNextSchedule = at
        if let nextAlarm = self.currentlyActiveNextSchedule {
            self.morningAlarmObject.scheduleAt(when: nextAlarm.0)
            return nextAlarm.0
        }
        // Just for testing, start alarm in 5 seconds
        //let testDate = Date(timeIntervalSinceNow: TimeInterval(5));
        //self.morningAlarmObject.scheduleAt(when: testDate)
        //return testDate
        return nil
    }
    
    private func cancelNextAlarm() {
        self.morningAlarmObject.stop()
    }
    
    private func applySleepConfiguration(_ alarmObject: AlarmObject, configuration: SleepConfiguration) {
        alarmObject.setVolume(Float(configuration.volume) / 100)
        alarmObject.setDuration(configuration.playTimeInMinutes)
    }
    
    private func applyAlarmConfiguration(_ alarmObject: AlarmObject, configuration: AlarmConfiguration) {
        alarmObject.setVolumeIncreaseFeature(toMaxVolumeInMinutes: configuration.alarmRise, maxVolume: Float(configuration.alarmFinalVolume) / 100)
        alarmObject.setVolume(0.1)
    }
    
    // Observe for the Alarm status change.
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "status") {
            if let alarm = object as? AlarmObject {
                if let theChange = change as? [NSKeyValueChangeKey: Int] {
                    if let oldStatus = theChange[NSKeyValueChangeKey.oldKey],
                       let newStatus = theChange[NSKeyValueChangeKey.newKey] {
                        if (oldStatus != AlarmObject.Status.snoozing.rawValue && newStatus == AlarmObject.Status.started.rawValue) {
                            self.notifyAlarmStarted(alarm)
                        } else if((oldStatus == AlarmObject.Status.started.rawValue || oldStatus == AlarmObject.Status.snoozing.rawValue)
                            && newStatus == AlarmObject.Status.stopped.rawValue) {
                            self.notifyAlarmStopped(alarm)
                        }
                    }
                    
                    return
                }
    
            }
        }
    }
    
    // Broadcast change
    func notifyAlarmStarted(_ alarm: AlarmObject) {
        let alarmDict:[String: AlarmObject] = ["alarm": alarm]
        NotificationCenter.default.post(name: .alarmStartedNotification, object: nil, userInfo: alarmDict)
    }
    // Broadcast change
    func notifyAlarmStopped(_ alarm: AlarmObject) {
        let alarmDict:[String: AlarmObject] = ["alarm": alarm]
        NotificationCenter.default.post(name: .alarmStoppedNotification, object: nil, userInfo: alarmDict)
    }
    
    func isNightAlarm(_ alarm: AlarmObject) -> Bool {
        return alarm == self.nightAlarmObject
    }
    
    func isMorningAlarm(_ alarm: AlarmObject) -> Bool {
        return alarm == self.morningAlarmObject
    }
    
    func getActiveAlarm() -> AlarmObject? {
        if isAlarmPlaying(self.nightAlarmObject) {
            return self.nightAlarmObject
        }
        if isAlarmPlaying(self.morningAlarmObject) {
            return self.morningAlarmObject
        }
        return nil
    }
    
    // Inspect the current user's AlarmSchedule, search for the next alarm that is scheduled,
    // and return it as an (alarm start Date, DayAlarm) pair, or nil if not found.
    private func getNextDayAlarm(startingDate: Date) -> (Date, DayAlarm)? {
        let alarmSchedule = UserSession.shared.loggedInUser?.alarmSchedule
        let alarmConfiguration = UserSession.shared.loggedInUser?.alarmConfiguration
        if let alarmSchedule = alarmSchedule,
            let alarmConfiguration = alarmConfiguration {
            
            let riseTime = alarmConfiguration.alarmRise // Need to subtract this ambient sound time from target alarm's time
            
            // First check for the alarm that happens at startingDate.
            // Return it if it's in the future
            var dayIndex = self.getDayOfWeek(startingDate)! - 1
            let dayAlarm = alarmSchedule.getAlarm(for: self.dayOfTheWeek[dayIndex])
            if let dayAlarm = dayAlarm {
                let diffInMinutes = self.getDiffInMinutes(fromDate: startingDate, toAlarm: dayAlarm)
                if (diffInMinutes > 0) {
                    return (
                        startingDate.addingTimeInterval(TimeInterval((diffInMinutes - riseTime) * 60)),
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
                        topOfTheDay.addingTimeInterval(TimeInterval(dayAlarm.alarmTimeHours * 60 + dayAlarm.alarmTimeMinutes - riseTime)),
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
        return hour < toAlarm.alarmTimeHours || (hour == toAlarm.alarmTimeHours && minute < toAlarm.alarmTimeMinutes)
    }
    
    // Returns the difference in minutes between the given date/s hour/minutes and dayAlarm's minutes
    // by subtracting date's hour/minutes from the dayAlarm's ambient sound start time.
    private func getDiffInMinutes(fromDate: Date, toAlarm: DayAlarm) -> Int {
        let hour = self.calendar.component(.hour, from: fromDate)
        let minute = self.calendar.component(.minute, from: fromDate)
        return (toAlarm.alarmTimeHours * 60 + toAlarm.alarmTimeMinutes) - (hour * 60 + minute)
    }
    
    // Returns the weekday of the given Date, in [1-7], in which 1 is Sunday and 7 is Saturday.
    func getDayOfWeek(_ date: Date) -> Int? {
        let weekDay = self.calendar.component(.weekday, from: date)
        return weekDay
    }
    
    private func isAlarmPlaying(_ alarm: AlarmObject)  -> Bool {
        return (alarm.status == .started || alarm.status == .snoozing)
    }
    
}


extension Notification.Name {
    static let alarmStartedNotification = Notification.Name("alarmStarted")
    static let alarmStoppedNotification = Notification.Name("alarmStopped")
    static let alexaRequestNotification = Notification.Name("alexaRequest")
}

