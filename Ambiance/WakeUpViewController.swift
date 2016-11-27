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
    
    private var presenter: WakeUpPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        presenter = WakeUpPresenter()
        
        applyOrangeBackground()
        
        setNavBarBackgroundToClear()
        
        updatePresentation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(WakeUpViewController.updatePresentation), name: User.NOTIFICATION_USER_CHANGE, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc
    private func updatePresentation() {
        NSLog("WakeUpViewController: updatePresentation()")
        let alarmSchedule = UserSession.shared.loggedInUser!.alarmSchedule
        let riseTime = UserSession.shared.loggedInUser!.alarmConfiguration.alarmRise
        wakeUpClockView.viewModel = presenter.createWakeUpClockViewModel(alarmSchedule: alarmSchedule, riseTimeInMinutes: riseTime)
        
        day1View.viewModel = presenter.createWakeUpDayViewModel(dayIndex: 0)
        day2View.viewModel = presenter.createWakeUpDayViewModel(dayIndex: 1)
        day3View.viewModel = presenter.createWakeUpDayViewModel(dayIndex: 2)
        day4View.viewModel = presenter.createWakeUpDayViewModel(dayIndex: 3)
        day5View.viewModel = presenter.createWakeUpDayViewModel(dayIndex: 4)
        day6View.viewModel = presenter.createWakeUpDayViewModel(dayIndex: 5)
        day7View.viewModel = presenter.createWakeUpDayViewModel(dayIndex: 6)
    }
    
    private func applyOrangeBackground() {
        let bkColorTop = Palette.orangeDark
        let bkColorBottom = Palette.orangeLight
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
