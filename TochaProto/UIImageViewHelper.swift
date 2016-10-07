//
//  UIImageViewHelper.swift
//  Docha
//
//  Created by Mathis D on 05/09/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

extension UIImageView {
    
    func applyCircleBorder(withImage image: UIImage) {
        self.image = image
        layer.cornerRadius = frame.size.height/2
        layer.borderWidth = 3.0
        layer.borderColor = UIColor.white.cgColor
        clipsToBounds = true
    }
}
