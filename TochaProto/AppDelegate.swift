
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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Crashlytics
        Fabric.with([Crashlytics.self])
        
        IQKeyboardManager.sharedManager().enable = true
        
        initManagers()
        
        // Sign in user
//        if  UserSessionManager.sharedInstance.isLogged() {
//            UserSessionManager.sharedInstance.signIn({
//                    print("Sign in successful")
//                }) { (error, listErrors) in
//                    PopupManager.sharedInstance.showErrorPopup("Oups !", message: "La connexion internet semble interrompue...", completion: nil)
//            }
//        }
        
        NavSchemeManager.sharedInstance.initRootController()
        
        let apperance = UITabBarItem.appearance()
        let attributes = [NSFontAttributeName:UIFont(name: "Montserrat-Regular", size: 10)!]
        apperance.setTitleTextAttributes(attributes, for: UIControlState())
        
        // Facebook SDK
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Amplitude Init
        Amplitude.instance().initializeApiKey("792a2eced82bad1ee03a8f0f874c70f5")
        
        return true
    }
        
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool
    {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation) || GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
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
    

// MARK: Facebook Sign In
    
    func facebookSignIn(_ success:@escaping () -> Void, fail failure: @escaping (_ error: NSError?, _ listError: [AnyObject]?) -> Void) {
        if((FBSDKAccessToken.current()) != nil) {
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email, gender, birthday"]).start(completionHandler: { (connection, result, error) -> Void in
                
                if (error == nil) {
                    print("Facebook authentication result : \(result)")
                    var dicoUserData = [String:AnyObject]()
                    
                    // User access token
                    dicoUserData[UserDataKey.kFacebookToken] = FBSDKAccessToken.current().tokenString as AnyObject?
                    
                    UserSessionManager.sharedInstance.connectByFacebook(
                        dicoUserData,
                        success: {
                            success()
                        }, fail: { (error, listError) in
                            print("error saving Facebook user data in database : \(error)")
                            failure(error: error, listError: listError)
                    })
                } else {
                    print("Facebook get user data : error : \(error)")
                    failure(error as NSError?, nil)
                }
            })
        }
    }
    

// MARK: GooglePlus Sign In
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: NSError!) {
        if (error == nil) {
            var dicoUserData = [String:AnyObject]()
            
            // Perform any operations on signed in user here.
            dicoUserData["id"] = user.userID as AnyObject?                  // For client-side use only!
            dicoUserData["token"] = user.authentication.idToken as AnyObject? // Safe to send to the server
            dicoUserData["first_name"] = user.profile.givenName as AnyObject?
            dicoUserData["last_name"] = user.profile.familyName as AnyObject?
            dicoUserData["email"] = user.profile.email as AnyObject?
            if user.profile.hasImage {
                dicoUserData["image_url"] = user.profile.imageURL(withDimension: 50).URLString
            }
            
            if UserSessionManager.sharedInstance.isLogged() {
            
                UserSessionManager.sharedInstance.connectByGooglePlus(dicoUserData,
                    success: {
                        let viewController = self.window?.rootViewController
                    
                        if UserSessionManager.sharedInstance.dicoUserDataInscription == nil {
                            let categoryViewController = viewController?.storyboard?.instantiateViewController(withIdentifier: "idInscriptionCategorySelectionViewController") as!InscriptionCategorySelectionViewController
                            categoryViewController.comeFromConnexionVC = true
                            viewController?.navigationController?.pushViewController(categoryViewController, animated: true)
                        } else {
                            let categoryViewController = viewController?.storyboard?.instantiateViewController(withIdentifier: "idMenuNavController") as! UINavigationController
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
                                    let categoryViewController = viewController?.storyboard?.instantiateViewController(withIdentifier: "idInscriptionCategorySelectionViewController") as!InscriptionCategorySelectionViewController
                                    categoryViewController.comeFromConnexionVC = true
                                    viewController?.navigationController?.pushViewController(categoryViewController, animated: true)
                                } else {
                                    let homeViewController = viewController?.storyboard?.instantiateViewController(withIdentifier: "idHomeNavController") as! HomeViewController
                                    NavSchemeManager.sharedInstance.changeRootViewController(homeViewController)
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
        
        // Load all products
        ProductManager.sharedInstance
        ProductManager.sharedInstance.loadProductsWithCurrentCategory()
        
        NavSchemeManager.sharedInstance
    }
}

