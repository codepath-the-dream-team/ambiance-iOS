//
//  WakeUpConfigureViewController.swift
//  Ambiance
//
//  Created by Matthew Carroll on 11/19/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit

class WakeUpConfigureViewController: UIViewController, ClearNavBar {

    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var playbackDeviceSegmentedControl: UISegmentedControl!
    @IBOutlet var riseTimeSlider: UISlider!
    @IBOutlet var volumeSlider: UISlider!
    @IBOutlet var playPauseButtonImageView: UIImageView!
    
    public var initialConfiguration: AlarmConfiguration!
    public var delegate: WakeUpConfigureViewControllerDelegate?
    private var isPlayingSample: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        clearBackground(forNavBar: navBar)
        
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
    
    private func createAlarmConfiguration() -> AlarmConfiguration {
        var playbackDevice: PlaybackDevice
        if 0 == playbackDeviceSegmentedControl.selectedSegmentIndex {
            playbackDevice = .phone
        } else {
            playbackDevice = .amazonEcho
        }
        
        return AlarmConfiguration(playbackDevice: playbackDevice, alarmRise: Int(riseTimeSlider.value), alarmFinalVolume: Int(volumeSlider.value))
    }
}

protocol WakeUpConfigureViewControllerDelegate {
    
    func save(configuration: AlarmConfiguration)
    
    func cancelConfiguration()
    
}
