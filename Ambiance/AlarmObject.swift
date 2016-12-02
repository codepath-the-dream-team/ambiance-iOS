//
//  AlarmObject.swift
//  Ambiance
//

import Foundation
import AVFoundation

class AlarmObject : NSObject {
    
    dynamic var status = Status.initialized

    var player = AVPlayer()
    var toMaxVolumeInSeconds = -1
    var maxVolume = Float(1.0)
    var mediaStopTimeInSeconds = -1
    var currentMediaTime = 0
    var timer : Timer?
    var volumeInterval = 0
    
    var snoozeDurationInSeconds = 60 * 1 // 1 minute
    
    @objc
    enum Status: Int {
        case initialized = 0,
        scheduled = 1,
        started = 2,
        stopped = 3,
        snoozing = 4
    }
    
    // Initialize the alarm with a path to mp3
    init(itemToPlay: URL) {
        super.init()
        self.player = AVPlayer(playerItem: AVPlayerItem(url: itemToPlay))
        self.player.volume = 1.0
        self.currentMediaTime = 0
        // Loop
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.playerItemReachedToEnd),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: self.player.currentItem)
    }
    
    // Set the volume increase feature to be applied when the alarm starts plaing
    func setVolumeIncreaseFeature(toMaxVolumeInMinutes: Int, maxVolume: Float) {
        print("[AO] setVolumeIncreaseFeature max \(maxVolume) in \(toMaxVolumeInMinutes) minutes")
        self.toMaxVolumeInSeconds = toMaxVolumeInMinutes * 60
        if maxVolume <= 1.0 && maxVolume >= 0.0 {
            self.maxVolume = maxVolume
        }
    }
    
    // Sets the initial volume for this alarm
    func setVolume(_ volume: Float) {
        print("[AO] setting volume \(volume) \(Date())")
        if volume <= 1.0 && volume >= 0.0 {
            self.player.volume = volume
        }
    }
    
    // Sets the duration of the alarm, in seconds.
    func setDuration(_ duration: Int) {
        // If duration is positive then turn the alarm off at that point
        if duration > 0 {
            self.mediaStopTimeInSeconds = duration
        }
    }
    
    // Schedule the alarm to go off at the given date-time
    func scheduleAt(when: Date) {
        print("[AO] scheduleAlarmAt \(when)")
        if (self.status == Status.started || self.status == Status.scheduled) {
            print("[AO] Error: Alarm currently active, call stop() first.")
            return
        }
        let delay = when.timeIntervalSinceNow
        if (delay < 0) {
            // time given is earlier than now - start timer immediately
            startPlayback()
        } else {
            self.perform(#selector(self.startPlayback), with: nil, afterDelay: delay)
            self.status = Status.scheduled
        }
    }
    
    // Start the alarm playback immediately
    func startPlayback() {
        print("[AO] alarm started \(Date())")
        
        self.player.play()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerFired), userInfo: nil, repeats: true)
        
        // set volume increase interval if necessary
        if self.toMaxVolumeInSeconds > 0 && self.player.volume < self.maxVolume {
            self.volumeInterval = self.toMaxVolumeInSeconds / Int((self.maxVolume - (self.player.volume)) * 10)
            print("[AO] alarm volume interval \(self.volumeInterval)")
            
        } else {
            self.volumeInterval = 0
        }
        
        self.status = Status.started
    }
    
    // Stop this alarm
    func stop() {
        print("[AO] stopping alarm \(Date())")
        if self.status == Status.scheduled {
            NSObject.cancelPreviousPerformRequests(withTarget: self)
        } else if self.status == Status.started {
            self.player.pause()
        }
        if let timer = timer {
            timer.invalidate()
        }
        self.currentMediaTime = 0
        self.status = Status.stopped
    }
    
    func snooze() {
        print("[AO] alarm snooze \(Date())")
        if self.status != Status.started {
            print("[AO] cannot snooze non-started alarm")
            return
        }
        self.player.pause()
        if let timer = timer {
            timer.invalidate()
        }
        self.toMaxVolumeInSeconds = self.toMaxVolumeInSeconds - self.currentMediaTime
        self.currentMediaTime = 0
        self.status = Status.snoozing
        
        self.perform(#selector(self.startPlayback), with: nil, afterDelay: TimeInterval(self.snoozeDurationInSeconds)) // restart the alarm after snoozeDurationInSeconds
    }
    
    
    // Return the amount of time that the alarm has been going on, in seconds.
    func getElapsedTime() -> Int {
        return self.currentMediaTime
    }
    
    // Return the underlying player instance used in this alarm
    func getPlayer() -> AVPlayer {
        return self.player
    }
    

    // Begin selectors
    func playerItemReachedToEnd(notification: NSNotification) {
        print("[AO] end reached, looping")
        self.player.seek(to: CMTimeMakeWithSeconds(1, 1))
        self.player.play()
    }
    
    func timerFired() {
        self.currentMediaTime += 1
        if (self.volumeInterval > 0 &&
            self.player.volume < self.maxVolume &&
            self.currentMediaTime % self.volumeInterval == 0) {
            self.setVolume(player.volume + 0.1)
        }
        
        if (self.mediaStopTimeInSeconds > 0 && self.currentMediaTime >= self.mediaStopTimeInSeconds) {
            self.stop()
        }
    }
    // End selectors
}
