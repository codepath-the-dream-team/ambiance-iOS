//
//  AppDelegate.swift
//  Ambiance
//
//  Created by Matthew Carroll on 11/6/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var alexaNotificationItem : [String: String]?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        initializeParse(launchOptions: launchOptions)
        registerForPushNotifications(application: application)
        
        do {
            let avSession = AVAudioSession.sharedInstance()
            try avSession.setCategory(AVAudioSessionCategoryPlayback)
            try avSession.setActive(true)
            
            NSLog("Set AVSession to allow Bluetooth")
        } catch {
            NSLog("Failed to set AVAudioSession Category")
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        return handled
    }

    private func initializeParse(launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        Parse.initialize(
            with: ParseClientConfiguration(block: { (configuration:ParseMutableClientConfiguration) -> Void in
                configuration.applicationId = "SXQu86CkKMYI3iuKhJHCQqCGtws3vT3c9eWE9WO2"
                configuration.clientKey = nil  // set to nil assuming you have not set clientKey
                configuration.server = "https://codepath-ambiance.herokuapp.com/parse"
            }))
        PFFacebookUtils.initializeFacebook(applicationLaunchOptions: launchOptions)
    }
    
    private func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(
            types: [.badge, .sound, .alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Push registration failed \(error)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        print("Device token for push \(token)")
        let installation = PFInstallation.current()
        installation?.setDeviceTokenFrom(deviceToken)
        installation?.saveInBackground()
        // This token needs to be stored somewhere!!!!
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .none {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("RemoteNotification received \(userInfo)");
        let aps = userInfo["aps"] as! [String: AnyObject]
        postAlarmNotification(notificationDictionary: aps)
        application.applicationIconBadgeNumber = 0;
    }
    
    func postAlarmNotification(notificationDictionary:[String: AnyObject]) {
        print("postAlarmNotification");
        PFPush.handle(notificationDictionary);
        if let alertItem = notificationDictionary["alert"] as? String {
            // Hopefully alertItem is one of "start", "snooze", "stop"
            let userInfo = [ "action" : alertItem ]
            self.alexaNotificationItem = userInfo // Save it in case MainVC isn't ready, MainVC will clear this data.
            NotificationCenter.default.post(name: .alexaRequestNotification, object: self, userInfo: userInfo)
        }
    }
    
}

