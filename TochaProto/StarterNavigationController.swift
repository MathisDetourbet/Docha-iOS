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
        self.navigationItem.backBarButtonItem = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
}