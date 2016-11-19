//
//  Alarm.swift
//  Ambiance
//
//  Created by Ryan Chee on 11/17/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit

class Alarm: NSObject {
    var dayOfWeek: String?
    var alarmTime: String?
    var toMaxVolumeInMinutes: Int?
    var mediaStopTimeInMinutes: Int?
    
    init(dayOfWeek: String, alarmTime: String, toMaxVolumeInMinutes: Int, mediaStopTimeInMinutes: Int) {
        self.dayOfWeek = dayOfWeek
        self.alarmTime = alarmTime
        self.toMaxVolumeInMinutes = toMaxVolumeInMinutes
        self.mediaStopTimeInMinutes = mediaStopTimeInMinutes
    }
}

//let inFormatter = NSDateFormatter()
//inFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
//inFormatter.dateFormat = "HH:mm"
//
//let outFormatter = NSDateFormatter()
//outFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
//outFormatter.dateFormat = "hh:mm"
//
//let inStr = "16:50"
//let date = inFormatter.dateFromString(inStr)!
//let outStr = outFormatter.stringFromDate(date)
//println(outStr) // -> outputs 04:50
