//
//  NewGameFindPlayerTableViewCell.swift
//  Docha
//
//  Created by Mathis D on 18/10/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

class NewGameFindPlayerTableViewCell: UITableViewCell {
    
    var delegate: NewGameFindFriendsTableViewCellDelegate?
    
    @IBOutlet weak var friendPseudoLabel: UILabel!
    @IBOutlet weak var friendAvatarImageView: UIImageView!
    
    @IBAction func challengeFriendButtonTouched(_ sender: UIButton) {
        self.delegate?.challengeFriendButtonTouched(withPseudo: friendPseudoLabel.text!)
    }
}
