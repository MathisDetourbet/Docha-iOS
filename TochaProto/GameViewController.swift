//
//  GameViewController.swift
//  Docha
//
//  Created by Mathis D on 27/06/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import Amplitude_iOS
import SACountingLabel

extension UIView {
    func rotate360Degrees(_ duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * 2.0)
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount = FLT_MAX
        
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 0.5
        pulseAnimation.fromValue = 0.8
        pulseAnimation.toValue = 1.5
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = FLT_MAX
        
        if let delegate: AnyObject = completionDelegate {
            rotateAnimation.delegate = delegate as? CAAnimationDelegate
        }
        self.layer.add(rotateAnimation, forKey: nil)
        self.layer.add(pulseAnimation, forKey: nil)
    }
}

class GameViewController: RootViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configTitleViewDocha() {
        let titleLabel = UILabel(frame: CGRect(x: 96.0, y: 6.0, width: 128.0, height: 33.0))
        titleLabel.text = "Docha"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: "CaviarDreams-Bold", size: 20.0)
        titleLabel.textAlignment = .center
        self.navigationItem.titleView = titleLabel
    }
    
    func dochosNavBarTouched() {
        // Amplitude
        Amplitude.instance().logEvent("ClickDochosNavBar")
    }
    
    func perfectNavBarTouched() {
        // Amplitude
        Amplitude.instance().logEvent("ClickPerfectNavBar")
    }
}
