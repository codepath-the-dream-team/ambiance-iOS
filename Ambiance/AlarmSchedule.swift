//
//  AlarmSchedule.swift
//  Ambiance
//
//  Created by Ryan Chee on 11/16/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//


import UIKit

class AlarmSchedule: NSObject {
    var dictionary: [String:Array<Alarm>]
    
    override init() {
        dictionary = [String:[Alarm]]()
        dictionary["monday"] = [Alarm]()
        dictionary["tuesday"] = [Alarm]()
        dictionary["wednesday"] = [Alarm]()
        dictionary["thursday"] = [Alarm]()
        dictionary["friday"] = [Alarm]()
        dictionary["saturday"] = [Alarm]()
        dictionary["sunday"] = [Alarm]()
        super.init()
    }
    
    func addAlarm(alarm: Alarm) {
        if var arr = dictionary[alarm.dayOfWeek!] {
            arr.append(alarm)
            dictionary[alarm.dayOfWeek!] = arr
        }
    }
    
    func deleteAlarm(alarm: Alarm) {
        var arr = dictionary[alarm.dayOfWeek!]
        if let index = arr?.index(of: alarm) {
            arr?.remove(at: index)
        }
    }
}
