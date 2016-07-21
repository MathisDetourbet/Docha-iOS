
//
//  AppDelegate.swift
//  TochaProto
//
//  Created by Mathis D on 03/12/2015.
//  Copyright © 2015 LaTV. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleSignIn
import Google
import SwiftyJSON
import Fabric
import Crashlytics
import Amplitude_iOS

public var testing = true

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Crashlytics
        Fabric.with([Crashlytics.self])
        
        IQKeyboardManager.sharedManager().enable = true
        
        initManagers()
        
        // Sign in user
        if  UserSessionManager.sharedInstance.isLogged() {
            UserSessionManager.sharedInstance.signIn({
                    print("Sign in successful")
                }) { (error, listErrors) in
                    self.window?.currentViewController()?.presentViewController(DochaPopupHelper.sharedInstance.showErrorPopup("Oups !", message: "La connexion internet semble interrompue...")!, animated: true, completion: nil)
                    UserSessionManager.sharedInstance.logout()
            }
        }
        
        NavSchemeManager.sharedInstance.initRootController()
        
        // Facebook SDK
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Amplitude Init
        Amplitude.instance().initializeApiKey("792a2eced82bad1ee03a8f0f874c70f5")
        
        return true
    }
        
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool
    {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation) || GIDSignIn.sharedInstance().handleURL(url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        //TODO: RESUME THE GAME HERE
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        Amplitude.instance().logEvent("ApplicationDidEnterBackground")
        NSNotificationCenter.defaultCenter().postNotificationName(UIApplicationDidEnterBackgroundNotification, object: nil)
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
        Amplitude.instance().logEvent("ApplicationOpened")
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        // Amplitude Event
        Amplitude.instance().logEvent("ApplicationWillTerminate")
    }
    
    // MARK: Facebook Sign In
    func facebookSignIn(success:() -> Void, fail failure: (error: NSError?, listError: [AnyObject]?) -> Void) {
        if((FBSDKAccessToken.currentAccessToken()) != nil) {
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email, gender, birthday"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                
                if (error == nil) {
                    print("Facebook authentication result : \(result)")
                    var dicoUserData = [String:AnyObject]()
                    
                    // User access token
                    dicoUserData[UserDataKey.kFacebookToken] = FBSDKAccessToken.currentAccessToken().tokenString
                    //dicoUserData[UserDataKey.kFacebookID] =
                    
                    self.window?.currentViewController()?.presentViewController(DochaPopupHelper.sharedInstance.showLoadingPopup()!, animated: true, completion: nil)
                    
                    UserSessionManager.sharedInstance.connectByFacebook(
                        dicoUserData,
                        success: {
                            self.window?.currentViewController()?.dismissViewControllerAnimated(false, completion: nil)
                            success()
                        }, fail: { (error, listError) in
                            self.window?.currentViewController()?.dismissViewControllerAnimated(false, completion: nil)
                            print("error saving Facebook user data in database : \(error)")
                            failure(error: error, listError: listError)
                    })
                } else {
                    print("Facebook get user data : error : \(error)")
                }
            })
        }
    }
    
    // MARK: GooglePlus Sign In
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if (error == nil) {
            var dicoUserData = [String:AnyObject]()
            
            // Perform any operations on signed in user here.
            dicoUserData["id"] = user.userID                  // For client-side use only!
            dicoUserData["token"] = user.authentication.idToken // Safe to send to the server
            dicoUserData["first_name"] = user.profile.givenName
            dicoUserData["last_name"] = user.profile.familyName
            dicoUserData["email"] = user.profile.email
            if user.profile.hasImage {
                dicoUserData["image_url"] = user.profile.imageURLWithDimension(50).URLString
            }
            
            if UserSessionManager.sharedInstance.isLogged() {
            
                UserSessionManager.sharedInstance.connectByGooglePlus(dicoUserData,
                    success: {
                        let viewController = self.window?.rootViewController
                    
                        if UserSessionManager.sharedInstance.dicoUserDataInscription == nil {
                            let categoryViewController = viewController?.storyboard?.instantiateViewControllerWithIdentifier("idInscriptionCategorySelectionViewController") as!InscriptionCategorySelectionViewController
                            categoryViewController.comeFromConnexionVC = true
                            viewController?.navigationController?.pushViewController(categoryViewController, animated: true)
                        } else {
                            let categoryViewController = viewController?.storyboard?.instantiateViewControllerWithIdentifier("idMenuNavController") as! UINavigationController
                            NavSchemeManager.sharedInstance.changeRootViewController(categoryViewController)
                        }
                    }, fail: { (error, listError) in
                        print("error saving GooglePlus user data in database : \(error)")
                        print("list error : \(listError)")
                })
                
            } else {
                UserSessionManager.sharedInstance.inscriptionByGooglePlus(dicoUserData,
                    success: { (session) in
                        
                        dicoUserData = session.generateJSONFromUserSession()!
                        
                        UserSessionManager.sharedInstance.connectByGooglePlus(dicoUserData,
                            success: {
                                let viewController = self.window?.rootViewController
                                
                                if UserSessionManager.sharedInstance.dicoUserDataInscription == nil {
                                    let categoryViewController = viewController?.storyboard?.instantiateViewControllerWithIdentifier("idInscriptionCategorySelectionViewController") as!InscriptionCategorySelectionViewController
                                    categoryViewController.comeFromConnexionVC = true
                                    viewController?.navigationController?.pushViewController(categoryViewController, animated: true)
                                } else {
                                    let categoryViewController = viewController?.storyboard?.instantiateViewControllerWithIdentifier("idDochaTabBarController") as! UITabBarController
                                    NavSchemeManager.sharedInstance.changeRootViewController(categoryViewController)
                                }
                            }, fail: { (error, listError) in
                                print("error saving GooglePlus user data in database : \(error)")
                                print("list error : \(listError)")
                        })
                        
                    }, fail: { (error, listError) in
                        print("Error inscription GooglePlus : \(error)")
                })
            }
        } else {
            print("GooglePlus get user data : error : \(error)")
            print("\(error.localizedDescription)")
        }
    }
    
    func initManagers() {
        UserSessionManager.sharedInstance
        UserGameStateManager.sharedInstance
        ProductManager.sharedInstance
        NavSchemeManager.sharedInstance
    }
}

