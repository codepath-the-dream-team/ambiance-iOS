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
    private var liveEnabled: Bool
//    private var sleepEnabled: Bool
    private var echoID: String

    override init() {
        self.alarmEnabled = true
        self.liveEnabled = true
//        self.sleepEnabled = true
        self.echoID = ""
        super.init()
    }
    
    init?(pfObject: PFObject) {
        self.alarmEnabled = true
        self.liveEnabled = true
//        self.sleepEnabled = true
        self.echoID = ""
        if let alarmEnabled = pfObject.value(forKey: "alarmEnabled") {
            self.alarmEnabled = alarmEnabled as! Bool
        }
        if let liveEnabled = pfObject.value(forKey: "liveEnabled") {
            self.liveEnabled = liveEnabled as! Bool
        }
//        if let sleepEnabled = pfObject.value(forKey: "sleepEnabled") {
//            self.sleepEnabled = sleepEnabled as! Bool
//        }
        if let echoID = pfObject.value(forKey: "echoID") {
            self.echoID = echoID as! String
        }
    }
    
    public func getAlarmEnabled() -> Bool {
        return alarmEnabled
    }
    
    public func getLiveEnabled() -> Bool {
        return liveEnabled
    }
//    
//    public func getSleepEnabled() -> Bool {
//        return sleepEnabled
//    }
    
    public func getEchoID() -> String {
        return echoID
    }
    
    public func setAlarmEnabled(state: Bool) {
        alarmEnabled = state
    }
    
    public func setLiveEnabled(state: Bool) {
        liveEnabled = state
    }
    //
    //    public func setSleepEnabled(state: Bool) {
    //        return sleepEnabled
    //    }
    
    public func setEchoID(id: String) {
        echoID = id
    }
    
    public func serializeToDictionary() -> [String : Any] {
        var dictionary = [String : Any]()
        
        dictionary["alarmEnabled"] = alarmEnabled as Bool
        dictionary["liveEnabled"] = liveEnabled as Bool
//        dictionary["sleepEnabled"] = sleepEnabled as Bool
        dictionary["echoID"] = echoID as String
        
        return dictionary
    }
}
