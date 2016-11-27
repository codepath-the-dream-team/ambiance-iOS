//
//  SleepContainerViewController.swift
//  Ambiance
//
//  Created by Matthew Carroll on 11/20/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit

class SleepContainerViewController: BaseNatureViewController, SleepViewControllerDelegate, SleepConfigureViewControllerDelegate {

    @IBOutlet var contentContainer: UIView!
    @IBOutlet var contentTopConstraint: NSLayoutConstraint!
    
    @IBOutlet var modalContainer: UIView!
    @IBOutlet var modalTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        installSleepViewController()
        
        super.blurStyle = UIBlurEffectStyle.light
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
    
    func showSleepConfiguration() {
        NSLog("showSleepConfiguration()")
        
        let sleepStoryboard = UIStoryboard(name: "Sleep", bundle: nil)
        let sleepConfigurationVc = sleepStoryboard.instantiateViewController(withIdentifier: "sleep_configure") as! SleepConfigureViewController
        
        sleepConfigurationVc.delegate = self
        sleepConfigurationVc.initialConfiguration = UserSession.shared.loggedInUser!.sleepConfiguration
        
        setModal(vc: sleepConfigurationVc)
        displayModal()
    }
    
    func save(sleepConfiguration: SleepConfiguration) {
        closeModal()
        
        UserSession.shared.loggedInUser!.save(sleepConfiguration: sleepConfiguration) { (error: Error?) in
            if nil == error {
                NSLog("Successfully saved updated SleepConfiguration to Parse.")
            } else {
                NSLog("Failed to save updated SleepConfiguration to Parse.")
            }
        }
    }

    private func installSleepViewController() {
        let sleepStoryboard = UIStoryboard(name: "Sleep", bundle: nil)
        let sleepVc = sleepStoryboard.instantiateViewController(withIdentifier: "sleep_display") as! UINavigationController
        
        (sleepVc.topViewController as! SleepViewController).delegate = self
        
        setContent(vc: sleepVc)
    }
}
