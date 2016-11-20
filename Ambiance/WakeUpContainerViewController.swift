//
//  WakeUpContainerViewController.swift
//  Ambiance
//
//  Created by Matthew Carroll on 11/18/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit

class WakeUpContainerViewController: UIViewController, WakeUpViewControllerDelegate, WakeUpConfigureViewControllerDelegate, WakeUpEditViewControllerDelegate {
    
    @IBOutlet var contentContainer: UIView!
    @IBOutlet var contentTopConstraint: NSLayoutConstraint!
    
    @IBOutlet var modalContainer: UIView!
    @IBOutlet var modalTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        installWakeUpViewController()
        
        modalTopConstraint.constant = self.view.bounds.height
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showWakeUpConfiguration() {
        NSLog("showWakeUpConfiguration()")
        
        let wakeUpStoryboard = UIStoryboard(name: "WakeUp", bundle: nil)
        let alarmConfigurationVc = wakeUpStoryboard.instantiateViewController(withIdentifier: "wake_up_configure") as! WakeUpConfigureViewController
        
        addChildViewController(alarmConfigurationVc)
        alarmConfigurationVc.willMove(toParentViewController: self)
        alarmConfigurationVc.view.frame = modalContainer.bounds
        modalContainer.addSubview(alarmConfigurationVc.view)
        alarmConfigurationVc.didMove(toParentViewController: self)
        
        alarmConfigurationVc.delegate = self
        
        displayModal()
    }
    
    func showWakeUpEdit() {
        NSLog("showWakeUpEdit()")
        
        let wakeUpStoryboard = UIStoryboard(name: "WakeUp", bundle: nil)
        let wakeUpEditScheduleVc = wakeUpStoryboard.instantiateViewController(withIdentifier: "wake_up_edit") as! WakeUpEditViewController
        
        addChildViewController(wakeUpEditScheduleVc)
        wakeUpEditScheduleVc.willMove(toParentViewController: self)
        wakeUpEditScheduleVc.view.frame = modalContainer.bounds
        modalContainer.addSubview(wakeUpEditScheduleVc.view)
        wakeUpEditScheduleVc.didMove(toParentViewController: self)
        
        wakeUpEditScheduleVc.delegate = self
        
        displayModal()
    }
    
    func saveConfiguration() {
        closeModal()
    }
    
    func cancelConfiguration() {
        closeModal()
    }
    
    func saveEdit() {
        closeModal()
    }
    
    func cancelEdit() {
        closeModal()
    }

    private func installWakeUpViewController() {
        let wakeUpStoryboard = UIStoryboard(name: "WakeUp", bundle: nil)
        let wakeUpVc = wakeUpStoryboard.instantiateViewController(withIdentifier: "wake_up_display") as! UINavigationController
        
        addChildViewController(wakeUpVc)
        wakeUpVc.willMove(toParentViewController: self)
        wakeUpVc.view.frame = contentContainer.bounds
        contentContainer.addSubview(wakeUpVc.view)
        wakeUpVc.didMove(toParentViewController: self)
        
        (wakeUpVc.topViewController as! WakeUpViewController).delegate = self
    }
    
    private func displayModal() {
        NSLog("Displaying modal")
        
        let finalPosition = self.view.bounds.height - modalContainer.bounds.height
    
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            self.contentTopConstraint.constant = -100
            self.modalTopConstraint.constant = finalPosition
            self.view.layoutIfNeeded()
        }
    }
    
    private func closeModal() {
        NSLog("Hiding modal")
        
        let finalPosition = self.view.bounds.height
        
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            self.contentTopConstraint.constant = 0
            self.modalTopConstraint.constant = finalPosition
            self.view.layoutIfNeeded()
        }
    }
}
