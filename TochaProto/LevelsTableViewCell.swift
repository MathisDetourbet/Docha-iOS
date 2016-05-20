//
//  LevelsTableViewCell.swift
//  DochaProto
//
//  Created by Mathis D on 29/04/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class LevelsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLevelLabel: UILabel!
    @IBOutlet weak var canvasImageView: UIImageView!
    @IBOutlet weak var coinsImageView: UIImageView!
    @IBOutlet weak var priceLevelLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}