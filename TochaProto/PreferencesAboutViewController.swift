//
//  PreferencesAboutViewController.swift
//  Docha
//
//  Created by Mathis D on 27/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class PreferencesAboutViewController: RootViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configNavigationBarWithTitle("À propos", andFontSize: 15.0)
        self.textView.font = UIFont(name: "Montserrat-Regular", size: 12.0)
    }
    
    @IBAction func backButtonTouched(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}