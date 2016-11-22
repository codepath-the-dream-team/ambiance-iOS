//
//  AccountContainerViewController.swift
//  Ambiance
//
//  Created by Ryan Chee on 11/21/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit

class AccountContainerViewController: BaseNatureViewController {

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
    
    private func installAccountViewController() {
        let accountStoryboard = UIStoryboard(name: "Account", bundle: nil)
        let accountVc = accountStoryboard.instantiateViewController(withIdentifier: "account_display") as! UINavigationController
        
        setContent(vc: accountVc)

    }

}
