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
        let window: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        
        if UserSessionManager.sharedInstance.isLogged() {
            window.rootViewController = window.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "idHomeNavController") as! UINavigationController
            
        } else {
            window.rootViewController = window.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "idStarterNavController")
        }
    }
    
    func changeRootViewController(_ viewController: UIViewController) {
        let snapShot = (((UIApplication.shared.delegate) as! AppDelegate)).window!.snapshotView(afterScreenUpdates: true)
        viewController.view.addSubview(snapShot!)
        (((UIApplication.shared.delegate) as! AppDelegate)).window!.rootViewController = viewController
        UIView.animate(withDuration: 0.3,
                                   animations: { 
                                    snapShot?.layer.opacity = 0.0
                                    snapShot?.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
            }, completion: { (finished) in
                snapShot?.removeFromSuperview()
        }) 
    }
}
