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
        
        if UserSessionManager.sharedInstance.isLogged() {
            window.rootViewController = window.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("idDochaTabBarController") as! UITabBarController
            let tabBarController = window.rootViewController as! UITabBarController
            tabBarController.selectedIndex = 1
        } else {
            window.rootViewController = window.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("idStarterNavController")
        }
    }
    
    func changeRootViewController(viewController: UIViewController) {
        let snapShot = (((UIApplication.sharedApplication().delegate) as! AppDelegate)).window!.snapshotViewAfterScreenUpdates(true)
        viewController.view .addSubview(snapShot)
        (((UIApplication.sharedApplication().delegate) as! AppDelegate)).window!.rootViewController = viewController
        UIView.animateWithDuration(0.3,
                                   animations: { 
                                    snapShot.layer.opacity = 0.0
                                    snapShot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
            }) { (finished) in
                snapShot.removeFromSuperview()
        }
    }
}
