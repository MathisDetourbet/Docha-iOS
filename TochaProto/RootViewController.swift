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
        self.navigationController?.popViewController(animated: true)
    }
    
    func goToHome() {
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "idHomeNavController") as! UINavigationController
        NavSchemeManager.sharedInstance.changeRootViewController(homeViewController)
    }
}
