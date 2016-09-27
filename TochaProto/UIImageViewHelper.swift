//
//  UIImageViewHelper.swift
//  Docha
//
//  Created by Mathis D on 05/09/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

extension UIImageView {
    
    func applyCircleBorder() {
        layer.cornerRadius = frame.size.height/2
        layer.borderWidth = 3.0
        layer.borderColor = UIColor.white.cgColor
        layer.masksToBounds = false
        clipsToBounds = true
    }
}
