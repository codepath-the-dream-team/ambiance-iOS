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
    
    static var loginSuccess: ((User) -> ())?
    static var loginFailure: ((Error) -> ())?
    
    class func loggedIn() -> Bool {
        let user = PFUser.current()
        if (nil != user && PFFacebookUtils.isLinked(with: user!)) {
            // We have a saved Parse User. If we haven't applied the Parse User to the
            // shared User Session, do that now.
            if nil == User.currentUser {
                // TODO: we shouldn't be doing this here. Move it to a predictable and controllable location.
                User.currentUser = User(parseUser: user!)
            }
            
            return true
        } else {
            return false
        }
    }
    
    class func loginWithFacebook(success: @escaping (User)->(),failure: @escaping (Error) -> ()) {
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
                Utils.getFBInfo(completion: { (user: User) in
                    self.loginSuccess!(user)
                })
            }
        })
    }
    
    class func syncParseUserWithParse(success: @escaping () -> (), failure: @escaping (Error?) -> ()) {
        NSLog("Updating Parse User with latest from Parse.")
        let user = PFUser.current()
        
        if let user = user {
            user.fetchInBackground(block: { (user: PFObject?, error: Error?) in
                if nil == error {
                    // Fetch the user's Alarm Schedule.
                    NSLog("Fetched the PFUser from Parse. Now fetching the Alarm Schedule.")
                    (user?.value(forKey: "alarmSchedule") as! PFObject).fetchInBackground(block: { (schedule: PFObject?, error: Error?) in
                        if nil == error {
                            NSLog("Successfully updated Parse User")
                            success()
                        } else {
                            NSLog("Failed to load the User's Alarm Schedule: \(error)")
                        }
                    })
                } else {
                    NSLog("Failed to update Parse User: \(error)")
                    NSLog("Forcibly logging out the user.")
                    PFUser.logOut()
                    failure(error)
                }
            })
        } else {
            NSLog("User isn't logged in.  No Parse User to update.")
            failure(nil)
        }
    }
    
    class func logout() {
        if !loggedIn() {
            return
        }
        print("Before log out: \(PFUser.current())")
        PFUser.logOut()
        print("Logged out! User was invalidated: \(PFUser.current())")
    }
    
//    class func syncSavedUserWithParse(success: @escaping (NSDictionary)->(),failure: @escaping (Error) -> ()) {
//        loginSuccess = success
//        loginFailure = failure
//        Utils.getFBInfo(completion: { (dictionary: NSDictionary) in
//            self.loginSuccess!(dictionary)
//        })
//    }
    
    
    private class func getFBInfo(completion: @escaping (User) -> Void)  {
        if !loggedIn() {
            return
        }
        
        let user = PFUser.current()!
        
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
                
                // Marshall the Facebook user data over to the Parse User.
                apply(facebookUserData: userData, to: user)
                
                // If the User doesn't already have an Alarm Schedule, create
                // a default schedule and set it.
                if (nil == user.object(forKey: "alarmSchedule")) {
                    user.setObject(createDefaultAlarmSchedule(), forKey: "alarmSchedule")
                }
                
//                let picture:[String:AnyObject] = userData["picture"] as! [String : AnyObject]
//                let imageData:[String:AnyObject] = picture["data"] as! [String : AnyObject]
//                user?.setValue(userData["id"], forKey: "fbId")
//                user?.setValue(userData["first_name"], forKey: "firstName")
//                user?.setValue(userData["last_name"], forKey: "lastName")
//                user?.setValue(imageData["url"], forKey: "imageURLString")
//                if (userData["alarmSchedule"] != nil) {
//                    user?.setValue(userData["alarmSchedule"], forKey: "alarmSchedule")
//                    
//                } else {
//                    print("creating alarm schedule")
//                    let alarmSchedule = AlarmSchedule()
//                    let parseAlarmSchedule = PFObject(className: "AlarmSchedule", dictionary: alarmSchedule.dictionary)
//                    userData["alarmSchedule"] = alarmSchedule.dictionary as NSDictionary
//                    user?.setValue(parseAlarmSchedule, forKey: "alarmSchedule")
//                }
//                user?.email = userData["email"] as! String?
                
                user.saveInBackground(block: { (result: Bool, error: Error?) in
                    if result {
                        print("successfully logged in!")
                        
                        completion(User(parseUser: user))
                    }
                    if error != nil {
                        print("Error: \(error?.localizedDescription)")
                    }
                    
                })
                
//                completion(userData as NSDictionary)
            }
        })
    }
    
    // Given a user's Facebook information, transfers that information into a
    // Parse PFUser Object.
    private class func apply(facebookUserData: [String : AnyObject], to user:PFUser) {
        let picture:[String:AnyObject] = facebookUserData["picture"] as! [String : AnyObject]
        let imageData:[String:AnyObject] = picture["data"] as! [String : AnyObject]
        
        user.setValue(facebookUserData["id"], forKey: "fbId")
        user.setValue(facebookUserData["first_name"], forKey: "firstName")
        user.setValue(facebookUserData["last_name"], forKey: "lastName")
        user.setValue(imageData["url"], forKey: "imageURLString")
        user.email = facebookUserData["email"] as? String
    }
    
    // Creates an Alarm Schedule with no daily alarms.
    private class func createDefaultAlarmSchedule() -> PFObject {
        let alarmSchedule = AlarmSchedule()
        NSLog("Alarm Schedule: \(alarmSchedule)")
        NSLog("Serializing default AlarmSchedule: \(alarmSchedule.serializeToDictionary())")
        let parseAlarmSchedule = PFObject(className: "AlarmSchedule", dictionary: alarmSchedule.serializeToDictionary())
        return parseAlarmSchedule
    }
    
}
