//
//  InscriptionProfilViewController.swift
//  DochaProto
//
//  Created by Mathis D on 27/05/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

extension UIViewController {
    
    func popToViewControllerClass(_ viewControllerClass: AnyClass) {
        if self.navigationController != nil {
            let allViewController = (self.navigationController?.viewControllers)! as [UIViewController]
            
            for aViewController in allViewController {
                if aViewController.isKind(of: viewControllerClass) {
                    _ = self.navigationController?.popToViewController(aViewController, animated: true)
                }
            }
        }
    }
}

class InscriptionProfilViewController: RootViewController {
    
    var avatarImageArray: [String] = []
    var avatarImageSelected: String?
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet var avatarsButtonsCollection: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        configNavigationBarWithTitle("Choisissez votre avatar")
    }
    
    @IBAction func avatarButtonTouched(_ sender: UIButton) {
        let index = sender.tag
        userAvatarImageView.image = UIImage(named: "\(avatarImageArray[index])_profil")
        userAvatarImageView.animatedLikeBubbleWithDelay(0.0, duration: 0.5)
        avatarImageSelected = avatarImageArray[index]
    }
    
    @IBAction func validProfilButtonTouched(_ sender: UIButton) {
        PopupManager.sharedInstance.showLoadingPopup("Connexion...", message: "Création d'un nouveau Docher en cours.", completion: {
            //let userSessionManager = UserSessionManager.sharedInstance
            
//            UserSessionManager.sharedInstance.inscriptionEmail(registrationParams,success: { (session) in
//                print("Saving in the database : success !")
//                
//                PopupManager.sharedInstance.dismissPopup(true, completion: {
//                    self.goToHome()
//                })
//                
//                }, fail: { (error, listErrors) in
//                    PopupManager.sharedInstance.dismissPopup(true, completion: {
//                    
//                        if let error = error {
//                            if error.code == 422 {
//                                PopupManager.sharedInstance.showErrorPopup("Oups !", message: "Une erreur est survenue.", completion: nil)
//                            }
//                        }
//                        print("Error inscription : \(error)")
//                    })
//            })
        })
    }
}
