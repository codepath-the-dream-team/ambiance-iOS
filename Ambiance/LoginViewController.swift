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

    var user: PFUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .orange
    }
    
    @IBAction func facebookLoginTapped(_ sender: AnyObject) {
//        let permissions = ["public_profile", "email", "user_friends"]
//        let fbLoginManager = FBSDKLoginManager.init()
//        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self) { (result: FBSDKLoginManagerLoginResult?, error: Error?) in
//            if (error != nil) {
//                // Process error
//            }
//            else if (result?.isCancelled)! {
//                // Handle cancellations
//            }
//            else {
//                // If you ask for multiple permissions at once, you
//                // should check if specific permissions missing
//                
//                if ((result?.grantedPermissions.contains("email"))! &&
//                    (result?.grantedPermissions.contains("public_profile"))! &&
//                    (result?.grantedPermissions.contains("id"))! &&
//                    (result?.grantedPermissions.contains("user_friends"))!) {
//                    // Do work
//                    self.getFBInfo()
//                    print("logged in")
//                    print("asdf: \(result)")
//                    print(result?.grantedPermissions.description)
//                    self.view.backgroundColor = .cyan
//                } else {
//                    print("error getting all fields")
//                }
//            }
//        }
        if Utils.notLoggedIn() {
            print("logging in")
            Utils.logInWithFacebook()
        } else {
            print("logged  in")
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }

    }
    
    func getFBInfo() {
        let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"first_name, last_name, id, email, picture.type(large)"])
        
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                let data:[String:AnyObject] = result as! [String : AnyObject]
                print("name: " + (data["first_name"]! as! String) + " " + (data["last_name"]! as! String))
                print("email: " + (data["email"]! as! String))
                print("id: " + (data["id"]! as! String))
                print(result)
                
            }
        })
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
        let destVC = segue.destination as! ViewController
        if let urlString = user?["imageURLString"] {
            destVC.profileImageURL = URL(string: urlString as! String)
        } else {
            destVC.profileImageURL = URL(string: "")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

