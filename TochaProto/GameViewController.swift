//
//  GameViewController.swift
//  Docha
//
//  Created by Mathis D on 27/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import Amplitude_iOS

class GameViewController: RootViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configGameNavigationBar()
    }
    
    func configGameNavigationBar() {
        let userGameManager = UserGameStateManager.sharedInstance
        let perfectNumber = userGameManager.getPerfectPriceNumber()
        let dochosNumber = userGameManager.getCurrentDochos()
        
        // Left bar button item : number of perfect price
        let leftView = UIView(frame: CGRectMake(0.0, 0.0, 71.0, 33.0))
        let perfectImageView = UIImageView(frame: CGRectMake(0.0, 7.0, 20.0, 20.0))
        perfectImageView.image = UIImage(named: "perfects_icon")
        perfectImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let perfectLabel = UILabel(frame: CGRectMake(28.0, 7.0, 10.0, 19.0))
        perfectLabel.text = "\(perfectNumber)"
        perfectLabel.font = UIFont(name: "Montserrat-SemiBold", size: 15)
        perfectLabel.textColor = UIColor.whiteColor()
        perfectLabel.translatesAutoresizingMaskIntoConstraints = false
        
        leftView.addSubview(perfectImageView)
        leftView.addSubview(perfectLabel)
        
        leftView.addConstraint(NSLayoutConstraint(item: perfectImageView, attribute: .CenterY, relatedBy: .Equal, toItem: leftView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        leftView.addConstraint(NSLayoutConstraint(item: perfectImageView, attribute: .Leading, relatedBy: .Equal, toItem: leftView, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        
        leftView.addConstraint(NSLayoutConstraint(item: perfectImageView, attribute: .Trailing, relatedBy: .Equal, toItem: perfectLabel, attribute: .Leading, multiplier: 1.0, constant: -8.0))
        leftView.addConstraint(NSLayoutConstraint(item: perfectLabel, attribute: .CenterY, relatedBy: .Equal, toItem: leftView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        
        let tapGesturePerfect = UITapGestureRecognizer()
        tapGesturePerfect.numberOfTapsRequired = 1
        tapGesturePerfect.addTarget(self, action: #selector(perfectNavBarTouched))
        leftView.addGestureRecognizer(tapGesturePerfect)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftView)
        
        // Right bar button item : number of dochos
        let rightView = UIView(frame: CGRectMake(0.0, 0.0, 71.0, 33.0))
        let dochosImageView = UIImageView(frame: CGRectMake(15.0, 7.0, 20.0, 20.0))
        dochosImageView.image = UIImage(named: "dochos_icon")
        dochosImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let dochosLabel = UILabel(frame: CGRectMake(43.0, 7.0, 28.0, 19.0))
        dochosLabel.text = "\(dochosNumber)"
        dochosLabel.font = UIFont(name: "Montserrat-SemiBold", size: 15)
        dochosLabel.textColor = UIColor.whiteColor()
        dochosLabel.translatesAutoresizingMaskIntoConstraints = false
        
        rightView.addSubview(dochosImageView)
        rightView.addSubview(dochosLabel)
        
        rightView.addConstraint(NSLayoutConstraint(item: dochosImageView, attribute: .CenterY, relatedBy: .Equal, toItem: rightView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        rightView.addConstraint(NSLayoutConstraint(item: dochosImageView, attribute: .Trailing, relatedBy: .Equal, toItem: dochosLabel, attribute: .Leading, multiplier: 1.0, constant: -8.0))
        
        rightView.addConstraint(NSLayoutConstraint(item: dochosLabel, attribute: .CenterY, relatedBy: .Equal, toItem: rightView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        rightView.addConstraint(NSLayoutConstraint(item: dochosLabel, attribute: .Trailing, relatedBy: .Equal, toItem: rightView, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        
        let tapGestureDochos = UITapGestureRecognizer()
        tapGestureDochos.numberOfTapsRequired = 1
        tapGestureDochos.addTarget(self, action: #selector(dochosNavBarTouched))
        rightView.addGestureRecognizer(tapGestureDochos)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightView)
    }
    
    func configTitleViewDocha() {
        let titleLabel = UILabel(frame: CGRectMake(96.0, 6.0, 128.0, 33.0))
        titleLabel.text = "Docha"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont(name: "CaviarDreams-Bold", size: 20.0)
        titleLabel.textAlignment = .Center
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