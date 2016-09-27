//
//  PinIconView.swift
//  Docha
//
//  Created by Mathis D on 06/09/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class PinIconView: UIView {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    func setAvatarImage(_ image: UIImage) {
        self.avatarImageView.image = image
    }
}
