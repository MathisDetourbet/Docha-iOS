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
        
        backgroundBarImageView = UIImageView(frame: frame)
        backgroundBarImageView.contentMode = .scaleToFill
        backgroundBarImageView?.image = UIImage(named: "progress_bar_bg")
        backgroundBarImageView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.backgroundBarImageView)
        
        self.addConstraint(NSLayoutConstraint(item: self.backgroundBarImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.backgroundBarImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.backgroundBarImageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.backgroundBarImageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        
        frontBarImageView = UIImageView(frame: CGRect.zero)
        frontBarImageView.contentMode = .scaleToFill
        frontBarImageView.image = UIImage(named: "progress_bar")
        frontBarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.frontBarImageView)
        
        self.addConstraint(NSLayoutConstraint(item: frontBarImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: frontBarImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: frontBarImageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        widthFrontBarImageViewConstraint = NSLayoutConstraint(item: frontBarImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.0)
        self.addConstraint(widthFrontBarImageViewConstraint)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initLevelBar()
    }
    
    func initLevelBar() {
        
        self.backgroundColor = UIColor.clear
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTapsRequired = 1
        tapGesture.addTarget(self, action: #selector(tapLevelBar))
        self.addGestureRecognizer(tapGesture)
        
        backgroundBarImageView = UIImageView(frame: frame)
        backgroundBarImageView.contentMode = .scaleAspectFit
        backgroundBarImageView?.image = UIImage(named: "progress_bar_bg")
        backgroundBarImageView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(backgroundBarImageView)
        
        self.addConstraint(NSLayoutConstraint(item: backgroundBarImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: backgroundBarImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: backgroundBarImageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: backgroundBarImageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        
        frontBarImageView = UIImageView(frame: CGRect.zero)
        frontBarImageView.contentMode = .scaleToFill
        frontBarImageView.image = UIImage(named: "progress_bar")
        frontBarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(frontBarImageView)
        
        self.addConstraint(NSLayoutConstraint(item: frontBarImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 1.0))
        self.addConstraint(NSLayoutConstraint(item: frontBarImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 2.0))
        widthFrontBarImageViewConstraint = NSLayoutConstraint(item: frontBarImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.0)
        self.addConstraint(widthFrontBarImageViewConstraint)
    }
    
    func updateLevelBar(withLevelPercent levelPercent: CGFloat) {
        self.layoutIfNeeded()
        UIView.animate(withDuration: 2.0,
            animations: {
                self.widthFrontBarImageViewConstraint.constant = levelPercent * self.backgroundBarImageView.frame.width
                self.layoutIfNeeded()
            }
        )
    }
    
    func tapLevelBar() {
        // Amplitude
        Amplitude.instance().logEvent("ClickLevelBar")
    }
}
