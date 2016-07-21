//
//  InscriptionProfilViewController.swift
//  DochaProto
//
//  Created by Mathis D on 27/05/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import SCLAlertView

extension UIViewController {
    
    func popToViewControllerClass(viewControllerClass: AnyClass) {
        if self.navigationController != nil {
            let allViewController = (self.navigationController?.viewControllers)! as [UIViewController]
            
            for aViewController in allViewController {
                if aViewController.isKindOfClass(viewControllerClass) {
                    self.navigationController?.popToViewController(aViewController, animated: true)
                }
            }
        }
    }
}

class InscriptionProfilViewController: RootViewController {
    
    var avatarImageArray = [String]?()
    var avatarImageSelected: String?
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet var avatarsButtonsCollection: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.configNavigationBarWithTitle("Choisissez votre avatar", andFontSize: 13.0)
        
        let userGender = UserSessionManager.sharedInstance.dicoUserDataInscription!["sexe"] as? String
        
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
            avatar.animatedLikeBubbleWithDelay(Double(index/100)+0.2, duration: 0.5)
        }
    }
    
    @IBAction func avatarButtonTouched(sender: UIButton) {
        let index = sender.tag
        self.userAvatarImageView.image = UIImage(named: "\(self.avatarImageArray![index])_profil")
        self.userAvatarImageView.animatedLikeBubbleWithDelay(0.0, duration: 0.5)
        self.avatarImageSelected = self.avatarImageArray![index]
    }
    
    @IBAction func validProfilButtonTouched(sender: UIButton) {
        self.presentViewController(DochaPopupHelper.sharedInstance.showLoadingPopup()!, animated: true, completion: nil)
        
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
                
                self.dismissViewControllerAnimated(false, completion: nil)
                self.goToHome()
                
//                // On lance une connexion avec le token reçu
//                if let currentSession = UserSessionManager.sharedInstance.currentSession() {
//                    if currentSession.isKindOfClass(UserSessionEmail) {
//                        
//                        let email = registrationParams["email"] as? String
//                        let password = registrationParams["password"] as? String
//                        
//                        if let email = email, password = password {
//                            
//                            UserSessionManager.sharedInstance.connectByEmail(email, andPassword: password,
//                                success: {
//                                    DochaPopupHelper.sharedInstance.dismissCurrentPopup()
//                                    self.goToHome()
//                                    
//                                }, fail: { (error, listError) in
//                                    print("Error connexion by email : \(error)")
//                                    DochaPopupHelper.sharedInstance.dismissCurrentPopup()
//                                    self.presentViewController(DochaPopupHelper.sharedInstance.showErrorPopup("Oups...", message: "Une erreur est survenue. Réessayer utltérieurement")!, animated: true, completion: nil)
//                            })
//                        }
//                        
//                    } else {
//                        print("Error : class saved in the device isn't an UserSessionEmail class")
//                        DochaPopupHelper.sharedInstance.dismissCurrentPopup()
//                        self.presentViewController(DochaPopupHelper.sharedInstance.showErrorPopup("Oups...", message: "Une erreur est survenue. Réessayer utltérieurement")!, animated: true, completion: nil)
//                        self.popToViewControllerClass(StarterPageViewController)
//                    }
//                }
                
            }, fail: { (error, listErrors) in
                self.dismissViewControllerAnimated(false, completion: nil)
                
                if let error = error {
                    if error.code == 422 {
                        self.presentViewController(DochaPopupHelper.sharedInstance.showErrorPopup("Oups...", message: (error.userInfo["message"])! as? String)!, animated: true, completion: nil)
                    }
                }
                print("Error inscription : \(error)")
        })
    }
}