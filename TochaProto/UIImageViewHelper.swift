//
//  UIImageViewHelper.swift
//  Docha
//
//  Created by Mathis D on 05/09/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

extension UIImageView {
    
    func applyCircle(withBorderColor borderColor: UIColor? = nil) {
        layer.masksToBounds = false
        
        if let borderColor = borderColor {
            layer.borderWidth = 1
            layer.borderColor = borderColor.cgColor
        }
        
        layer.cornerRadius = frame.height/2
        clipsToBounds = true
    }
}
