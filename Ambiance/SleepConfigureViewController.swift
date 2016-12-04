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
    @IBOutlet var hoursContainer: UIStackView!
    @IBOutlet var hoursLabel: UILabel!
    @IBOutlet var minutesLabel: UILabel!
    @IBOutlet var playTimeSlider: UISlider!
    @IBOutlet var volumeSlider: UISlider!
    @IBOutlet var playPauseButtonImageView: UIImageView!
    
    public var initialConfiguration: SleepConfiguration!
    public var delegate: SleepConfigureViewControllerDelegate?
    private var isPlayingSample: Bool = false
    
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
            updatePlaybackTimeDisplay(totalMinutes: initialConfiguration.playTimeInMinutes)
            
            volumeSlider.value = Float(initialConfiguration.volume)
        } else {
            NSLog("WARNING: No initial SleepConfiguration provided.")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPlaybackTimeChange(_ sender: UISlider) {
        let timeIncrement = Float(15) // in minutes
        let snappedValue = round(sender.value / timeIncrement) * timeIncrement
        sender.value = snappedValue
        
        updatePlaybackTimeDisplay(totalMinutes: Int(snappedValue))
    }
    
    @IBAction func onPlayPauseTap(_ sender: UITapGestureRecognizer) {
        // TODO: play/pause ambiance playback
        
        isPlayingSample = !isPlayingSample
        if isPlayingSample {
            playPauseButtonImageView.image = UIImage(imageLiteralResourceName: "ic_pause")
        } else {
            playPauseButtonImageView.image = UIImage(imageLiteralResourceName: "ic_play")
        }
        
        // TODO: make sure to pause playback when this ViewController goes away just in case the user forgot to press pause
    }

    @IBAction func onDoneTap(_ sender: AnyObject) {
        let sleepConfiguration = createSleepConfiguration()
        delegate?.save(sleepConfiguration: sleepConfiguration)
    }
    
    private func updatePlaybackTimeDisplay(totalMinutes: Int) {
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        
        hoursContainer.isHidden = hours == 0
        hoursLabel.text = "\(hours)"
        minutesLabel.text = hours == 0 ? "\(minutes)" : String.init(format: "%02d", minutes)
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
