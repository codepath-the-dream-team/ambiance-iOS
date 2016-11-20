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
    
    static var loginSuccess: ((NSDictionary) -> ())?
    static var loginFailure: ((Error) -> ())?
    
    class func notLoggedIn() -> Bool {
        let user = PFUser.current()
        return user == nil || !PFFacebookUtils.isLinked(with: user!)
    }
    class func loggedIn() -> Bool {
        return !notLoggedIn()
    }
    
    class func loginWithFacebook(success: @escaping (NSDictionary)->(),failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        PFFacebookUtils.logInInBackground(withReadPermissions: ["public_profile", "email", "user_friends"], block: { (user: PFUser?, error: Error?) in
            if user == nil {
                print("The user cancelled the Facebook login (user is nil)")
                self.loginFailure?(error!)
            } else {
                print("The user successfully logged in with Facebook (user is NOT nil)")
                // This allows us to send push notifications to specific users
                if let installation = PFInstallation.current() {
                    installation["user"] = PFUser.current()
                    installation.saveEventually()
                }
                // Get FB info
                Utils.getFBInfo(completion: { (dictionary: NSDictionary) in
                    self.loginSuccess!(dictionary)
                })
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
    
    class func syncSavedUserWithParse(success: @escaping (NSDictionary)->(),failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        Utils.getFBInfo(completion: { (dictionary: NSDictionary) in
            self.loginSuccess!(dictionary)
        })
    }
    
    
    class func getFBInfo(completion: @escaping (NSDictionary) -> Void)  {
        let user = PFUser.current()

        if notLoggedIn() {
            return
        }
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
                var userData:[String:AnyObject] = result as! [String : AnyObject]
                let picture:[String:AnyObject] = userData["picture"] as! [String : AnyObject]
                let imageData:[String:AnyObject] = picture["data"] as! [String : AnyObject]
                user?.setValue(userData["id"], forKey: "fbId")
                user?.setValue(userData["first_name"], forKey: "firstName")
                user?.setValue(userData["last_name"], forKey: "lastName")
                user?.setValue(imageData["url"], forKey: "imageURLString")
                if (userData["alarmSchedule"] != nil) {
                    user?.setValue(userData["alarmSchedule"], forKey: "alarmSchedule")
                    
                } else {
                    print("creating alarm schedule")
                    let alarmSchedule = AlarmSchedule()
                    let parseAlarmSchedule = PFObject(className: "AlarmSchedule", dictionary: alarmSchedule.dictionary)
                    userData["alarmSchedule"] = alarmSchedule.dictionary as NSDictionary
                    user?.setValue(parseAlarmSchedule, forKey: "alarmSchedule")
                }
                user?.email = userData["email"] as! String?
                user?.saveInBackground(block: { (result: Bool, error: Error?) in
                    if result {
                        print("successfully logged in!")
                    }
                    if error != nil {
                        print("Error: \(error?.localizedDescription)")
                    }
                    
                })
                completion(userData as NSDictionary)
            }
        })
    }
    
}
