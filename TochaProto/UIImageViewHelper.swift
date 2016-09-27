//
//  UIImageViewHelper.swift
//  Docha
//
//  Created by Mathis D on 05/09/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

extension UIImageView {
    
    func applyCircleBorder() {
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.borderWidth = 3.0
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.clipsToBounds = true
    }
}
