
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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.sharedManager().enable = true
        
        NavSchemeManager.sharedInstance.initRootController()
        
        // Facebook SDK
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // GooglePlus SDK : Initialize sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = self
        
//        ProductManager.sharedInstance.loadPacksOfProducts()
//        let inscription = true
//        if inscription {
//            let request = InscriptionRequest()
//            request.inscriptionWithDicoParameters(["user" : ["email": "mathis@docha.fr", "password": "azertyuiop"]])
//        } else {
//            let request = ConnexionRequest()
//            request.connexionWithEmail("louis@docha.fr", andPassword: "azertyuiop")
//        }
        
        //        let tabBarController = self.window?.rootViewController as! UITabBarController
        //        let tabBar = tabBarController.tabBar as UITabBar
        //        tabBar.backgroundImage = UIImage(named: "bottom-menu_tab")
        //
        //        let tabBarHomeItem = tabBar.items![0]
        //        let tabBarRankingItem = tabBar.items![1]
        //        let tabBarPlayItem = tabBar.items![2]
        //        let tabBarCategoriesItem = tabBar.items![3]
        //        let tabBarCouponsItem = tabBar.items![4]
        //
        //        tabBarHomeItem.image = UIImage(named: "home_150x117")?.imageWithRenderingMode(.AlwaysOriginal)
        //        tabBarHomeItem.selectedImage = UIImage(named: "home_selected_150x117")?.imageWithRenderingMode(.AlwaysOriginal)
        //        tabBarRankingItem.image = UIImage(named: "ranking_150x117")?.imageWithRenderingMode(.AlwaysOriginal)
        //        tabBarRankingItem.selectedImage = UIImage(named: "ranking_selected_150x117")?.imageWithRenderingMode(.AlwaysOriginal)
        //        tabBarPlayItem.image = UIImage(named: "play_150x117")?.imageWithRenderingMode(.AlwaysOriginal)
        //        tabBarPlayItem.selectedImage = UIImage(named: "play_selected_150x117")?.imageWithRenderingMode(.AlwaysOriginal)
        //        tabBarCategoriesItem.image = UIImage(named: "categories_150x117")?.imageWithRenderingMode(.AlwaysOriginal)
        //        tabBarCategoriesItem.selectedImage = UIImage(named: "categories_selected_150x117")?.imageWithRenderingMode(.AlwaysOriginal)
        //        tabBarCouponsItem.image = UIImage(named: "coupons_150x117")?.imageWithRenderingMode(.AlwaysOriginal)
        //        tabBarCouponsItem.selectedImage = UIImage(named: "coupons_selected_150x117")?.imageWithRenderingMode(.AlwaysOriginal)
        return true
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        return GIDSignIn.sharedInstance().handleURL(url,
                                                    sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String,
                                                    annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool
    {
        var options: [String: AnyObject] = [UIApplicationOpenURLOptionsSourceApplicationKey: sourceApplication!,
                                            UIApplicationOpenURLOptionsAnnotationKey: annotation]
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation) || GIDSignIn.sharedInstance().handleURL(url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    
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
            
            UserSessionManager.sharedInstance.connectByGooglePlus(
                dicoUserData,
                success: {
                    let viewController = self.window?.rootViewController?.storyboard!.instantiateViewControllerWithIdentifier("idMenuNavController") as! UINavigationController
                    NavSchemeManager.sharedInstance.changeRootViewController(viewController)
                
                }, fail: { (error, listError) in
                    print("error saving GooglePlus user data in database : \(error)")
                    print("list error : \(listError)")
            })
        } else {
            print("GooglePlus get user data : error : \(error)")
            print("\(error.localizedDescription)")
        }
    }
}

