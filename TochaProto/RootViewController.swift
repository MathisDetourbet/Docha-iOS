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
    
    func configNavigationBarWithTitle(title: String) {
        self.navigationItem.title = title
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func goBack() {
        self.navigationController?.popViewControllerAnimated(true)
    }
}