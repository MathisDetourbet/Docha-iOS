//
//  StarterNavigationController.swift
//  DochaProto
//
//  Created by Mathis D on 24/05/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class StarterNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.tintColor = UIColor.blueColor()
        self.navigationBar.setBackgroundImage(UIImage(named: "nav_bar.png"), forBarMetrics: .Default)
        self.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
}