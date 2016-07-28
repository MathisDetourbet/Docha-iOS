//
//  PreferencesChoosAvatarViewController.swift
//  Docha
//
//  Created by Mathis D on 12/07/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

protocol ChooseAvatarDochaDelegate {
    func didChosenAvatarDochaWithImage(imageName: String)
}

class PreferencesChoosAvatarViewController: RootViewController {
    
    var manAvatarsArray = ["avatar_man_black", "avatar_man_geek", "avatar_man_marin", "avatar_man_hipster", "avatar_man", "avatar_man_super"]
    var womanAvatarsArray = ["avatar_woman_indian", "avatar_woman_blond", "avatar_woman_latina", "avatar_woman_punk", "avatar_woman", "avatar_woman_glasses"]
    
    var delegate: ChooseAvatarDochaDelegate?
    var avatarImageArray = [String]?()
    var avatarImageSelected: String?
    var userGender: String?
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet var avatarsButtonsCollection: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let gender = self.userGender {
            if gender == "M" {
                avatarImageArray = manAvatarsArray
                
            } else {
                avatarImageArray = womanAvatarsArray
            }
            
        } else {
            avatarImageArray = womanAvatarsArray
            userAvatarImageView.image = UIImage(named: "avatar_woman_profil")
        }
        
        if let avatarString = UserSessionManager.sharedInstance.currentSession()?.avatar {
            userAvatarImageView.image = UIImage(named: "\(avatarString)_profil")
            if avatarString.rangeOfString("woman") != nil {
                avatarImageArray = womanAvatarsArray
                
            } else {
                avatarImageArray = manAvatarsArray
            }
            
        } else {
            userAvatarImageView.image = UIImage(named: "avatar_man_profil")
        }
        
        for (index, avatar) in avatarsButtonsCollection.enumerate() {
            avatar.setImage(UIImage(named: avatarImageArray![index]), forState: .Normal)
            avatar.animatedLikeBubbleWithDelay(Double(index/100)+0.2, duration: 0.5)
        }
    }
    
    @IBAction func avatarButtonTouched(sender: UIButton) {
        let index = sender.tag
        self.userAvatarImageView.image = UIImage(named: "\(self.avatarImageArray![index])_profil")
        self.userAvatarImageView.animatedLikeBubbleWithDelay(0.0, duration: 0.5)
        self.avatarImageSelected = self.avatarImageArray![index]
    }
    
    @IBAction func validButtonTouched(sender: UIButton) {
        if let avatarString = self.avatarImageSelected {
            self.delegate?.didChosenAvatarDochaWithImage(avatarString)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}