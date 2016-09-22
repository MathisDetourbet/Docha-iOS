//
//  UIViewHelper.swift
//  Docha
//
//  Created by Mathis D on 26/07/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
    
    
//MARK: Animation Methods
    
    func animatedLikeBubbleWithDelay(delay: NSTimeInterval, duration: NSTimeInterval) {
        self.transform = CGAffineTransformMakeScale(0.0, 0.0)
        UIView.animateWithDuration(duration,
                                   delay: delay,
                                   usingSpringWithDamping: 0.6,
                                   initialSpringVelocity: 3.0,
                                   options: .AllowUserInteraction,
                                   animations:
            {
                self.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
}