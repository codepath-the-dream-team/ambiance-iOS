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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tabbarView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let index = tabbarView.items?.index(of: item)!
        if (3 == index) {
            showAccount()
        }
    }
    
    private func showAccount() {
        let accountStoryboard = UIStoryboard(name: "Account", bundle: nil)
        let accountVc = accountStoryboard.instantiateViewController(withIdentifier: "account")
        show(screen: accountVc)
    }
    
    private func show(screen: UIViewController) {
        if nil != activeScreen {
            activeScreen.willMove(toParentViewController: nil)
            activeScreen.removeFromParentViewController()
            activeScreen.didMove(toParentViewController: nil)
        }
        
        activeScreen = screen
        activeScreen.willMove(toParentViewController: self)
        activeScreen.view.frame = viewContainer.frame
        viewContainer.addSubview(activeScreen.view)
        activeScreen.didMove(toParentViewController: self)
    }

}
