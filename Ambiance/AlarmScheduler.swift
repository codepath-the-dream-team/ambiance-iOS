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
    
    init(vc: UIViewController) {
        super.init()

        self.mainVc = vc
        // FIXME - need to come from Parse
        self.alarmObject = AlarmObject(itemToPlay: URL(string:
            "https://dream-team-bucket.s3-us-west-1.amazonaws.com/music/morning-forest.mp3")!)
        self.alarmObject.addObserver(self, forKeyPath: "status", options: [.new], context: nil)
        self.scheduleNextAlarm()
    }
    
    func scheduleNextAlarm() {
        let nextAlarm = self.getNextDayAlarm(startingDate: Date())
        if let nextAlarm = nextAlarm {
            self.alarmObject.setVolumeIncreaseFeature(toMaxVolumeInMinutes: nextAlarm.alarmRiseDurationInMinutes, maxVolume: 1.0)
            self.alarmObject.setVolume(0.1)
            
            // Schedule alarm - FIXME need to convert nextAlarm to Date object.
            //self.alarmObject?.scheduleAt(when: NSDate(timeIntervalSinceNow: 20) as Date)
        }
    }
    
    // Observe for the Alarm status change.
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "status") {
            if let alarm = object as? AlarmObject {
                if (alarm == self.alarmObject) {
                    if alarm.status == AlarmObject.Status.started {
                        self.showAlarmOn(self.alarmObject)
                    } else if alarm.status == AlarmObject.Status.stopped {
                        self.scheduleNextAlarm()
                    }
                }
            }
        }
    }
    
    func showAlarmOn(_ alarm: AlarmObject) {
        let alarmOnStoryboard = UIStoryboard(name: "AlarmOn", bundle: nil)
        let alarmOnVcNavigation = alarmOnStoryboard.instantiateViewController(withIdentifier: "AlarmOnNavigationController") as! UINavigationController
        let alarmOnVc = alarmOnVcNavigation.viewControllers[0] as! AlarmOnViewController
        alarmOnVc.alarmObject = alarm
        self.mainVc?.present(alarmOnVcNavigation, animated: true, completion: nil)
    }

    func getNextDayAlarm(startingDate: Date) -> DayAlarm? {
        let alarmSchedule = UserSession.shared.loggedInUser?.alarmSchedule
        if let alarmSchedule = alarmSchedule {
            var dayIndex = self.getDayOfWeek(startingDate)! - 1
            let dayAlarm = alarmSchedule.getAlarm(for: self.dayOfTheWeek[dayIndex])
            if let dayAlarm = dayAlarm {
                if (self.isBefore(date: startingDate, dayAlarm: dayAlarm)) {
                    return dayAlarm
                }
            }
            
            var i = 0;
            while (i < self.dayOfTheWeek.count) {
                dayIndex = (dayIndex+1 == self.dayOfTheWeek.count) ? 0 : dayIndex + 1
                let dayAlarm = alarmSchedule.getAlarm(for: self.dayOfTheWeek[dayIndex])
                if let dayAlarm = dayAlarm {
                    return dayAlarm
                }
                i = i+1
            }
        }
        return nil
    }
    
    // Returns true if date's hour/minutes is less than the dayAlarm's minutes, false otherwise.
    func isBefore(date: Date, dayAlarm: DayAlarm) -> Bool {
        let hour = self.calendar.component(.hour, from: date)
        let minute = self.calendar.component(.minute, from: date)
        return (hour * 60 + minute) < dayAlarm.alarmTimeInMinutes
    }
    
    func getDayOfWeek(_ date: Date) -> Int? {
        let weekDay = self.calendar.component(.weekday, from: date)
        return weekDay
    }
    
}
