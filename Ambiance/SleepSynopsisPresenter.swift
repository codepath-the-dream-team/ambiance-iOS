//
//  SleepSynopsisPresenter.swift
//  Ambiance
//
//  Created by Matthew Carroll on 11/26/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import Foundation

class SleepSynopsisPresenter {
    
    public func createSleepSynopsisViewModel(sleepConfiguration: SleepConfiguration) -> SleepSynopsisViewModel {
        let hours = sleepConfiguration.playTimeInMinutes / 60
        let minutes = sleepConfiguration.playTimeInMinutes % 60
        
        return SleepSynopsisViewModel(hours: hours, minutes: minutes, alexaCommand: sleepConfiguration.alexaGoodnightCommand, ambianceTitle: sleepConfiguration.soundName)
    }
    
}

