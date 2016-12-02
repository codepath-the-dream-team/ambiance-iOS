//
//  MainViewController.swift
//  Ambiance
//
//  Created by Matthew Carroll on 11/8/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITabBarDelegate {

    @IBOutlet var viewContainer: UIView!
    @IBOutlet var tabbarView: UITabBar!
    private var activeScreen: UIViewController!
    private var alarmScheduler: AlarmScheduler!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return UIStatusBarStyle.lightContent
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let user = UserSession.shared.loggedInUser!
        print("\(user)")
        print("\(user.firstName)")
        print("\(user.lastName)")
        print("\(user.email)")
        print("\(user.profileImageUrl!)")
        tabbarView.delegate = self
        
        self.alarmScheduler = AlarmScheduler()
        let alarmScheduledDate = self.alarmScheduler.scheduleNextAlarm()
        print("next alarm scheduled at \(alarmScheduledDate)")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showAlarm(_:)), name: .alarmStartedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.alexaRequestReceived(_:)), name: .alexaRequestNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let index = tabbarView.items?.index(of: item)!
        if (0 == index) {
            showWakeUp()
        }
        if (1 == index) {
            showSleep()
        }
        if (3 == index) {
            showAccount()
        }
    }
    
    private func showWakeUp() {
        let wakeUpStoryboard = UIStoryboard(name: "WakeUp", bundle: nil)
        let wakeUpVc = wakeUpStoryboard.instantiateViewController(withIdentifier: "wakeup")
        show(screen: wakeUpVc)
    }
    
    private func showSleep() {
        let sleepStoryboard = UIStoryboard(name: "Sleep", bundle: nil)
        let sleepVc = sleepStoryboard.instantiateViewController(withIdentifier: "sleep")
        show(screen: sleepVc)
    }
    
    private func showAccount() {
        let accountStoryboard = UIStoryboard(name: "Account", bundle: nil)
        let accountVc = accountStoryboard.instantiateViewController(withIdentifier: "account")
        show(screen: accountVc)
    }
    
    @objc private func showAlarm(_ notification: NSNotification) {
        if let alarm = notification.userInfo?["alarm"] as? AlarmObject {
            let alarmOnStoryboard = UIStoryboard(name: "AlarmOn", bundle: nil)
            let alarmOnVcNavigation = alarmOnStoryboard.instantiateViewController(withIdentifier: "AlarmOnNavigationController") as! UINavigationController
            let alarmOnVc = alarmOnVcNavigation.viewControllers[0] as! AlarmOnViewController
            alarmOnVc.alarmObject = alarm
            self.present(alarmOnVcNavigation, animated: true, completion: nil) // Modal presentation        
        }
    }
    
    private func show(screen: UIViewController) {
        if nil != activeScreen {
            activeScreen.willMove(toParentViewController: nil)
            activeScreen.removeFromParentViewController()
            activeScreen.didMove(toParentViewController: nil)
        }
        
        activeScreen = screen
        activeScreen.willMove(toParentViewController: self)
        activeScreen.view.frame = viewContainer.bounds
        viewContainer.addSubview(activeScreen.view)
        activeScreen.didMove(toParentViewController: self)
    }
    
    @objc private func alexaRequestReceived(_ notification: NSNotification) {
        let userInfo = notification.userInfo
        let action = userInfo?["action"] as? String
        print("alexaRequestReceived \(action)")
        if let action = action {
            if (action == "start") {
                // Start nighttime alarm
                print("starting alarm")
            } else if (action == "snooze") {
                // Snooze ongoing alarm
                print("snoozing alarm")
            } else if (action == "stop") {
                // Stop ongoing alarm
                print("stopping alarm")

            }
        }
    }

}


