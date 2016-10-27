//
//  PinIconView.swift
//  Docha
//
//  Created by Mathis D on 06/09/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import Kingfisher

class PinIconView: UIView {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    func setAvatarImage(_ image: UIImage) {
        self.avatarImageView.image = image.roundCornersToCircle(withBorder: 10.0, color: UIColor.white)
    }
}
