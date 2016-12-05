//
//  NightSoundOnViewController.swift
//  Ambiance
//
//  Created by Chihiro Saito on 12/4/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit

class NightSoundOnViewController: UIViewController, ClearNavBar {
    
    var alarmObject: AlarmObject?

    @IBOutlet weak var soundNameLabel: UILabel!
    @IBOutlet weak var soundEndTimeLabel: UILabel!
    @IBOutlet weak var amPmLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    private let timeLabelDateFormatter = DateFormatter()
    private let amPmLabelDateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyPurpleBackground()
        clearBackground(forNavBar: navigationController!.navigationBar)
        applyRoundCorner()
        applySleepConfigurationData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func applyPurpleBackground() {
        let bkColorTop = Palette.purpleDark
        let bkColorBottom = Palette.purpleLight
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [bkColorTop.cgColor, bkColorBottom.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func applyRoundCorner() {
        self.stopButton.layer.cornerRadius = 5
        self.stopButton.clipsToBounds = true
    }
    
    private func applySleepConfigurationData() {
        self.timeLabelDateFormatter.dateFormat = "hh:mm"
        self.amPmLabelDateFormatter.dateFormat = "a"
        let sleepConfiguration = UserSession.shared.loggedInUser?.sleepConfiguration
        if let sleepConfiguration = sleepConfiguration {
            self.soundNameLabel.text = sleepConfiguration.soundName
            let alarmEndTime = NSDate(timeIntervalSinceNow: Double(sleepConfiguration.playTimeInMinutes) * 60.0)
            soundEndTimeLabel.text = self.timeLabelDateFormatter.string(from: alarmEndTime as Date)
            amPmLabel.text = self.amPmLabelDateFormatter.string(from: alarmEndTime as Date)
        }
    }
    
    @IBAction func stopClicked(_ sender: UIButton) {
        if let alarmObject = self.alarmObject {
            alarmObject.stop()
        }
    }
}
