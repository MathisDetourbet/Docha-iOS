//
//  GameplayMatchRoundWaitingCell.swift
//  Docha
//
//  Created by Mathis D on 19/09/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

class GameplayMatchRoundWaitingCell: UITableViewCell {
    
    @IBOutlet var userTimelineImageViewCollection: [UIImageView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        
        for i in 0..<userTimelineImageViewCollection.count {
            userTimelineImageViewCollection[i].image = #imageLiteral(resourceName: "waiting_icon")
        }
    }
    
    func initTimeline(withUserScore userScore: UInt?) {
        if let userScore = userScore {
            
            for i in 0..<userTimelineImageViewCollection.count {
                userTimelineImageViewCollection[i].image = #imageLiteral(resourceName: "red_big_icon")
            }
            
            for i in 0..<Int(userScore) {
                userTimelineImageViewCollection[i].image = #imageLiteral(resourceName: "perfect_big_icon")
            }
        }
    }
}
