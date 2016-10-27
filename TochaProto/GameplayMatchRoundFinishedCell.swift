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
    @IBOutlet var opponentTimelineImageViewCollection: [UIImageView]!
    
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
            
            userScore = userScore > 3 ? 3 : userScore
            for i in 0..<Int(userScore) {
                userTimelineImageViewCollection[i].image = #imageLiteral(resourceName: "perfect_big_icon")
            }
            
            opponentScore = opponentScore > 3 ? 3 : opponentScore
            for i in 0..<Int(opponentScore) {
                opponentTimelineImageViewCollection[i].image = #imageLiteral(resourceName: "perfect_big_icon")
            }
        }
    }
}
