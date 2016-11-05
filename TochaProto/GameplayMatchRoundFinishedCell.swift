//
//  GameplayMatchRoundFinishedCell.swift
//  Docha
//
//  Created by Mathis D on 19/09/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

class GameplayMatchRoundFinishedCell: UITableViewCell {
    
    @IBOutlet var userTimelineImageViewCollection: [UIImageView]!
    @IBOutlet weak var userTimeBonusLabel: UILabel!
    
    @IBOutlet var opponentTimelineImageViewCollection: [UIImageView]!
    @IBOutlet weak var opponentTimeBonusLabel: UILabel!
    
    @IBOutlet weak var categoryImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        
        for i in 0..<userTimelineImageViewCollection.count {
            userTimelineImageViewCollection[i].image = #imageLiteral(resourceName: "waiting_icon")
        }
        
        for i in 0..<opponentTimelineImageViewCollection.count {
            opponentTimelineImageViewCollection[i].image = #imageLiteral(resourceName: "waiting_icon")
        }
    }
    
    
    func updateTimeline(withUserScore userScore: UInt?, andOpponentScore opponentScore: UInt?) {
        if var userScore = userScore, var opponentScore = opponentScore {
            
            for i in 0..<userTimelineImageViewCollection.count {
                userTimelineImageViewCollection[i].image = #imageLiteral(resourceName: "red_big_icon")
            }
            
            for i in 0..<opponentTimelineImageViewCollection.count {
                opponentTimelineImageViewCollection[i].image = #imageLiteral(resourceName: "red_big_icon")
            }
            
            if userScore > 3 {
                userScore = 3
                userTimeBonusLabel.isHidden = false
                opponentTimeBonusLabel.isHidden = true
            }
            for i in 0..<Int(userScore) {
                userTimelineImageViewCollection[i].image = #imageLiteral(resourceName: "perfect_big_icon")
            }
            
            if opponentScore > 3 {
                opponentScore = 3
                userTimeBonusLabel.isHidden = true
                opponentTimeBonusLabel.isHidden = false
            }
            for i in 0..<Int(opponentScore) {
                opponentTimelineImageViewCollection[i].image = #imageLiteral(resourceName: "perfect_big_icon")
            }
        }
    }
}
