//
//  InscriptionPseudoSelectionViewController.swift
//  Docha
//
//  Created by Mathis D on 02/09/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import TextFieldEffects

class InscriptionPseudoSelectionViewController: RootViewController {
    
    
    @IBOutlet weak var pseudoTextField: HoshiTextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.submitButton.enabled = false
    }
    

//MARK: @IBActions Methods
    
    @IBAction func pseudoTextFieldEditing(sender: HoshiTextField) {
        if sender.text?.characters.count > 2 && sender.text?.characters.count < 128 {
            sender.borderActiveColor = UIColor.blueColor()
            sender.borderInactiveColor = UIColor.blueDochaColor()
            self.submitButton.enabled = true
            
        } else {
            sender.borderActiveColor = UIColor.redDochaColor()
            sender.borderInactiveColor = UIColor.redDochaColor()
            self.submitButton.enabled = false
        }
    }
    
    @IBAction func submitButtonTouched(sender: UIButton) {
        PopupManager.sharedInstance.showLoadingPopup("Connexion...", message: "Création d'un nouveau Docher en cours.", completion: {
            
            let userSessionManager = UserSessionManager.sharedInstance
            userSessionManager.dicoUserDataInscription!["pseudo"] = self.pseudoTextField.text
            let registrationParams = userSessionManager.dicoUserDataInscription!
            
            UserSessionManager.sharedInstance.inscriptionEmail(registrationParams,success: { (session) in
                print("Saving in the database : success !")
                
                PopupManager.sharedInstance.dismissPopup(true, completion: {
                    self.goToHome()
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
    
    @IBAction func backButtonTouched(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}