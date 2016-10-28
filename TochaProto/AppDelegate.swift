
//
//  AppDelegate.swift
//  TochaProto
//
//  Created by Mathis D on 03/12/2015.
//  Copyright © 2015 LaTV. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SwiftyJSON
import Fabric
import Crashlytics
import Amplitude_iOS

public var testing = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        registerForPushNotifications(application: application)
        
        IQKeyboardManager.sharedManager().enable = true
        
        initManagers()
        
        // Crashlytics
        Fabric.with([Crashlytics.self])
                
        // Facebook SDK
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Amplitude Init
        Amplitude.instance().initializeApiKey("792a2eced82bad1ee03a8f0f874c70f5")
        
        UserGameStateManager.sharedInstance.authenticateLocalPlayer()
        
        return true
    }
        
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool
    {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        //TODO: RESUME THE GAME HERE
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        Amplitude.instance().logEvent("ApplicationDidEnterBackground")
        NotificationCenter.default.post(name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
        Amplitude.instance().logEvent("ApplicationOpened")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        // Amplitude Event
        Amplitude.instance().logEvent("ApplicationWillTerminate")
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .none {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register to apple push notification")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        UserSessionManager.sharedInstance.save(deviceToken: deviceTokenString)
    }
    
    func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    

// MARK: Facebook Sign In
    
    func facebookSignIn(_ success:@escaping () -> Void, fail failure: @escaping (_ error: Error?) -> Void) {
        if((FBSDKAccessToken.current()) != nil) {
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email, gender, birthday"]).start(completionHandler: { (connection, result, error) -> Void in
                
                if (error == nil) {
                    print("Facebook authentication result : \(result)")
                    
                    // User access token
                    let accessToken = FBSDKAccessToken.current().tokenString as String
                    
                    UserSessionManager.sharedInstance.connectByFacebook(
                        withFacebookToken: accessToken,
                        success: {
                            success()
                        }, fail: { (error) in
                            print("error saving Facebook user data in database : \(error)")
                            failure(error)
                    })
                } else {
                    print("Facebook get user data : error : \(error)")
                    failure(error as Error?)
                }
            })
        }
    }

    func initManagers() {
        _ = UserSessionManager.sharedInstance
        _ = UserGameStateManager.sharedInstance
        
        // Load all products
        _ = ProductManager.sharedInstance
        
        _ = NavSchemeManager.sharedInstance
    }
}

