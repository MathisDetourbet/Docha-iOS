//
//  RootViewController.swift
//  DochaProto
//
//  Created by Mathis D on 24/05/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

class RootViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configNavigationBarWithTitle(_ title: String!, andFontSize size: CGFloat? = 17.0) {
        self.navigationItem.title = title
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white, NSFontAttributeName: UIFont(name: "Montserrat-ExtraBold", size: size!)!]
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func goBack() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func goToHome() {
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "idHomeNavController") as! UINavigationController
        NavSchemeManager.sharedInstance.changeRootViewController(homeViewController)
    }
    
    func goToMatch(_ match: Match, animated: Bool) {
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "idHomeNavController") as! UINavigationController
        
        if animated {
            NavSchemeManager.sharedInstance.changeRootViewController(homeViewController)
            
        } else {
            UIApplication.shared.keyWindow?.rootViewController = homeViewController
        }
        
        let matchVC = homeViewController.storyboard?.instantiateViewController(withIdentifier: "idGameplayMatchViewController") as! GameplayMatchViewController
        matchVC.match = match
        homeViewController.pushViewController(matchVC, animated: true)
    }
}
