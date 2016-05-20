//
//  NavSchemeManager.swift
//  DochaProto
//
//  Created by Mathis D on 14/03/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

class NavSchemeManager {
	
    class var sharedInstance: NavSchemeManager {
        struct Singleton {
            static let instance = NavSchemeManager()
        }
        return Singleton.instance
    }
    
    func initRootController() {
        let window: UIWindow = ((UIApplication.sharedApplication().delegate?.window)!)!
        
        if true {
            window.rootViewController = window.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("idConnexionNavController")
        } else {
            window.rootViewController = window.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("idTabBarController")
            window.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("idMenuNavController")
        }
    }
	
}
