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


class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .orange
        
        // Try to restore a UserSession if one exists.
        UserSession.shared.restorePreviousSessionIfPossible { (success: Bool) in
            if success {
                NSLog("Successfully restored existing session. Showing MainVC")
                self.navigateToHomeScreen()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func facebookLoginTapped(_ sender: AnyObject) {
        UserSession.shared.login(success: { (user: User) in
            NSLog("LoginViewController successfully logged user in.")
            self.navigateToHomeScreen()
        }) { (error: Error?) in
            NSLog("LoginViewController failed to log user in.")
        }
    }
    
    // TODO: what is this method for?
    func showAlert(errorTitle: String, errorString: String) {
        let alertController = UIAlertController(title: errorTitle, message: errorString, preferredStyle: .alert)
        
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response here.
        }
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        present(alertController, animated: true) {
            // optional code for what happens after the alert controller has finished presenting
        }
    }

    func navigateToHomeScreen() {
        let mainStoryboard = UIStoryboard(name: "Infrastructure", bundle: nil)
        let mainVc = mainStoryboard.instantiateViewController(withIdentifier: "main") as! MainViewController
        self.present(mainVc, animated: true, completion: nil)
    }
}

