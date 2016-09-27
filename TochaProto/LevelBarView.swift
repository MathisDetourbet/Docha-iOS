//
//  LevelBarView.swift
//  Docha
//
//  Created by Mathis D on 05/07/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
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
        self.backgroundBarImageView.contentMode = .scaleToFill
        self.backgroundBarImageView?.image = UIImage(named: "progress_bar_bg")
        self.backgroundBarImageView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.backgroundBarImageView)
        
        self.addConstraint(NSLayoutConstraint(item: self.backgroundBarImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.backgroundBarImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.backgroundBarImageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.backgroundBarImageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        
        self.frontBarImageView = UIImageView(frame: CGRect.zero)
        self.frontBarImageView.contentMode = .scaleToFill
        self.frontBarImageView.image = UIImage(named: "progress_bar")
        self.frontBarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.frontBarImageView)
        
        self.addConstraint(NSLayoutConstraint(item: self.frontBarImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.frontBarImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.frontBarImageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        self.widthFrontBarImageViewConstraint = NSLayoutConstraint(item: self.frontBarImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.0)
        self.addConstraint(self.widthFrontBarImageViewConstraint)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    func initLevelBar() {
        
        self.backgroundColor = UIColor.clear
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTapsRequired = 1
        tapGesture.addTarget(self, action: #selector(tapLevelBar))
        self.addGestureRecognizer(tapGesture)
        
        self.backgroundBarImageView = UIImageView(frame: frame)
        self.backgroundBarImageView.contentMode = .scaleAspectFit
        self.backgroundBarImageView?.image = UIImage(named: "progress_bar_bg")
        self.backgroundBarImageView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.backgroundBarImageView)
        
        self.addConstraint(NSLayoutConstraint(item: self.backgroundBarImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.backgroundBarImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.backgroundBarImageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.backgroundBarImageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        
        self.frontBarImageView = UIImageView(frame: CGRect.zero)
        self.frontBarImageView.contentMode = .scaleToFill
        self.frontBarImageView.image = UIImage(named: "progress_bar")
        self.frontBarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.frontBarImageView)
        
        self.addConstraint(NSLayoutConstraint(item: self.frontBarImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 1.0))
        self.addConstraint(NSLayoutConstraint(item: self.frontBarImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 2.0))
        self.widthFrontBarImageViewConstraint = NSLayoutConstraint(item: self.frontBarImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.0)
        self.addConstraint(self.widthFrontBarImageViewConstraint)
    }
    
    func updateLevelBarWithWidth(_ width: CGFloat) {
        self.layoutIfNeeded()
        UIView.animate(withDuration: 2.0, animations: {
            self.widthFrontBarImageViewConstraint.constant = (width / 100) * self.backgroundBarImageView.frame.width
        }) 
        self.layoutIfNeeded()
    }
    
    func tapLevelBar() {
        // Amplitude
        Amplitude.instance().logEvent("ClickLevelBar")
    }
}
