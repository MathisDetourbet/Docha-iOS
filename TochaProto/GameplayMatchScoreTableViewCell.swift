//
//  GameplayMatchScoreTableViewCell.swift
//  Docha
//
//  Created by Mathis D on 18/09/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

class GameplayMatchScoreTableViewCell: UITableViewCell {
    
    
    @IBOutlet var userAvatarImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    
    @IBOutlet var opponentAvatarImageView: UIImageView!
    @IBOutlet var opponentNameLabel: UILabel!
    
    @IBOutlet var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
    }
}
