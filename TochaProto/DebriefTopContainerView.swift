//
//  DebriefTopContainerView.swift
//  Docha
//
//  Created by Mathis D on 16/11/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

class DebriefTopContainerView: UIView {
    @IBOutlet weak var resultRoundSentenceImageView: UIImageView!
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userLevelLabel: UILabel!
    @IBOutlet weak var userTimeLabel: UILabel!
    @IBOutlet var userTimelineImageViewCollection: [UIImageView]!
    
    @IBOutlet weak var opponentAvatarImageView: UIImageView!
    @IBOutlet weak var opponentNameLabel: UILabel!
    @IBOutlet weak var opponentLevelLabel: UILabel!
    @IBOutlet weak var opponentTimeLabel: UILabel!
    @IBOutlet var opponentTimelineImageViewCollection: [UIImageView]!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
