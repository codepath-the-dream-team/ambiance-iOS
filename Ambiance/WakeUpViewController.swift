//
//  WakeUpViewController.swift
//  Ambiance
//
//  Created by Matthew Carroll on 11/16/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit

class WakeUpViewController: UIViewController {

    @IBOutlet var wakeUpClockView: WakeUpClockView!
    @IBOutlet var day1View: WakeUpDayListItem!
    @IBOutlet var day2View: WakeUpDayListItem!
    @IBOutlet var day3View: WakeUpDayListItem!
    @IBOutlet var day4View: WakeUpDayListItem!
    @IBOutlet var day5View: WakeUpDayListItem!
    @IBOutlet var day6View: WakeUpDayListItem!
    @IBOutlet var day7View: WakeUpDayListItem!
    
    public var delegate: WakeUpViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        applyOrangeBackground()
        
        setNavBarBackgroundToClear()
        
        wakeUpClockView.viewModel = WakeUpClockViewModel(time: "07:30", amPm: .am, message: NSAttributedString(string: "You will wake up in 8 hours and 15 minutes with a 30 minute rise"))
        
        day1View.viewModel = WakeUpDayListItemViewModel(dayName: "Monday", startRiseTime: "7:30AM", finishRiseTime: "8:00AM")
        day2View.viewModel = WakeUpDayListItemViewModel(dayName: "Tuesday", startRiseTime: "7:30AM", finishRiseTime: "8:00AM")
        day3View.viewModel = WakeUpDayListItemViewModel(dayName: "Wednesday", startRiseTime: "7:30AM", finishRiseTime: "8:00AM")
        day4View.viewModel = WakeUpDayListItemViewModel(dayName: "Thursday", startRiseTime: "7:30AM", finishRiseTime: "8:00AM")
        day5View.viewModel = WakeUpDayListItemViewModel(dayName: "Friday", startRiseTime: "7:30AM", finishRiseTime: "8:00AM")
        day6View.viewModel = WakeUpDayListItemViewModel(dayName: "Saturday", startRiseTime: "9:30AM", finishRiseTime: "10:00AM")
        day7View.viewModel = WakeUpDayListItemViewModel(dayName: "Sunday", startRiseTime: "9:30AM", finishRiseTime: "10:00AM")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func applyOrangeBackground() {
        let bkColorTop = UIColor(colorLiteralRed: 1.0, green: 0.3, blue: 0.0, alpha: 1.0)
        let bkColorBottom = UIColor(colorLiteralRed: 1.0, green: 0.6, blue: 0.0, alpha: 1.0)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [bkColorTop.cgColor, bkColorBottom.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setNavBarBackgroundToClear() {
        navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController!.navigationBar.shadowImage = UIImage()
        navigationController!.navigationBar.backgroundColor = UIColor.clear
    }
    

    @IBAction func onConfigureTap(_ sender: AnyObject) {
        delegate?.showWakeUpConfiguration()
    }
    
    @IBAction func onWakeUpTap(_ sender: UITapGestureRecognizer) {
        delegate?.showWakeUpEdit()
    }
    
    @IBAction func onDayTap(_ sender: UITapGestureRecognizer) {
        delegate?.showWakeUpEdit()
    }
    

}

protocol WakeUpViewControllerDelegate {
    
    func showWakeUpConfiguration()
    
    // TODO: pass the current day's configuration
    func showWakeUpEdit()
    
}
