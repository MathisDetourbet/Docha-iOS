//
//  PreferencesAboutViewController.swift
//  Docha
//
//  Created by Mathis D on 27/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class PreferencesAboutViewController: RootViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configNavigationBarWithTitle("À propos", andFontSize: 15.0)
    }
    
    @IBAction func backButtonTouched(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}
