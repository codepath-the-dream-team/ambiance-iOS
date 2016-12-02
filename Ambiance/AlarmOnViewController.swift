//
//  AlarmOnViewController.swift
//  Ambiance
//
//  Created by Chihiro Saito on 11/20/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit

class AlarmOnViewController: UIViewController, ClearNavBar {

    @IBOutlet weak var circularView: CircularView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var amPmLabel: UILabel!
    @IBOutlet weak var snoozeButton: UIButton!
    
    var alarmObject: AlarmObject?
    var currentTime = Date() {
        didSet {
            timeLabel.text = self.timeLabelDateFormatter.string(from: currentTime as Date)
            amPmLabel.text = self.amPmLabelDateFormatter.string(from: currentTime as Date)
        }
    }
    let timeLabelDateFormatter = DateFormatter()
    let amPmLabelDateFormatter = DateFormatter()
    var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearBackground(forNavBar: navigationController!.navigationBar)
        
        self.timeLabelDateFormatter.dateFormat = "hh:mm"
        self.amPmLabelDateFormatter.dateFormat = "a"
        self.currentTime = Date(timeIntervalSinceNow: 0)
        self.circularView.delegate = self
        self.snoozeButton.layer.cornerRadius = 5
        self.snoozeButton.clipsToBounds = true
        self.circularView.animationColor = self.snoozeButton.backgroundColor!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerFired), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func timerFired() {
        self.currentTime = Date()
    }
    
    @IBAction func snoozeButtonPressed(_ sender: UIButton) {
        if let alarmObject = self.alarmObject {
            alarmObject.snooze()
        }
    }
}

extension AlarmOnViewController: CircularViewDelegate {
    func selected() {
        self.alarmObject?.stop()
        self.dismiss(animated: true, completion: nil)
    }
}
