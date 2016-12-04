//
//  SleepConfiguration.swift
//  Ambiance
//
//  Created by Matthew Carroll on 11/25/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import Foundation

struct SleepConfiguration {
    
    public static let PLAY_TIME_MIN = 15 // minutes
    public static let PLAY_TIME_MAX = 8 * 60 // minutes
    
    public static let VOLUME_MIN = 0
    public static let VOLUME_MAX = 100
    
    public let playbackDevice: PlaybackDevice
    public let playTimeInMinutes: Int
    public let volume: Int
    public let soundName: String
    public let soundUri: String
    public let alexaGoodnightCommand: String
    
    init() {
        self.playbackDevice = .phone
        self.playTimeInMinutes = 15
        self.volume = 50
        self.soundName = "Babbling Brook"
        self.soundUri = "https://dream-team-bucket.s3-us-west-1.amazonaws.com/music/babbling-brook.mp3"
        self.alexaGoodnightCommand = "Alexa, good night"
    }
    
    init(playbackDevice: PlaybackDevice, playTimeInMinutes: Int, volume: Int, soundName: String, soundUri: String, alexaGoodnightCommand: String) {
        self.playbackDevice = playbackDevice
        self.playTimeInMinutes = max(SleepConfiguration.PLAY_TIME_MIN, min(SleepConfiguration.PLAY_TIME_MAX, playTimeInMinutes))
        self.volume = max(SleepConfiguration.VOLUME_MIN, min(SleepConfiguration.VOLUME_MAX, volume))
        self.soundName = soundName
        self.soundUri = soundUri
        self.alexaGoodnightCommand = alexaGoodnightCommand
    }
    
    init?(fromDictionary dictionary: [String : AnyObject]) {
        if let rawPlaybackDevice = dictionary["playbackDevice"] as? String,
            let playTimeInMinutes = dictionary["playTimeInMinutes"] as? Int,
            let volume = dictionary["volume"] as? Int,
            let soundName = dictionary["soundName"] as? String,
            let soundUri = dictionary["soundUri"] as? String,
            let alexaGoodnightCommand = dictionary["alexaGoodnightCommand"] as? String {
            self.playbackDevice = PlaybackDevice(rawValue: rawPlaybackDevice)!
            self.playTimeInMinutes = playTimeInMinutes
            self.volume = volume
            self.soundName = soundName
            self.soundUri = soundUri
            self.alexaGoodnightCommand = alexaGoodnightCommand
        } else {
            return nil
        }
    }
    
    public func serializeToDictionary() -> [String : AnyObject] {
        return [
            "playbackDevice": playbackDevice.rawValue as AnyObject,
            "playTimeInMinutes": playTimeInMinutes as AnyObject,
            "volume": volume as AnyObject,
            "soundName": soundName as AnyObject,
            "soundUri": soundUri as AnyObject,
            "alexaGoodnightCommand": alexaGoodnightCommand as AnyObject
        ]
    }
    
}
