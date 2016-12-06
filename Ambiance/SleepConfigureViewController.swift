//
//  SleepConfigureViewController.swift
//  Ambiance
//
//  Created by Matthew Carroll on 11/20/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class SleepConfigureViewController: UIViewController, ClearNavBar {

    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var playbackDeviceSegmentedControl: UISegmentedControl!
    @IBOutlet var hoursContainer: UIStackView!
    @IBOutlet var hoursLabel: UILabel!
    @IBOutlet var minutesLabel: UILabel!
    @IBOutlet var playTimeSlider: UISlider!
    @IBOutlet var volumeSlider: UISlider!
    @IBOutlet var playPauseButtonImageView: UIImageView!
    @IBOutlet var playbackDeviceLabel: UILabel!
    @IBOutlet var playbackSelectionContainer: UIView!
    
    public var initialConfiguration: SleepConfiguration!
    public var delegate: SleepConfigureViewControllerDelegate?
    private var isPlayingSample: Bool = false
    private var sampleAlarm : AlarmObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        clearBackground(forNavBar: navBar)
        
        addPlaybackSelectorToContainer()
        
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
            
            sampleAlarm = AlarmObject(itemToPlay: URL(string: "https://dream-team-bucket.s3-us-west-1.amazonaws.com/music/babbling-brook.mp3")!) //initialConfiguration.soundUri)!) // Need to purge Parse data for "TODO" String in there
        } else {
            NSLog("WARNING: No initial SleepConfiguration provided.")
        }
        
        displayPlaybackDevice()
        
        NotificationCenter.default.addObserver(self, selector: #selector(SleepConfigureViewController.displayPlaybackDevice), name: Notification.Name.AVAudioSessionRouteChange, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (self.sampleAlarm != nil) {
            self.sampleAlarm!.stop()
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
            self.sampleAlarm!.setVolume(Float(volumeSlider.value) / 100)  // FIXME: probably better to observe volumeSlider change too
            self.sampleAlarm!.startPlayback()
        } else {
            playPauseButtonImageView.image = UIImage(imageLiteralResourceName: "ic_play")
            if let sampleAlarm = self.sampleAlarm {
                sampleAlarm.stop()
            }
        }
        
        // TODO: make sure to pause playback when this ViewController goes away just in case the user forgot to press pause
    }

    @IBAction func volumeSliderChanged(_ sender: UISlider) {
        if let sampleAlarm = self.sampleAlarm {
            sampleAlarm.setVolume(Float(sender.value) / 100)
        }
    }
    
    @IBAction func onDoneTap(_ sender: AnyObject) {
        let sleepConfiguration = createSleepConfiguration()
        delegate?.save(sleepConfiguration: sleepConfiguration)
    }
    
    private func addPlaybackSelectorToContainer() {
        let selectorView = MPVolumeView()
        selectorView.showsVolumeSlider = false
        
        playbackSelectionContainer.addSubview(selectorView)
        selectorView.frame = CGRect(x: (view.bounds.width - 32) / 2, y: (75 - 32) / 2, width: 32, height: 32)
        selectorView.layoutIfNeeded()
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
    
    @objc
    private func displayPlaybackDevice() {
        let session = AVAudioSession.sharedInstance()
        let currentRoute = session.currentRoute
        let portName = currentRoute.outputs[0].portName
        var displayName = ""
        
        if "Speaker" == portName {
            displayName = "iPhone"
        } else if portName.contains("Echo") {
            displayName = "Amazon Echo"
        }
        
        playbackDeviceLabel.text = displayName
    }
    
}

protocol SleepConfigureViewControllerDelegate {
    
    func save(sleepConfiguration: SleepConfiguration)
    
}
