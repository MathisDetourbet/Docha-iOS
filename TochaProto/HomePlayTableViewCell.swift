//
//  HomePlayTableViewCell.swift
//  Docha
//
//  Created by Mathis D on 06/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

protocol HomePlayCellDelegate {
    func playButtonTouched()
}

class HomePlayTableViewCell: UITableViewCell {
    
    var delegate: HomePlayCellDelegate?
    
    @IBOutlet weak var nextRecompenseLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var constraintWidthProgressBar: NSLayoutConstraint!
    @IBOutlet weak var levelBackgroundImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @IBAction func playButtonTouched(sender: UIButton) {
        delegate?.playButtonTouched()
    }
}