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
    var avatarImageSelected: String?
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet var avatarsButtonsCollection: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.configNavigationBarWithTitle("Choisissez votre avatar")
        
        let userGender = UserSessionManager.sharedInstance.dicoUserDataInscription!["gender"] as? String
        
        if let gender = userGender {
            if gender == "M" {
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
        self.avatarImageSelected = self.avatarImageArray![index]
    }
    
    @IBAction func validProfilButtonTouched(sender: UIButton) {
        let userSessionManager = UserSessionManager.sharedInstance
        
        if let avatar = self.avatarImageSelected {
                if userSessionManager.dicoUserDataInscription == nil {
                userSessionManager.dicoUserDataInscription = [String:AnyObject]()
            }
            userSessionManager.dicoUserDataInscription!["avatar"] = avatar
        }
        
        let registrationParams = userSessionManager.dicoUserDataInscription!
        
        UserSessionManager.sharedInstance.inscriptionEmail(registrationParams,
            success: { (session) in
                                                            
                print("Saving in the database : success !")
                                                            
                // On lance une connexion avec le token reçu
                if UserSessionManager.sharedInstance.currentSession().isKindOfClass(UserSessionEmail) {
                    var connexionEmailParams = [String:AnyObject]()
                    
                    connexionEmailParams["email"] = registrationParams["email"]
                    if let auth_token = UserSessionManager.sharedInstance.currentSession().authToken {
                        print("auth_token extract from the device : \(auth_token)")
                    }
                    connexionEmailParams["password"] = registrationParams["password"]
                                                                    
                    UserSessionManager.sharedInstance.connectByEmail(connexionEmailParams,
                        success: {
                                
                        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("idMenuNavController") as! UINavigationController
                        NavSchemeManager.sharedInstance.changeRootViewController(viewController)
                            
                        }, fail: { (error, listError) in
                                                                            
                        })
                } else {
                    print("Error : class saved in the device isn't an UserSessionEmail class")
                }
                                                            
            }, fail: { (error, listErrors) in
                print("Error inscription : \(error)")
        })
        
        
        
//        userSessionManager.inscriptionEmail(userSessionManager.dicoUserDataInscription!,
//            success: {
//                let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("idMenuNavController") as! UINavigationController
//                NavSchemeManager.sharedInstance.changeRootViewController(viewController)
//            }) { (error, listError) in
//                
//        }
    }
}