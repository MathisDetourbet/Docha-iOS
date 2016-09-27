//
//  PopupView.swift
//  Docha
//
//  Created by Mathis D on 26/07/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

class PopupView: UIView {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var circleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var containerStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
