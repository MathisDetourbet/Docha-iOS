//
//  InscriptionAvatarModalViewController.swift
//  DochaProto
//
//  Created by Mathis D on 24/05/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class InscriptionAvatarModalViewController: RootViewController {
    
    let manAvatarsImagesNamesArray = ["avatar_man_black", "avatar_man_geek", "avatar_man_marin", "avatar_man_hipster", "avatar_man", "avatar_man", "avatar_man_super"]
    let womanAvatarsImagesNamesArray = ["avatar_woman_indian", "avatar_woman_blond", "avatar_woman_latina", "avatar_woman_punk", "avatar_woman", "avatar_woman_glasses"]
    
    @IBOutlet var avatarsButtonsCollection: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (index, avatar) in avatarsButtonsCollection.enumerate() {
            avatar.setImage(UIImage(named: womanAvatarsImagesNamesArray[index]), forState: .Normal)
        }
    }
    
    @IBAction func closeModal(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}