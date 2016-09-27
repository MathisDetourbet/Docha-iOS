//
//  InscriptionPseudoSelectionViewController.swift
//  Docha
//
//  Created by Mathis D on 02/09/2016.
//  Copyright © 2016 LaTV. All rights reserved.
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
        self.submitButton.isEnabled = false
    }
    

//MARK: @IBActions Methods
    
    @IBAction func pseudoTextFieldEditing(_ sender: HoshiTextField) {
        if sender.text?.characters.count > 2 && sender.text?.characters.count < 128 {
            sender.borderActiveColor = UIColor.blue
            sender.borderInactiveColor = UIColor.blueDochaColor()
            self.submitButton.isEnabled = true
            
        } else {
            sender.borderActiveColor = UIColor.redDochaColor()
            sender.borderInactiveColor = UIColor.redDochaColor()
            self.submitButton.isEnabled = false
        }
    }
    
    @IBAction func submitButtonTouched(_ sender: UIButton) {
        PopupManager.sharedInstance.showLoadingPopup("Connexion...", message: "Création d'un nouveau Docher en cours.", completion: {
            
            let userSessionManager = UserSessionManager.sharedInstance
            userSessionManager.dicoUserDataInscription!["pseudo"] = self.pseudoTextField.text
            let registrationParams = userSessionManager.dicoUserDataInscription!
            
            UserSessionManager.sharedInstance.inscriptionEmail(registrationParams,success: { (session) in
                print("Saving in the database : success !")
                
                PopupManager.sharedInstance.dismissPopup(true, completion: {
                    let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "idHomeNavController") as! UINavigationController
                    NavSchemeManager.sharedInstance.changeRootViewController(homeViewController)
                    let tutorialVC = self.storyboard?.instantiateViewController(withIdentifier: "idTutorialViewController") as! TutorialViewController
                    homeViewController.present(tutorialVC, animated: true, completion: nil)
                })
                
                }, fail: { (error, listErrors) in
                    PopupManager.sharedInstance.dismissPopup(true, completion: {
                        
                        if let error = error {
                            if error.code == 422 {
                                PopupManager.sharedInstance.showErrorPopup("Oups !", message: "Une erreur est survenue.", completion: nil)
                            }
                        }
                        print("Error inscription : \(error)")
                    })
            })
        })
    }
    
    @IBAction func backButtonTouched(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}
