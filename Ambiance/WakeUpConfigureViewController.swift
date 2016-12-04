//
//  WakeUpConfigureViewController.swift
//  Ambiance
//
//  Created by Matthew Carroll on 11/19/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class WakeUpConfigureViewController: UIViewController, ClearNavBar {

    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var playbackDeviceSegmentedControl: UISegmentedControl!
    @IBOutlet var riseTimeSlider: UISlider!
    @IBOutlet var volumeSlider: UISlider!
    @IBOutlet var playPauseButtonImageView: UIImageView!
    @IBOutlet var playbackDeviceLabel: UILabel!
    @IBOutlet var playbackSelectionContainer: UIView!
    
    public var initialConfiguration: AlarmConfiguration!
    public var delegate: WakeUpConfigureViewControllerDelegate?
    private var isPlayingSample: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        clearBackground(forNavBar: navBar)
        
        addPlaybackSelectorToContainer()
        
        riseTimeSlider.minimumValue = Float(AlarmConfiguration.RISE_TIME_MIN)
        riseTimeSlider.maximumValue = Float(AlarmConfiguration.RISE_TIME_MAX)
        
        volumeSlider.minimumValue = Float(AlarmConfiguration.VOLUME_MIN)
        volumeSlider.maximumValue = Float(AlarmConfiguration.VOLUME_MAX)
        
        // Set all UI controls to match provided initialConfiguration
        if nil != initialConfiguration {
            switch initialConfiguration.playbackDevice {
            case .phone:
                playbackDeviceSegmentedControl.selectedSegmentIndex = 0
                break
            case .amazonEcho:
                playbackDeviceSegmentedControl.selectedSegmentIndex = 1
                break
            }
            
            riseTimeSlider.value = Float(initialConfiguration.alarmRise)
            
            volumeSlider.value = Float(initialConfiguration.alarmFinalVolume)
        } else {
            NSLog("WARNING: No initial configuration provided to WakeUpConfigurationViewController")
        }
        
        displayPlaybackDevice()
        
        NotificationCenter.default.addObserver(self, selector: #selector(WakeUpConfigureViewController.displayPlaybackDevice), name: Notification.Name.AVAudioSessionRouteChange, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTestAlarmTap(_ sender: AnyObject) {
        // TODO: test the alarm
    }
    
    @IBAction func onDoneTap(_ sender: AnyObject) {
        let alarmConfiguration = createAlarmConfiguration()
        delegate?.save(configuration: alarmConfiguration)
    }

    @IBAction func onCancelTap(_ sender: AnyObject) {
        delegate?.cancelConfiguration()
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
    
    private func addPlaybackSelectorToContainer() {
        let selectorView = MPVolumeView()
        selectorView.showsVolumeSlider = false
        
        playbackSelectionContainer.addSubview(selectorView)
        selectorView.frame = CGRect(x: (view.bounds.width - 32) / 2, y: (75 - 32) / 2, width: 32, height: 32)
        selectorView.layoutIfNeeded()
    }
    
    private func createAlarmConfiguration() -> AlarmConfiguration {
        var playbackDevice: PlaybackDevice
        if 0 == playbackDeviceSegmentedControl.selectedSegmentIndex {
            playbackDevice = .phone
        } else {
            playbackDevice = .amazonEcho
        }
        
        return AlarmConfiguration(playbackDevice: playbackDevice, alarmRise: Int(riseTimeSlider.value), alarmFinalVolume: Int(volumeSlider.value))
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

protocol WakeUpConfigureViewControllerDelegate {
    
    func save(configuration: AlarmConfiguration)
    
    func cancelConfiguration()
    
}
