//
//  UserSettings.swift
//  Ambiance
//
//  Created by Ryan Chee on 11/27/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//


import UIKit
import Parse

// Represents user settings
class UserSettings: NSObject {
    
    private var alarmEnabled: Bool

    override init() {
        self.alarmEnabled = true
        super.init()
    }
    
    init?(pfObject: PFObject) {
        self.alarmEnabled = true
        if let alarmEnabled = pfObject.value(forKey: "alarmEnabled") {
            self.alarmEnabled = alarmEnabled as! Bool
        }
    }
    
    public func getAlarmEnabled() -> Bool {
        return alarmEnabled
    }
    
    public func setAlarmEnabled(state: Bool) {
        alarmEnabled = state
    }
    
    public func serializeToDictionary() -> [String : Any] {
        var dictionary = [String : Any]()
        
        dictionary["alarmEnabled"] = alarmEnabled as Bool
        
        return dictionary
    }
}
