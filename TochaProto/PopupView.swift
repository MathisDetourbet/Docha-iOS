//
//  PopupView.swift
//  Docha
//
//  Created by Mathis D on 26/07/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class PopupView: UIView {
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var circleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var containerStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        
//        shadowView = UIView(frame: self.frame)
//        shadowView!.backgroundColor = UIColor.blackColor()
//        shadowView!.alpha = 0.0
//        shadowView!.translatesAutoresizingMaskIntoConstraints = false
//        self.insertSubview(shadowView!, atIndex: 0)
//        self.addConstraint(NSLayoutConstraint(item: shadowView!, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0))
//        self.addConstraint(NSLayoutConstraint(item: shadowView!, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
//        self.addConstraint(NSLayoutConstraint(item: shadowView!, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0))
//        self.addConstraint(NSLayoutConstraint(item: shadowView!, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
    }
    
    func shadowAnimation() {
        UIView.animateWithDuration(0.3, animations: {
            self.shadowView!.alpha = 0.5
        }) { (_) in }
    }
}