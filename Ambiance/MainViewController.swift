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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let index = tabbarView.items?.index(of: item)!
        if (0 == index) {
            //showWakeUp()
            showAlarmOn()
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
    
    private func showAlarmOn() {
        let alarmOnStoryboard = UIStoryboard(name: "AlarmOn", bundle: nil)
        let alarmOnVc = alarmOnStoryboard.instantiateViewController(withIdentifier: "alarmOn")
        show(screen: alarmOnVc)
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

}
