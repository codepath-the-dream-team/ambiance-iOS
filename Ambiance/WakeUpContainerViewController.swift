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
    
    private var blurEffectView: UIVisualEffectView!
    private var blurEffect: UIVisualEffect!
    
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
        
        (wakeUpVc.topViewController as! WakeUpViewController).delegate = self

        setContent(vc: wakeUpVc)
    }
}
