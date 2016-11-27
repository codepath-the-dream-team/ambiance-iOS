//
//  AlarmConfiguration.swift
//  Ambiance
//
//  Created by Matthew Carroll on 11/25/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import Foundation
import Parse

struct AlarmConfiguration {
    
    public static let RISE_TIME_MIN = 0
    public static let RISE_TIME_MAX = 60 // in minutes
    public static let VOLUME_MIN = 0
    public static let VOLUME_MAX = 100
    
    public var playbackDevice: PlaybackDevice
    public var alarmRise: Int
    public var alarmFinalVolume: Int
    
    init() {
        self.playbackDevice = .phone
        self.alarmRise = 30
        self.alarmFinalVolume = 50
    }
    
    init(playbackDevice: PlaybackDevice, alarmRise: Int, alarmFinalVolume: Int) {
        self.playbackDevice = playbackDevice
        
        // Clamp alarmRise between min/max values.
        self.alarmRise = min(AlarmConfiguration.RISE_TIME_MAX, max(AlarmConfiguration.RISE_TIME_MIN, alarmRise))
        
        // Clamp alarmFinalVolume between min/max values.
        self.alarmFinalVolume = max(AlarmConfiguration.VOLUME_MIN, min(AlarmConfiguration.VOLUME_MAX, alarmFinalVolume))
    }
    
    init?(from dictionary: [String : AnyObject]) {
        if let rawPlaybackDevice = dictionary["playbackDevice"] as? String,
            let alarmRiseTimeInMinutes = dictionary["alarmRiseTimeInMinutes"] as? Int,
            let alarmFinalVolume = dictionary["alarmFinalVolume"] as? Int {
            self.playbackDevice = PlaybackDevice(rawValue: rawPlaybackDevice)!
            self.alarmRise = alarmRiseTimeInMinutes
            self.alarmFinalVolume = alarmFinalVolume
        } else {
            return nil
        }
    }
    
    public func serializeToDictionary() -> [String : AnyObject] {
        return [
            "playbackDevice" : playbackDevice.rawValue as AnyObject,
            "alarmRiseTimeInMinutes" : alarmRise as AnyObject,
            "alarmFinalVolume" : alarmFinalVolume as AnyObject
        ]
    }
}
