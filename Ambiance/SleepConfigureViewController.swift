//
//  SleepConfigureViewController.swift
//  Ambiance
//
//  Created by Matthew Carroll on 11/20/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit

class SleepConfigureViewController: UIViewController, ClearNavBar {

    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var playbackDeviceSegmentedControl: UISegmentedControl!
    @IBOutlet var playTimeSlider: UISlider!
    @IBOutlet var volumeSlider: UISlider!
    
    public var initialConfiguration: SleepConfiguration!
    public var delegate: SleepConfigureViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        clearBackground(forNavBar: navBar)
        
        playTimeSlider.minimumValue = Float(SleepConfiguration.PLAY_TIME_MIN)
        playTimeSlider.maximumValue = Float(SleepConfiguration.PLAY_TIME_MAX)
        
        volumeSlider.minimumValue = Float(SleepConfiguration.VOLUME_MIN)
        volumeSlider.maximumValue = Float(SleepConfiguration.VOLUME_MAX)
        
        if nil != initialConfiguration {
            NSLog("Applying initial SleepConfiguration: \(initialConfiguration)")
            switch initialConfiguration.playbackDevice {
            case .phone:
                playbackDeviceSegmentedControl.selectedSegmentIndex = 0
                break
            case .amazonEcho:
                playbackDeviceSegmentedControl.selectedSegmentIndex = 1
                break
            }
            
            playTimeSlider.value = Float(initialConfiguration.playTimeInMinutes)
            
            volumeSlider.value = Float(initialConfiguration.volume)
        } else {
            NSLog("WARNING: No initial SleepConfiguration provided.")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onDoneTap(_ sender: AnyObject) {
        let sleepConfiguration = createSleepConfiguration()
        delegate?.save(sleepConfiguration: sleepConfiguration)
    }
    
    private func createSleepConfiguration() -> SleepConfiguration {
        var playbackDevice: PlaybackDevice!
        if 0 == playbackDeviceSegmentedControl.selectedSegmentIndex {
            playbackDevice = .phone
        } else {
            playbackDevice = .amazonEcho
        }
        
        return SleepConfiguration(playbackDevice: playbackDevice, playTimeInMinutes: Int(playTimeSlider.value), volume: Int(volumeSlider.value), soundName: "Babbling Brook", soundUri: "TODO", alexaGoodnightCommand: "Alexa, good night")
    }
    
}

protocol SleepConfigureViewControllerDelegate {
    
    func save(sleepConfiguration: SleepConfiguration)
    
}
