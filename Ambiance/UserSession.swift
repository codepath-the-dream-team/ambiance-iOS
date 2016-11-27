//
//  UserSession.swift
//  Ambiance
//
//  Created by Matthew Carroll on 11/21/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import Foundation
import Parse
import ParseFacebookUtilsV4

// UserSession represents a user's interaction with our app.  If the app is
// running then there is a UserSession.  A UserSession can represent an
// anonymous user or a logged in user - user isUserLoggedIn() to
// differentiate between the two.
//
// To log a user in, user login().
//
// To log a user out, user logout().
//
class UserSession {
    
    public static var shared: UserSession = UserSession()
    
    public var loggedInUser: User?
    
    public func isUserLoggedIn() -> Bool {
        return false
    }
    
    // Note: this method is a rabbit hole because methods are chained one
    // after the other but I didn't know how to compose them from within
    // this method directly.  So you'll need to jump down and down through
    // the method calls.
    public func login(success: @escaping (User) -> (), failure: @escaping (Error?) -> ()) {
        if let user = loggedInUser {
            // User is already logged in. Immediately invoke success.
            success(user)
        } else {
            // User is not already logged in. Log the user in via Facebook.
            loginWithFacebook(success: success, failure: failure)
        }
    }
    
    public func logout() {
        loggedInUser = nil
        PFUser.logOut()
    }
    
    // Attempts to restore a previous UserSession.  User information is
    // cached by the Parse SDK and so PFUser.current() is used to check for
    // an existing session which is then reloaded and rebuilt.
    public func restorePreviousSessionIfPossible(completion: @escaping (Bool) -> ()) {
        NSLog("Checking for an existing UserSession to restore...")
        if let parseUser = PFUser.current(), PFFacebookUtils.isLinked(with: parseUser) {
            NSLog("Previous UserSession was found. Attempting to restore...")
            // There is a cached Parse user. We'll fetch the latest info from
            // Parse and then use it to create a User.
            parseUser.fetchIfNeededInBackground(block: { (updatedParseUser: PFObject?, error: Error?) in
                if nil == error {
                    NSLog("Successfully loaded PFUser info. Now loading user's Alarm Schedule from Parse.")
                    // We retrieved the latest PFUser info. Now retrieve the
                    // Parse User's Alarm Schedule.
                    self.loadAlarmSchedule(forParseUser: parseUser, onComplete: { (success: Bool) in
                        NSLog("Was User Schedule retrieved? \(success)")
                        if success {
                            NSLog("Filling in any missing User configuration.")
                            // Successfully retrieved User Schedule. Now fill in any
                            // other missing pieces.
                            self.fillMissingUserData(forParseUser: parseUser, onComplete: { (wasSuccess: Bool) in
                                if wasSuccess {
                                    NSLog("Done filling in any missing User configuration.")
                                    // Successfully filled missing pieces. Start Session.
                                    self.startSession(withParseUser: parseUser, success: { (user: User) in
                                            // User session has started.
                                            completion(true)
                                        }, failure: { (error: Error?) in
                                            // Failed to start user session.
                                            completion(false)
                                    })
                                } else {
                                    // Failed to fill in missing pieces. Cannot start
                                    // Session. Forcibly logout user.
                                    PFUser.logOut()
                                    completion(false)
                                }
                            })
                        } else {
                            // Failed to retireve User Schedule. Cannot start Session.
                            // Forcibly logout user.
                            PFUser.logOut()
                            completion(false)
                        }
                    })
                } else {
                    // We failed to retrieve the latest PFUser info. Forcibly
                    // log the user out so they can try again.
                    PFUser.logOut()
                    completion(false)
                }
            })
        } else {
            NSLog("No previous UserSession was found.")
            completion(false)
        }
    }
    
    // Facebook Login Step 1:
    // Authenticates the user with Facebook. Upon completion of
    // authentication, this method then invokes another method that retrieves
    // the user's profile information and then saves it to a Parse User.
    private func loginWithFacebook(success: @escaping (User) -> (), failure: @escaping (Error?) -> ()) {
        // Authenticate with Facebook.
        NSLog("Authenticating with Facebook.")
        PFFacebookUtils.logInInBackground(withReadPermissions: ["public_profile", "email", "user_friends"], block: { (fbookUser: PFUser?, error: Error?) in
            // Check if the user was authenticated....
            if fbookUser == nil {
                // User was not authenticated. Fail.
                NSLog("The user cancelled the Facebook login.")
                failure(error)
            } else {
                // User was authenticated. Now retrieve relevant Facebook user information.
                NSLog("The user successfully logged in with Facebook")
                
                // This allows us to send push notifications to specific users
                if let installation = PFInstallation.current() {
                    installation["user"] = PFUser.current()
                    installation.saveEventually()
                }
                
                // The side effect of success authentication is that the
                // global PFUser.current() is populated by the Parse SDK.
                let parseUser = PFUser.current()!
                
                // We need to create a proxy failure function because if
                // login fails any time after this point, we need to make
                // sure to forcibly logout the PFUser.current()
                let failureWrapper = { (error: Error?) in
                    // Forcibly logout the PFUser.
                    PFUser.logOut()
                    
                    // Forward the failure to the original callback.
                    failure(error)
                }
                
                self.retrieveFacebookUserInfo(forParseUser: parseUser, success: success, failure: failureWrapper)
            }
        })
    }
    
    // Facebook Login Step 2:
    // If the user has been authenticated with Facebook, this method
    // retrives that user's relevant profile information and then creates
    // a Parse user with that information.
    private func retrieveFacebookUserInfo(forParseUser parseUser: PFUser, success: @escaping (User) -> (), failure: @escaping (Error?) -> ()) {
        NSLog("Retrieving user's Facebook profile info.")
        let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"first_name, last_name, id, email, picture.type(large)"])
        
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if nil == error {
                NSLog("Successfully retrieved user's Facebook profile info.")
                // Retrieves the user's Facebook profile information.
                let fbookUserInfo:[String:AnyObject] = result as! [String : AnyObject]
                
                // Use the user's Facebook info to create a Parse User for
                // our app.
                self.createUser(inParse: parseUser, withFacebookUserInfo: fbookUserInfo, success: success, failure: failure)
            } else {
                // Failed to retrieve Facebook user's info.
                print("Error: \(error?.localizedDescription)")
                failure(error)
            }
        })
    }
    
    // Facebook Login Step 3:
    // Given the user's Facebook info, creates a Parse User for our app.
    private func createUser(inParse parseUser: PFUser, withFacebookUserInfo fbookUserInfo: [String : AnyObject], success: @escaping (User) -> (), failure: @escaping (Error?) -> ()) {
        NSLog("Creating Parse User from Facebook profile info.")
        
        // Marshall the Facebook user data over to the Parse User.
        apply(facebookUserData: fbookUserInfo, to: parseUser)
        
        // If the User doesn't already have an Alarm Schedule, create
        // a default schedule and set it.
        if (nil == parseUser.object(forKey: "alarmSchedule")) {
            NSLog("Creating a default Alarm Schedule for new User")
            parseUser.setObject(createDefaultAlarmSchedule(), forKey: "alarmSchedule")
        }
        
        // If the User doesn't already have an Alarm Configuration, create
        // a default configuration and set it.
        if (nil == parseUser.value(forKey: "alarmConfiguration")) {
            NSLog("Creating a default Alarm Configuration for new User")
            parseUser.setValue(createDefaultAlarmConfiguration(), forKey: "alarmConfiguration")
        }
        
        // If the User doesn't already have a Sleep Configuration, create a
        // default configuration and set it.
        if (nil == parseUser.value(forKey: "sleepConfiguration")) {
            NSLog("Creating a default Sleep Configuration for existing User")
            parseUser.setValue(createDefaultSleepConfiguration(), forKey: "sleepConfiguration")
        }
        
        NSLog("Saving User to Parse.")
        parseUser.saveInBackground { (result: Bool, error: Error?) in
            if result {
                NSLog("Successfully saved User to Parse.")
                self.startSession(withParseUser: parseUser, success: success, failure: failure)
            } else {
                NSLog("Failed to save Parse User. Error: \(error?.localizedDescription)")
            }
        }
    }
    
    private func fillMissingUserData(forParseUser parseUser: PFUser, onComplete: @escaping (Bool) -> ()) {
        var didFillMissingData = false
        
        // If the User doesn't already have an Alarm Schedule, create
        // a default schedule and set it.
        if (nil == parseUser.object(forKey: "alarmSchedule")) {
            NSLog("Creating a default Alarm Schedule for existing User")
            parseUser.setObject(createDefaultAlarmSchedule(), forKey: "alarmSchedule")
            didFillMissingData = true
        }
        
        // If the User doesn't already have an Alarm Configuration, create
        // a default configuration and set it.
        if (nil == parseUser.value(forKey: "alarmConfiguration") || nil == AlarmConfiguration(from: parseUser.value(forKey: "alarmConfiguration") as! [String : AnyObject])) {
            NSLog("Creating a default Alarm Configuration for existing User")
            parseUser.setValue(createDefaultAlarmConfiguration(), forKey: "alarmConfiguration")
            didFillMissingData = true
        }
        
        // If the User doesn't already have a Sleep Configuration, create a
        // default configuration and set it.
        if (nil == parseUser.value(forKey: "sleepConfiguration") || nil == SleepConfiguration(fromDictionary: parseUser.value(forKey: "sleepConfiguration") as! [String : AnyObject])) {
            NSLog("Creating a default Sleep Configuration for existing User")
            parseUser.setValue(createDefaultSleepConfiguration(), forKey: "sleepConfiguration")
            didFillMissingData = true
        }
        
        if didFillMissingData {
            NSLog("Saving existing User with new data to Parse.")
            parseUser.saveInBackground { (wasSuccess: Bool, error: Error?) in
                if (wasSuccess) {
                    NSLog("Successfully saved User to Parse")
                    onComplete(true)
                } else {
                    NSLog("Failed to save Parse User. Error: \(error?.localizedDescription)")
                    onComplete(false)
                }
            }
        } else {
            // Nothing to fill in. Report immediate success.
            NSLog("No missing data to fill. Reporting immediate success.")
            onComplete(true)
        }
    }
    
    private func loadAlarmSchedule(forParseUser parseUser: PFUser, onComplete: @escaping (Bool) ->()) {
        // Retrieve the Parse User's Alarm Schedule.
        let alarmSchedulePfObject = parseUser.value(forKey: "alarmSchedule") as! PFObject?
        
        if alarmSchedulePfObject != nil {
            (parseUser.value(forKey: "alarmSchedule") as! PFObject).fetchIfNeededInBackground(block: { (schedule: PFObject?, error: Error?) in
                if nil == error {
                    NSLog("Successfully loaded Alarm Schedule from Parse.")
                    onComplete(true)
                } else {
                    // Failed to retrieve Alarm Schedule.
                    NSLog("Failed to load the User's Alarm Schedule: \(error)")
                    onComplete(false)
                }
            })
        } else {
            // For some reason the Parse User doesn't have an
            // alarmSchedule property. This is probably corrupt data.
            NSLog("Parse User didn't have alarmSchedule. Probably corrupt data. Failed to recreate UserSession.")
            onComplete(false)
        }
    }
    
    // Facebook Login Step 4:
    // After a fully hydrated Parse PFUser has been created, this method
    // uses that PFUser to create our own App User and then sets that User
    // as the loggedInUser.
    //
    // This function is also shared by the session restoration behavior.
    private func startSession(withParseUser parseUser: PFUser, success: @escaping (User) -> (), failure: @escaping (Error?) -> ()) {
        NSLog("Creating app User based on Parse User.")
        let user = User(parseUser: parseUser)
        
        NSLog("Setting new User as loggedInUser")
        loggedInUser = user
        
        NSLog("Successfully completed user login.")
        success(user)
    }
    
    // Given a user's Facebook information, transfers that information into a
    // Parse PFUser Object.
    private func apply(facebookUserData: [String : AnyObject], to user:PFUser) {
        let picture:[String:AnyObject] = facebookUserData["picture"] as! [String : AnyObject]
        let imageData:[String:AnyObject] = picture["data"] as! [String : AnyObject]
        
        user.setValue(facebookUserData["id"], forKey: "fbId")
        user.setValue(facebookUserData["first_name"], forKey: "firstName")
        user.setValue(facebookUserData["last_name"], forKey: "lastName")
        user.setValue(imageData["url"], forKey: "imageURLString")
        user.email = facebookUserData["email"] as? String
    }
    
    // Creates an Alarm Schedule with no daily alarms.
    private func createDefaultAlarmSchedule() -> PFObject {
        let alarmSchedule = AlarmSchedule()
        NSLog("Alarm Schedule: \(alarmSchedule)")
        NSLog("Serializing default AlarmSchedule: \(alarmSchedule.serializeToDictionary())")
        let parseAlarmSchedule = PFObject(className: "AlarmSchedule", dictionary: alarmSchedule.serializeToDictionary())
        return parseAlarmSchedule
    }
    
    private func createDefaultAlarmConfiguration() -> [String : AnyObject] {
        let alarmConfiguration = AlarmConfiguration()
        NSLog("Alarm Configuration: \(alarmConfiguration)")
        NSLog("Serializing default AlarmConfiguration: \(alarmConfiguration.serializeToDictionary)")
        return alarmConfiguration.serializeToDictionary()
    }
    
    private func createDefaultSleepConfiguration() -> [String : AnyObject] {
        let sleepConfiguration = SleepConfiguration()
        NSLog("Serializing default SleepConfiguration: \(sleepConfiguration.serializeToDictionary)")
        return sleepConfiguration.serializeToDictionary()
    }
}
