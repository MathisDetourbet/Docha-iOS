//
//  RootViewController.swift
//  DochaProto
//
//  Created by Mathis D on 24/05/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class RootViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configNavigationBarWithTitle(title: String, andFontSize size: CGFloat) {
        self.navigationItem.title = title
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Montserrat-ExtraBold", size: size)!]
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func goBack() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func goToHome() {
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("idDochaTabBarController") as! UITabBarController
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        NavSchemeManager.sharedInstance.changeRootViewController(viewController)
        let tabBarController = appDelegate.window!.rootViewController as! UITabBarController
        (appDelegate.window?.rootViewController as! UITabBarController).tabBar.tintColor = UIColor.redDochaColor()
        tabBarController.selectedIndex = 1
    }
}