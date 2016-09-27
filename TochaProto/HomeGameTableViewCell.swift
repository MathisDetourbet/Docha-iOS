//
//  HomeGameTableViewCell.swift
//  Docha
//
//  Created by Mathis D on 01/09/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import SWTableViewCell

class HomeGameTableViewCell: SWTableViewCell {
    
    @IBOutlet weak var opponentNameLabel: UILabel!
    @IBOutlet weak var opponentLevelLabel: UILabel!
    @IBOutlet weak var opponentImageView: UIImageView!
    @IBOutlet weak var opponentScoreLabel: UILabel!
    @IBOutlet weak var userScoreLabel: UILabel!
    @IBOutlet weak var rightContainerView: UIView!
}

protocol HomeUserTurnCellDelegate {
    func playButtonTouched()
}

class HomeUserTurnTableViewCell: HomeGameTableViewCell {
    
    var delegateUserTurn: HomeUserTurnCellDelegate?
    
    @IBAction func playButtonTouched(_ sender: UIButton) {
        self.delegateUserTurn?.playButtonTouched()
    }
}

class HomeOpponentTurnTableViewCell: HomeGameTableViewCell {
    
    @IBOutlet weak var gameStateLabel: UILabel!
}

class HomeGameFinishedTableViewCell: HomeGameTableViewCell {
    
    var wonGame: Bool? {
        didSet {
            self.gameResultLabel.text = (self.wonGame == true) ? "Gagné" : "Perdu"
            self.gameResultLabel.textColor = (self.wonGame == true) ? UIColor.greenDochaColor() : UIColor.redDochaColor()
        }
    }
    
    @IBOutlet weak var gameResultLabel: UILabel!
}
