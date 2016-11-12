//
//  Utils.swift
//  Ambiance
//
//  Created by Ryan Chee on 11/11/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import Foundation
import Parse
import ParseFacebookUtilsV4

class Utils {
    
    class func notLoggedIn() -> Bool {
        let user = PFUser.current()
        return user == nil || !PFFacebookUtils.isLinked(with: user!)
    }
    class func loggedIn() -> Bool {
        return !notLoggedIn()
    }
    
    class func logInWithFacebook() {
        PFFacebookUtils.logInInBackground(withReadPermissions: ["public_profile", "email", "user_friends"], block: { (user: PFUser?, error: Error?) in
            if user == nil {
                print("The user cancelled the Facebook login (user is nil)")
            } else {
                print("The user successfully logged in with Facebook (user is NOT nil)")
                // This allows us to send push notifications to specific users
                if let installation = PFInstallation.current() {
                    installation["user"] = PFUser.current()
                    installation.saveEventually()
                }
                // Get FB info
                Utils.getFBInfo()
            }
        })
    }
    
    class func logout() {
        if notLoggedIn() {
            return
        }
        print("Before log out: \(PFUser.current())")
        PFUser.logOut()
        print("Logged out! User was invalidated: \(PFUser.current())")
    }
    
    
    class func getFBInfo() {
        if notLoggedIn() {
            return
        }
        let user = PFUser.current()
        print("performing request to FB for information")
        
        let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"first_name, last_name, id, email, picture.type(large)"])
        
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error?.localizedDescription)")
            }
            else
            {
                let data:[String:AnyObject] = result as! [String : AnyObject]
                let picture:[String:AnyObject] = data["picture"] as! [String : AnyObject]
                let imageData:[String:AnyObject] = picture["data"] as! [String : AnyObject]
                print("url: \(imageData["url"]!)")
                print("name: " + (data["first_name"]! as! String) + " " + (data["last_name"]! as! String))
                print("email: " + (data["email"]! as! String))
                user?.setValue(data["id"], forKey: "fbId")
                user?.setValue(data["first_name"], forKey: "firstName")
                user?.setValue(data["last_name"], forKey: "lastName")
                user?.setValue(imageData["url"], forKey: "imageURLString")
                user?.email = data["email"] as! String?
                user?.saveInBackground(block: { (result: Bool, error: Error?) in
                    if result {
                        print("successfully logged in!")
                    }
                    if error != nil {
                        print("Error: \(error?.localizedDescription)")
                    }
                    
                })
            }
        })
    }
    
}
