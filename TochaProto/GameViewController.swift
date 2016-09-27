//
//  GameViewController.swift
//  Docha
//
//  Created by Mathis D on 27/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
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
            rotateAnimation.delegate = delegate
        }
        self.layer.add(rotateAnimation, forKey: nil)
        self.layer.add(pulseAnimation, forKey: nil)
    }
}

class GameViewController: RootViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configGameNavigationBar()
    }
    
    func configGameNavigationBar() {
//        let userGameManager = UserGameStateManager.sharedInstance
//        let perfectNumber = userGameManager.getPerfectPriceNumber()
//        let dochosNumber = userGameManager.getCurrentDochos()
//        
//        // Left bar button item : number of perfect price
//        let leftView = UIView(frame: CGRectMake(0.0, 0.0, 71.0, 33.0))
//        let perfectImageView = UIImageView(frame: CGRectMake(0.0, 7.0, 20.0, 20.0))
//        perfectImageView.image = UIImage(named: "perfects_icon")
//        perfectImageView.translatesAutoresizingMaskIntoConstraints = false
//        
//        let perfectLabel = SACountingLabel(frame: CGRectMake(28.0, 7.0, 10.0, 19.0))
//        perfectLabel.text = "\(perfectNumber)"
//        //perfectLabel.countFrom(0, to: Float(perfectNumber), withDuration: 0.7, andAnimationType: .EaseInOut, andCountingType: .Int)
//        perfectLabel.font = UIFont(name: "Montserrat-SemiBold", size: 15)
//        perfectLabel.textColor = UIColor.whiteColor()
//        perfectLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        leftView.addSubview(perfectImageView)
//        leftView.addSubview(perfectLabel)
//        
//        leftView.addConstraint(NSLayoutConstraint(item: perfectImageView, attribute: .CenterY, relatedBy: .Equal, toItem: leftView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
//        leftView.addConstraint(NSLayoutConstraint(item: perfectImageView, attribute: .Leading, relatedBy: .Equal, toItem: leftView, attribute: .Leading, multiplier: 1.0, constant: 0.0))
//        
//        leftView.addConstraint(NSLayoutConstraint(item: perfectImageView, attribute: .Trailing, relatedBy: .Equal, toItem: perfectLabel, attribute: .Leading, multiplier: 1.0, constant: -8.0))
//        leftView.addConstraint(NSLayoutConstraint(item: perfectLabel, attribute: .CenterY, relatedBy: .Equal, toItem: leftView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
//        
//        let tapGesturePerfect = UITapGestureRecognizer()
//        tapGesturePerfect.numberOfTapsRequired = 1
//        tapGesturePerfect.addTarget(self, action: #selector(perfectNavBarTouched))
//        leftView.addGestureRecognizer(tapGesturePerfect)
//        
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftView)
//        
//        // Right bar button item : number of dochos
//        let rightView = UIView(frame: CGRectMake(0.0, 0.0, 71.0, 33.0))
//        let dochosImageView = UIImageView(frame: CGRectMake(15.0, 7.0, 20.0, 20.0))
//        dochosImageView.image = UIImage(named: "dochos_icon")
//        dochosImageView.translatesAutoresizingMaskIntoConstraints = false
//        
//        let dochosLabel = SACountingLabel(frame: CGRectMake(43.0, 7.0, 28.0, 19.0))
//        //dochosLabel.countFrom(0, to: Float(dochosNumber), withDuration: 0, andAnimationType: .EaseInOut, andCountingType: .Int)
//        dochosLabel.text = "\(dochosNumber)"
//        dochosLabel.font = UIFont(name: "Montserrat-SemiBold", size: 15)
//        dochosLabel.textColor = UIColor.whiteColor()
//        dochosLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        rightView.addSubview(dochosImageView)
//        rightView.addSubview(dochosLabel)
//        
//        rightView.addConstraint(NSLayoutConstraint(item: dochosImageView, attribute: .CenterY, relatedBy: .Equal, toItem: rightView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
//        rightView.addConstraint(NSLayoutConstraint(item: dochosImageView, attribute: .Trailing, relatedBy: .Equal, toItem: dochosLabel, attribute: .Leading, multiplier: 1.0, constant: -8.0))
//        
//        rightView.addConstraint(NSLayoutConstraint(item: dochosLabel, attribute: .CenterY, relatedBy: .Equal, toItem: rightView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
//        rightView.addConstraint(NSLayoutConstraint(item: dochosLabel, attribute: .Trailing, relatedBy: .Equal, toItem: rightView, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
//        
//        let tapGestureDochos = UITapGestureRecognizer()
//        tapGestureDochos.numberOfTapsRequired = 1
//        tapGestureDochos.addTarget(self, action: #selector(dochosNavBarTouched))
//        rightView.addGestureRecognizer(tapGestureDochos)
//        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightView)
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
