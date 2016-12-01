//
//  WakeUpContainerViewController.swift
//  Ambiance
//
//  Created by Matthew Carroll on 11/18/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit

class WakeUpContainerViewController: BaseNatureViewController, WakeUpViewControllerDelegate, WakeUpConfigureViewControllerDelegate, WakeUpEditViewControllerDelegate {
    
    @IBOutlet var contentContainer: UIView!
    @IBOutlet var contentTopConstraint: NSLayoutConstraint!
    
    @IBOutlet var modalContainer: UIView!
    @IBOutlet var modalTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        installWakeUpViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func getContentContainer() -> UIView! {
        return contentContainer
    }
    
    override func getContentTopConstraint() -> NSLayoutConstraint! {
        return contentTopConstraint
    }
    
    override func getModalContainer() -> UIView! {
        return modalContainer
    }
    
    override func getModalTopConstraint() -> NSLayoutConstraint! {
        return modalTopConstraint
    }
    
    func showWakeUpConfiguration() {
        NSLog("showWakeUpConfiguration()")
        
        let wakeUpStoryboard = UIStoryboard(name: "WakeUp", bundle: nil)
        let alarmConfigurationVc = wakeUpStoryboard.instantiateViewController(withIdentifier: "wake_up_configure") as! WakeUpConfigureViewController
        
        alarmConfigurationVc.delegate = self
        alarmConfigurationVc.initialConfiguration = UserSession.shared.loggedInUser!.alarmConfiguration
        
        setModal(vc: alarmConfigurationVc)
        displayModal()
    }
    
    func showWakeUpEdit() {
        NSLog("showWakeUpEdit()")
        
        let wakeUpStoryboard = UIStoryboard(name: "WakeUp", bundle: nil)
        let wakeUpEditScheduleVc = wakeUpStoryboard.instantiateViewController(withIdentifier: "wake_up_edit") as! WakeUpEditViewController
        
        wakeUpEditScheduleVc.delegate = self
        
        setModal(vc: wakeUpEditScheduleVc)
        displayModal()
    }
    
    func save(configuration: AlarmConfiguration) {
        NSLog("Saving AlarmConfiguration.")
        
        closeModal()
        
        UserSession.shared.loggedInUser!.save(alarmConfiguration: configuration) { (error: Error?) in
            if nil == error {
                NSLog("Successfully saved AlarmConfiguration to Parse.")
            } else {
                NSLog("Failed to save AlarmConfiguration to Parse.")
            }
        }
    }
    
    func cancelConfiguration() {
        closeModal()
    }
    
    func saveEdit(wakeUpSchedule: WakeUpSchedule) {
        NSLog("Saving schedule:")
        NSLog(wakeUpSchedule.description)
        
        closeModal()
        
        saveWakeUpScheduleToParse(wakeUpSchedule: wakeUpSchedule)
    }
    
    func cancelEdit() {
        closeModal()
    }

    private func installWakeUpViewController() {
        let wakeUpStoryboard = UIStoryboard(name: "WakeUp", bundle: nil)
        let wakeUpVc = wakeUpStoryboard.instantiateViewController(withIdentifier: "wake_up_display") as! UINavigationController
        
        (wakeUpVc.topViewController as! WakeUpViewController).delegate = self

        setContent(vc: wakeUpVc)
    }
    
    private func saveWakeUpScheduleToParse(wakeUpSchedule: WakeUpSchedule) {
        let alarmSchedule = UserSession.shared.loggedInUser!.alarmSchedule
        
        for (day, dayWakeUpSchedule) in wakeUpSchedule.daySchedules {
            let dayAlarm: DayAlarm? = dayWakeUpSchedule.isEnabled ? DayAlarm(alarmTimeHours: dayWakeUpSchedule.hours, alarmTimeMinutes: dayWakeUpSchedule.minutes) : nil
            alarmSchedule.setAlarm(for: day, alarm: dayAlarm)
        }
        
        UserSession.shared.loggedInUser!.save(alarmSchedule: alarmSchedule) { (error: Error?) in
            if nil == error {
                NSLog("Successfully saved AlarmSchedule to Parse.")
                
            } else {
                NSLog("Failed to save AlarmSchedule to Parse: \(error)")
            }
        }
    }
}
