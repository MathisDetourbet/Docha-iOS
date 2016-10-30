//
//  NewGameFindFriendsTableViewCell.swift
//  Docha
//
//  Created by Mathis D on 19/09/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

protocol NewGameFindFriendsTableViewCellDelegate {
    func challengeFriendButtonTouched(withPseudo pseudo: String!)
}

class NewGameFindFriendsTableViewCell: UITableViewCell {
    
    var delegate: NewGameFindFriendsTableViewCellDelegate?
    
    @IBOutlet weak var friendPseudoLabel: UILabel!
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var friendAvatarImageView: UIImageView!
    @IBOutlet weak var friendOnlineIndicatorImageView: UIImageView!
    
    @IBAction func challengeFriendButtonTouched(_ sender: UIButton) {
        self.delegate?.challengeFriendButtonTouched(withPseudo: friendPseudoLabel.text!)
    }
}
