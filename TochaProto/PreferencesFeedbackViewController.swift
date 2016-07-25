//
//  PreferencesFeedbackViewController.swift
//  Docha
//
//  Created by Mathis D on 25/07/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import PBWebViewController

class PreferencesFeedbackViewController: PBWebViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func webViewDidFinishLoad(webView: UIWebView) {
        super.webViewDidFinishLoad(webView)
        configNavigationBarWithTitle("Docha a besoin de toi", andFontSize: 15.0)
    }
    
    func configNavigationBarWithTitle(title: String, andFontSize size: CGFloat) {
        self.navigationItem.title = title
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Montserrat-ExtraBold", size: size)!]
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func backButtonItemTouched(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}