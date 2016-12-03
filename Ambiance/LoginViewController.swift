//
//  ViewController.swift
//  Ambiance
//
//  Created by Matthew Carroll on 11/6/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4
import MBProgressHUD


class LoginViewController: UIViewController {
    
    @IBOutlet var loginWithFacebookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginWithFacebookButton.isHidden = true
        loginWithFacebookButton.layer.cornerRadius = 8
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Restore User Session after View appears because if try to navigate
        // to the MainViewController before the View appears, we get a crash.
        restoreUserSession()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func restoreUserSession() {
        showProgressSpinner()
        
        // Try to restore a UserSession if one exists.
        UserSession.shared.restorePreviousSessionIfPossible { (success: Bool) in
            self.hideProgressSpinner()
            
            if success {
                NSLog("Successfully restored existing session. Showing MainVC")
                self.navigateToHomeScreen()
            } else {
                NSLog("Did NOT restore an existing user session. Either one did not exist, or an existing session failed restoration.")
                self.configureDisplayForLogin()
            }
        }
    }
    
    private func showProgressSpinner() {
        NSLog("Showing progress HUD")
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    private func hideProgressSpinner() {
        NSLog("Hiding progress HUD")
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    private func configureDisplayForLogin() {
        UIView.animate(withDuration: 0.5) { 
            self.loginWithFacebookButton.isHidden = false
        }
    }
    
    @IBAction func facebookLoginTapped(_ sender: AnyObject) {
        UserSession.shared.login(success: { (user: User) in
            NSLog("LoginViewController successfully logged user in.")
            self.navigateToHomeScreen()
        }) { (error: Error?) in
            NSLog("LoginViewController failed to log user in.")
        }
    }

    func navigateToHomeScreen() {
        NSLog("Navigating to homescreen")
        let mainStoryboard = UIStoryboard(name: "Infrastructure", bundle: nil)
        let mainVc = mainStoryboard.instantiateViewController(withIdentifier: "main") as! MainViewController
        self.present(mainVc, animated: true, completion: nil)
    }
}

