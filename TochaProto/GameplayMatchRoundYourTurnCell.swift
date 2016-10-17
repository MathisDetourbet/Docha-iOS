//
//  GameplayMatchRoundYourTurnMaskCell.swift
//  Docha
//
//  Created by Mathis D on 19/09/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

protocol RoundYourTurnCellDelegate {
    func yourTurnButtonTouched()
}

class GameplayMatchRoundYourTurnCell: UITableViewCell {
    
    var delegate: RoundYourTurnCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
    }
    
    @IBAction func yourTurnButtonTouched(_ sender: UIButton) {
        self.delegate?.yourTurnButtonTouched()
    }
    
}
