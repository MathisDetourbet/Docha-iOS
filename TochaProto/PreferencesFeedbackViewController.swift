//
//  PreferencesFeedbackViewController.swift
//  Docha
//
//  Created by Mathis D on 25/07/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import PBWebViewController

class PreferencesFeedbackViewController: PBWebViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func webViewDidFinishLoad(_ webView: UIWebView) {
        super.webViewDidFinishLoad(webView)
        configNavigationBarWithTitle("Docha a besoin de toi", andFontSize: 15.0)
    }
    
    func configNavigationBarWithTitle(_ title: String, andFontSize size: CGFloat) {
        self.navigationItem.title = title
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white, NSFontAttributeName: UIFont(name: "Montserrat-ExtraBold", size: size)!]
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    @IBAction func backButtonItemTouched(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
