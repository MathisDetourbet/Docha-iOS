//
//  PinIconView.swift
//  Docha
//
//  Created by Mathis D on 06/09/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import Kingfisher
import IBAnimatable

class PinIconView: AnimatableView {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    func setAvatarImage(_ image: UIImage) {
        avatarImageView.image = image
        avatarImageView.applyCircle()
    }
}
