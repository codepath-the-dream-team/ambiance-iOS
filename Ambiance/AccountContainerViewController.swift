//
//  AccountContainerViewController.swift
//  Ambiance
//
//  Created by Ryan Chee on 11/21/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit

class AccountContainerViewController: BaseNatureViewController, NewAccountViewControllerDelegate {

    @IBOutlet weak var contentContainer: UIView!
    @IBOutlet weak var contentTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        installAccountViewController()
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
    
    func showLoginController() {
        UserSession.shared.logout()
    }
    
    private func installAccountViewController() {
        let accountStoryboard = UIStoryboard(name: "Account", bundle: nil)
        let accountVc = accountStoryboard.instantiateViewController(withIdentifier: "new_account_display") as! UINavigationController
        (accountVc.topViewController as! NewAccountViewController).delegate = self

        setContent(vc: accountVc)

    }

}
