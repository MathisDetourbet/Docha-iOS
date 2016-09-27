//
//  UIViewHelper.swift
//  Docha
//
//  Created by Mathis D on 26/07/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

extension UIView {
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
    
    
//MARK: Animation Methods
    
    func animatedLikeBubbleWithDelay(_ delay: TimeInterval, duration: TimeInterval) {
        self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        UIView.animate(withDuration: duration,
                                   delay: delay,
                                   usingSpringWithDamping: 0.6,
                                   initialSpringVelocity: 3.0,
                                   options: .allowUserInteraction,
                                   animations:
            {
                self.transform = CGAffineTransform.identity
            }, completion: nil)
    }
}
