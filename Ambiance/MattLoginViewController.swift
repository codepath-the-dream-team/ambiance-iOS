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


class MattLoginViewController: UIViewController {

    // TODO: remove this
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .orange
    }
    
    @IBAction func facebookLoginTapped(_ sender: AnyObject) {
        if !Utils.loggedIn() {
            print("logging in")
//            Utils.loginWithFacebook(success: { (dictionary: NSDictionary) in
//                print("dictionary is: \(dictionary)")
//                User.currentUser = User(dicitonary: dictionary)
//                self.user = User.currentUser
//                self.userLoggedIn(user: self.user!)
//                }, failure: { (error: Error) in
//                    print(error.localizedDescription)
//            })

            Utils.loginWithFacebook(success: { (user: User) in
                NSLog("Successfully logged in with Facebook.")
                self.user = user
                self.userLoggedIn(user: user)
            }, failure: { (error: Error) in
                NSLog("Failed to login with Facebook")
            })
            
        } else {
            self.user = User.currentUser
            userLoggedIn(user: self.user!)
        }
        
    }
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func userLoggedIn(user: User) {
        User.currentUser = user
        
        let mainStoryboard = UIStoryboard(name: "Infrastructure", bundle: nil)
        let mainVc = mainStoryboard.instantiateViewController(withIdentifier: "main") as! MainViewController
        mainVc.user = user
        self.present(mainVc, animated: true, completion: nil)
    }
}

