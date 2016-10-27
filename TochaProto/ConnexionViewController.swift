//
//  ConnexionViewController.swift
//  DochaProto
//
//  Created by Mathis D on 22/05/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import SwiftyJSON
import TextFieldEffects


class ConnexionViewController: RootViewController {
    
    var emailString: String?
    var passwordString: String?
    
    @IBOutlet weak var backButtonItem: UIBarButtonItem!
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    @IBOutlet weak var connexionEmailButton: UIButton!
    
    
//MARK: Life View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configNavigationBarWithTitle("Connexion")
        hideKeyboardWhenTappedAround()
        connexionEmailButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.setNavigationBarHidden(false, animated: false)
    }
    
    
//MARK: Facebook Method
    
    func getFBUserData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.facebookSignIn({
            
            PopupManager.sharedInstance.dismissPopup(true, completion: {
                let categoryPrefered = UserSessionManager.sharedInstance.currentSession()!.categoriesPrefered
                
                if categoryPrefered.isEmpty {
                    let categoryViewController = self.storyboard?.instantiateViewController(withIdentifier: "idInscriptionCategorySelectionViewController") as! InscriptionCategorySelectionViewController
                    categoryViewController.comeFromConnexionVC = true
                    self.navigationController?.pushViewController(categoryViewController, animated: true)
                    
                } else {
                    self.goToHome()
                }
            })
            
        }) { (error) in
            PopupManager.sharedInstance.dismissPopup(true, completion: {
                print("Error fetching user facebook data : \(error)")
                PopupManager.sharedInstance.showErrorPopup("Oups !", message: "Une erreure est survenue. Vérifie que tu es bien connecté à internet.", completion: nil)
            })
        }
    }
    
    func isEmailValid() -> Bool {
        if let emailString = emailTextField.text {
            
            if !emailString.isEmpty {
                
                if emailString.isValidEmail() {
                    emailTextField.borderActiveColor = UIColor.blueDochaColor()
                    emailTextField.borderInactiveColor = UIColor.blueDochaColor()
                    self.emailString = emailTextField.text
                    
                    return true
                    
                } else {
                    // Email is not valid
                    //print("Email is not valid")
                }
            } else {
                // Email text field is empty
                //print("Email text field is empty")
            }
        } else {
            // Email is nil
            //print("Email is nil")
        }
        
        emailTextField.borderActiveColor = UIColor.redDochaColor()
        emailTextField.borderInactiveColor = UIColor.redDochaColor()
        
        return false
    }
    
    func isPasswordValid() -> Bool {
        if let passwordString = passwordTextField.text {
            if !passwordString.isEmpty {
                passwordTextField.borderActiveColor = UIColor.blueDochaColor()
                passwordTextField.borderInactiveColor = UIColor.blueDochaColor()
                self.passwordString = passwordTextField.text
                return true
            } else {
                // Password is empty
                //print("Password is empty")
            }
        } else {
            // Password is nil
            //print("Password is nil")
        }
        
        passwordTextField.borderActiveColor = UIColor.redDochaColor()
        passwordTextField.borderInactiveColor = UIColor.redDochaColor()
        
        return false
    }
    

//MARK: @IBActions
    
    @IBAction func EmailTextFieldEditingChanged(_ sender: HoshiTextField) {
        connexionEmailButton.isEnabled = (isEmailValid() && isPasswordValid()) ? true : false
    }
    
    @IBAction func PasswordTextFieldEditingChanged(_ sender: HoshiTextField) {
        connexionEmailButton.isEnabled = (isPasswordValid() && isEmailValid()) ? true : false
    }
    
    @IBAction func facebookButtonTouched(_ sender: UIButton) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logIn(withReadPermissions: ["email", "public_profile", "user_friends", "user_birthday"],
                                                from: self)
        { (result, error) -> Void in
            
            if error != nil {
                print("Facebook login : process error : \(error)")
                return
                
            } else if (result?.isCancelled)! {
                print("Facebook login : cancelled")
                return
                
            } else {
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    PopupManager.sharedInstance.showLoadingPopup("Connexion en cours...", message: nil, completion: {
                        self.getFBUserData()
                    })
                }
            }
        }
    }
    
    @IBAction func emailConnexionTouched(_ sender: UIButton) {
        PopupManager.sharedInstance.showLoadingPopup("Connexion en cours...", message: nil,
            completion: {
                
                UserSessionManager.sharedInstance.connectByEmail(self.emailString!, andPassword: self.passwordString!,
                    success: {
                        
                        PopupManager.sharedInstance.dismissPopup(true,
                            completion: {
                                self.goToHome()
                            }
                        )
                        
                    }, fail: { (error) in
                        
                        PopupManager.sharedInstance.dismissPopup(true,
                            completion: {
                                PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorConnexionEmailBadEmailOrPassword)
                            }
                        )
                    }
                )
            }
        )
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        goBack()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
