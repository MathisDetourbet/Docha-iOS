//
//  TutorialViewController.swift
//  Docha
//
//  Created by Mathis D on 19/09/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class TutorialViewController: RootViewController, TutorialViewDelegate {
    
    var currentTutorialView: TutorialView?
    var currentIndex: Int = 1
    var kNumberOfViews = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.nextButtonTouched()
    }
    
    func nextButtonTouched() {
        if currentIndex > kNumberOfViews {
            self.dismissViewControllerAnimated(true, completion: nil)
            
        } else {
            currentTutorialView?.removeFromSuperview()
            currentTutorialView = nil
            
            currentTutorialView = TutorialView.loadFromNibNamed("Tutorial\(currentIndex)View") as? TutorialView
            if let currentTutorialView = currentTutorialView {
                currentTutorialView.delegate = self
                currentTutorialView.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(currentTutorialView)
                
                self.view.addConstraint(NSLayoutConstraint(item: currentTutorialView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 0.0))
                self.view.addConstraint(NSLayoutConstraint(item: currentTutorialView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
                self.view.addConstraint(NSLayoutConstraint(item: currentTutorialView, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: 0.0))
                self.view.addConstraint(NSLayoutConstraint(item: currentTutorialView, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
                
                self.currentTutorialView = currentTutorialView
                
            } else {
                print("NEXT METHOD : ERROR loading nib tutorial !")
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
            currentIndex += 1
        }
    }
}