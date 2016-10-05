//
//  InscriptionPseudoSelectionViewController.swift
//  Docha
//
//  Created by Mathis D on 02/09/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import TextFieldEffects

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class InscriptionPseudoSelectionViewController: RootViewController {
    
    
    @IBOutlet weak var pseudoTextField: HoshiTextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.isEnabled = false
    }
    

//MARK: @IBActions Methods
    
    @IBAction func pseudoTextFieldEditing(_ sender: HoshiTextField) {
        if sender.text?.characters.count > 2 && sender.text?.characters.count < 128 {
            sender.borderActiveColor = UIColor.blue
            sender.borderInactiveColor = UIColor.blueDochaColor()
            submitButton.isEnabled = true
            
        } else {
            sender.borderActiveColor = UIColor.redDochaColor()
            sender.borderInactiveColor = UIColor.redDochaColor()
            submitButton.isEnabled = false
        }
    }
    
    @IBAction func submitButtonTouched(_ sender: UIButton) {
        PopupManager.sharedInstance.showLoadingPopup("Connexion...", message: "Création d'un nouveau Docher en cours.",
            completion: {
                
                if let username = self.pseudoTextField.text {
                    let data = [UserDataKey.kUsername: username]
                    
                    UserSessionManager.sharedInstance.updateUser(withData: data,
                        success: {
                            
                            PopupManager.sharedInstance.dismissPopup(true,
                                completion: {
                                    self.goToHome()
                                }
                            )
                            
                        }, fail: { (error) in
                            PopupManager.sharedInstance.dismissPopup(true,
                                completion: {
                                    PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorNoInternetConnection)
                                }
                            )
                        }
                    )
                }
            }
        )
    }
    
    @IBAction func backButtonTouched(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
