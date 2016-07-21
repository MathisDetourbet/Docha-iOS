//
//  LevelBarView.swift
//  Docha
//
//  Created by Mathis D on 05/07/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import Amplitude_iOS

class LevelBarView: UIView {
    
    var backgroundBarImageView: UIImageView!
    var frontBarImageView: UIImageView!
    var widthFrontBarImageViewConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundBarImageView = UIImageView(frame: frame)
        self.backgroundBarImageView.contentMode = .ScaleToFill
        self.backgroundBarImageView?.image = UIImage(named: "progress_bar_bg")
        self.backgroundBarImageView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.backgroundBarImageView)
        
        self.addConstraint(NSLayoutConstraint(item: self.backgroundBarImageView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.backgroundBarImageView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.backgroundBarImageView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.backgroundBarImageView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
        
        self.frontBarImageView = UIImageView(frame: CGRectZero)
        self.frontBarImageView.contentMode = .ScaleToFill
        self.frontBarImageView.image = UIImage(named: "progress_bar")
        self.frontBarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.frontBarImageView)
        
        self.addConstraint(NSLayoutConstraint(item: self.frontBarImageView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.frontBarImageView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.frontBarImageView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
        self.widthFrontBarImageViewConstraint = NSLayoutConstraint(item: self.frontBarImageView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0.0)
        self.addConstraint(self.widthFrontBarImageViewConstraint)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    func initLevelBar() {
        
        self.backgroundColor = UIColor.clearColor()
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTapsRequired = 1
        tapGesture.addTarget(self, action: #selector(tapLevelBar))
        self.addGestureRecognizer(tapGesture)
        
        self.backgroundBarImageView = UIImageView(frame: frame)
        self.backgroundBarImageView.contentMode = .ScaleAspectFit
        self.backgroundBarImageView?.image = UIImage(named: "progress_bar_bg")
        self.backgroundBarImageView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.backgroundBarImageView)
        
        self.addConstraint(NSLayoutConstraint(item: self.backgroundBarImageView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.backgroundBarImageView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.backgroundBarImageView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.backgroundBarImageView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
        
        self.frontBarImageView = UIImageView(frame: CGRectZero)
        self.frontBarImageView.contentMode = .ScaleToFill
        self.frontBarImageView.image = UIImage(named: "progress_bar")
        self.frontBarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.frontBarImageView)
        
        self.addConstraint(NSLayoutConstraint(item: self.frontBarImageView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 1.0))
        self.addConstraint(NSLayoutConstraint(item: self.frontBarImageView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 2.0))
        self.widthFrontBarImageViewConstraint = NSLayoutConstraint(item: self.frontBarImageView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0.0)
        self.addConstraint(self.widthFrontBarImageViewConstraint)
    }
    
    func updateLevelBarWithWidth(width: CGFloat) {
        UIView.animateWithDuration(2.0) {
            self.widthFrontBarImageViewConstraint.constant = (width / 100) * self.backgroundBarImageView.frame.width
        }
        layoutIfNeeded()
    }
    
    func tapLevelBar() {
        // Amplitude
        Amplitude.instance().logEvent("ClickLevelBar")
    }
}