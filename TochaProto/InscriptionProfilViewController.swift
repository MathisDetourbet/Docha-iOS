//
//  InscriptionProfilViewController.swift
//  DochaProto
//
//  Created by Mathis D on 27/05/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class InscriptionProfilViewController: RootViewController {
    
    var avatarImageArray = [String]?()
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet var avatarsButtonsCollection: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.configNavigationBarWithTitle("Choisissez votre avatar")
        
        let currentUser = UserSessionManager.sharedInstance.currentSession()
        
        if  let gender = currentUser.sexe {
            if gender == "man" {
                avatarImageArray = ["avatar_man_black", "avatar_man_geek", "avatar_man_marin", "avatar_man_hipster", "avatar_man", "avatar_man_super"]
                userAvatarImageView.image = UIImage(named: "avatar_man_profil")
            } else {
                avatarImageArray = ["avatar_woman_indian", "avatar_woman_blond", "avatar_woman_latina", "avatar_woman_punk", "avatar_woman", "avatar_woman_glasses"]
                userAvatarImageView.image = UIImage(named: "avatar_woman_profil")
            }
        } else {
            avatarImageArray = ["avatar_woman_indian", "avatar_woman_blond", "avatar_woman_latina", "avatar_woman_punk", "avatar_woman", "avatar_woman_glasses"]
            userAvatarImageView.image = UIImage(named: "avatar_woman_profil")
        }
        
        for (index, avatar) in avatarsButtonsCollection.enumerate() {
            avatar.setImage(UIImage(named: avatarImageArray![index]), forState: .Normal)
            avatar.animatedButtonLikeBubbleWithDelay(Double(index/100)+0.2, duration: 0.5)
        }
    }
    
    @IBAction func avatarButtonTouched(sender: UIButton) {
        let index = sender.tag
        self.userAvatarImageView.image = UIImage(named: "\(self.avatarImageArray![index])_profil")
        self.userAvatarImageView.animatedButtonLikeBubbleWithDelay(0.0, duration: 0.5)
    }
}