//
//  HomeGameTableViewCell.swift
//  Docha
//
//  Created by Mathis D on 01/09/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import SWTableViewCell

enum MatchResult: String {
    case won = "Gagné"
    case lost = "Perdu"
    case tie = "Égalité"
}

class HomeGameTableViewCell: SWTableViewCell {
    
    @IBOutlet weak var opponentNameLabel: UILabel!
    @IBOutlet weak var opponentLevelLabel: UILabel!
    @IBOutlet weak var opponentImageView: UIImageView!
    @IBOutlet weak var opponentScoreLabel: UILabel!
    @IBOutlet weak var userScoreLabel: UILabel!
    @IBOutlet weak var rightContainerView: UIView!
}

protocol HomeUserTurnCellDelegate {
    func playButtonTouched(withIndexPath indexPath: IndexPath)
}

class HomeUserTurnTableViewCell: HomeGameTableViewCell {
    
    var match: Match?
    var indexPath: IndexPath?
    var delegateUserTurn: HomeUserTurnCellDelegate?
    
    @IBAction func playButtonTouched(_ sender: UIButton) {
        if let indexPath = self.indexPath {
            delegateUserTurn?.playButtonTouched(withIndexPath: indexPath)
        }
    }
}

class HomeOpponentTurnTableViewCell: HomeGameTableViewCell {
    
    @IBOutlet weak var gameStateLabel: UILabel!
}

class HomeGameFinishedTableViewCell: HomeGameTableViewCell {
    
    var matchResult: MatchResult? {
        didSet {
            if let matchResult = matchResult {
                gameResultLabel.text = matchResult.rawValue
                
                switch matchResult {
                case .won:
                    gameResultLabel.textColor = UIColor.greenDochaColor()
                    break
                case .lost:
                    gameResultLabel.textColor = UIColor.redDochaColor()
                    break
                case .tie:
                    gameResultLabel.textColor = UIColor.darkBlueDochaColor()
                    break
                }
            }
        }
    }
    
    @IBOutlet weak var gameResultLabel: UILabel!
}
