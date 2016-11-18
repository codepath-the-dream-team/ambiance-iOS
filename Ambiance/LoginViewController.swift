//
//  ViewController.swift
//  Ambiance
//
//  Created by Matthew Carroll on 11/6/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit
import ParseFacebookUtilsV4
import Parse

class LoginViewController: UIViewController {

    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .orange
    }
    
    @IBAction func facebookLoginTapped(_ sender: AnyObject) {
        if Utils.notLoggedIn() {
            print("logging in")
            Utils.loginWithFacebook(success: { (dictionary: NSDictionary) in
                print("dictionary is: \(dictionary)")
                User.currentUser = User(dicitonary: dictionary)
                self.user = User.currentUser
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }, failure: { (error: Error) in
                    print(error.localizedDescription)
            })
        } else {
            print("logged in")
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSegue" {
            let destVC = segue.destination as! HomeViewController
            if let url = user?.profileImageURL {
                destVC.profileImageURL = url
                destVC.user = self.user! as User
            } else {
                destVC.profileImageURL = nil
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

