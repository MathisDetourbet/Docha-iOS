//
//  TutorialViewController.swift
//  Docha
//
//  Created by Mathis D on 19/09/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

class TutorialViewController: RootViewController, TutorialViewDelegate {
    
    var currentTutorialView: TutorialView?
    var currentIndex: Int = 1
    var kNumberOfViews = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        nextButtonTouched()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserSessionManager.sharedInstance.didFinishedTutorial()
    }
    
    func nextButtonTouched() {
        if currentIndex > kNumberOfViews {
            self.dismiss(animated: true, completion: nil)
            
        } else {
            currentTutorialView?.removeFromSuperview()
            currentTutorialView = nil
            
            currentTutorialView = TutorialView.loadFromNibNamed("Tutorial\(currentIndex)View") as? TutorialView
            if let currentTutorialView = currentTutorialView {
                currentTutorialView.delegate = self
                currentTutorialView.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(currentTutorialView)
                
                self.view.addConstraint(NSLayoutConstraint(item: currentTutorialView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0.0))
                self.view.addConstraint(NSLayoutConstraint(item: currentTutorialView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0.0))
                self.view.addConstraint(NSLayoutConstraint(item: currentTutorialView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0.0))
                self.view.addConstraint(NSLayoutConstraint(item: currentTutorialView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0.0))
                
                self.currentTutorialView = currentTutorialView
                
                let skipButton = UIButton(type: .custom)
                skipButton.setTitle("Passer", for: .normal)
                skipButton.setTitleColor(UIColor.white, for: .normal)
                let normalAttributedTitle = NSAttributedString(string: "  Passer  ", attributes: [NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName: UIFont(name: "Montserrat-SemiBold", size: 15) ?? UIFont()])
                skipButton.setAttributedTitle(normalAttributedTitle, for: .normal)
                skipButton.titleLabel?.textColor = UIColor.white
                skipButton.addTarget(self, action: #selector(TutorialViewController.skipButtonTouched), for: .touchUpInside)
                skipButton.layer.borderColor = UIColor.white.cgColor
                skipButton.layer.borderWidth = 1
                skipButton.layer.cornerRadius = 10
                skipButton.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(skipButton)
                
                self.view.addConstraint(NSLayoutConstraint(item: skipButton, attribute: .trailing, relatedBy: .equal, toItem: currentTutorialView, attribute: .trailing, multiplier: 1.0, constant: -10.0))
                self.view.addConstraint(NSLayoutConstraint(item: skipButton, attribute: .top, relatedBy: .equal, toItem: currentTutorialView, attribute: .top, multiplier: 1.0, constant: 10.0))
                
            } else {
                print("ERROR loading nib tutorial !")
                self.dismiss(animated: true, completion: nil)
            }
            
            currentIndex += 1
        }
    }
    
    func skipButtonTouched() {
        self.dismiss(animated: true, completion: nil)
    }
}
