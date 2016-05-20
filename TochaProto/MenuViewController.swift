//
//  MenuViewController.swift
//  DochaProto
//
//  Created by Mathis D on 30/04/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class MenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.hidden = false
    }
}