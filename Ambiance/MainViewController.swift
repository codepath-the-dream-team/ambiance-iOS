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

        showWakeUp()
        tabbarView.selectedItem = tabbarView.items![0]
        
        self.alarmScheduler = AlarmScheduler()

        NotificationCenter.default.addObserver(self, selector: #selector(self.showAlarmScreen(_:)), name: .alarmStartedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.dismissAlarmScreen(_:)), name: .alarmStoppedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.alexaRequestReceived(_:)), name: .alexaRequestNotification, object: nil)
        
        let storedAlexaAction = self.getStoredAlexaAction()
        if let action = storedAlexaAction {
            self.handleAlexaRequest(action)
            self.clearStoredAlexaAction()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        alarmScheduler.observeAlarmScheduleChange() // Possibly check for any alarm change
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
        if (4 == index) {
            showPresentation()
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
    
    private func showPresentation() {
        let presentationStoryboard = UIStoryboard(name: "Presentation", bundle: nil)
        let presentationVc = presentationStoryboard.instantiateViewController(withIdentifier: "presentation")
        show(screen: presentationVc)
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
    
    var alarmScreen: UIViewController?
    @objc private func showAlarmScreen(_ notification: NSNotification) {
        if let alarm = notification.userInfo?["alarm"] as? AlarmObject {
            if (self.alarmScheduler!.isMorningAlarm(alarm)) {
                let alarmOnStoryboard = UIStoryboard(name: "AlarmOn", bundle: nil)
                let alarmOnVcNavigation = alarmOnStoryboard.instantiateViewController(withIdentifier: "AlarmOnNavigationController") as! UINavigationController
                let alarmOnVc = alarmOnVcNavigation.viewControllers[0] as! AlarmOnViewController
                alarmOnVc.alarmObject = alarm
                self.alarmScreen = alarmOnVc
                self.present(alarmOnVcNavigation, animated: true, completion: nil) // Modal presentation
            } else {
                let nightSoundStoryboard = UIStoryboard(name: "NightSoundOn", bundle: nil)
                let nightSoundVcNavigation = nightSoundStoryboard.instantiateViewController(withIdentifier: "NightSoundOnNavigationController") as! UINavigationController
                let nightSoundVc = nightSoundVcNavigation.viewControllers[0] as! NightSoundOnViewController
                nightSoundVc.alarmObject = alarm
                self.alarmScreen = nightSoundVc
                self.present(nightSoundVcNavigation, animated: true, completion: nil) // Modal presentation
            }
        }
    }
    
    @objc private func dismissAlarmScreen(_ notification: NSNotification) {
        if (self.alarmScreen != nil) {
            self.alarmScreen!.dismiss(animated: true, completion: nil)
            self.alarmScreen = nil
        }
    }
    
    @objc private func alexaRequestReceived(_ notification: NSNotification) {
        let userInfo = notification.userInfo
        let action = userInfo?["action"] as? String
        print("alexaRequestReceived \(action)")
        if let action = action {
            handleAlexaRequest(action)
        }
        clearStoredAlexaAction()

    }
    
    private func handleAlexaRequest(_ action: String) {
        if (action == "start") {
            // Start nighttime alarm
            _ = self.alarmScheduler.startNightAlarm()
        } else if (action == "snooze") {
            self.alarmScheduler.getActiveAlarm()?.snooze()
        } else if (action == "stop") {
            self.alarmScheduler.getActiveAlarm()?.stop()
        }
    }
    
    private func getStoredAlexaAction() -> String? {
        let appDelegate = UIApplication.shared.delegate
        if let appDelegate = appDelegate as? AppDelegate {
            let notificationItem = appDelegate.alexaNotificationItem
            return notificationItem?["action"]
        }
        return nil
    }
    
    private func clearStoredAlexaAction() {
        let appDelegate = UIApplication.shared.delegate
        if let appDelegate = appDelegate as? AppDelegate {
            appDelegate.alexaNotificationItem = nil;
        }
    }

}


