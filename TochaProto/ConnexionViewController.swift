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
// Google+
import GoogleSignIn

class ConnexionViewController: RootViewController, GIDSignInUIDelegate {
    
    var emailString: String?
    var passwordString: String?
    
    @IBOutlet weak var backButtonItem: UIBarButtonItem!
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    @IBOutlet weak var connexionEmailButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNavigationBarWithTitle("Connexion")
        hideKeyboardWhenTappedAround()
        self.connexionEmailButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.setNavigationBarHidden(false, animated: false)
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    func isEmailValid() -> Bool {
        if let emailString = emailTextField.text {
            if !emailString.isEmpty {
                if emailString.isValidEmail() {
                    self.emailTextField.borderActiveColor = UIColor.blueDochaColor()
                    self.emailTextField.borderInactiveColor = UIColor.blueDochaColor()
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
        
        self.emailTextField.borderActiveColor = UIColor.redDochaColor()
        self.emailTextField.borderInactiveColor = UIColor.redDochaColor()
        
        return false
    }
    
    func isPasswordValid() -> Bool {
        if let passwordString = passwordTextField.text {
            if !passwordString.isEmpty {
                self.passwordTextField.borderActiveColor = UIColor.blueDochaColor()
                self.passwordTextField.borderInactiveColor = UIColor.blueDochaColor()
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
        
        self.passwordTextField.borderActiveColor = UIColor.redDochaColor()
        self.passwordTextField.borderInactiveColor = UIColor.redDochaColor()
        
        return false
    }
    
    @IBAction func EmailTextFieldEditingChanged(_ sender: HoshiTextField) {
        self.connexionEmailButton.isEnabled = (isEmailValid() && isPasswordValid()) ? true : false
    }
    
    @IBAction func PasswordTextFieldEditingChanged(_ sender: HoshiTextField) {
        self.connexionEmailButton.isEnabled = (isPasswordValid() && isEmailValid()) ? true : false
    }
    
    @IBAction func facebookButtonTouched(_ sender: UIButton) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logIn(withReadPermissions: ["email", "public_profile", "user_friends"],
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
    
    func getFBUserData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.facebookSignIn({
            
            PopupManager.sharedInstance.dismissPopup(true, completion: {
                if UserSessionManager.sharedInstance.currentSession()?.categoriesFavorites != nil {
                    self.goToHome()
                    
                } else {
                    let categoryViewController = self.storyboard?.instantiateViewController(withIdentifier: "idInscriptionCategorySelectionViewController") as! InscriptionCategorySelectionViewController
                    categoryViewController.comeFromConnexionVC = true
                    self.navigationController?.pushViewController(categoryViewController, animated: true)
                }
            })
            
        }) { (error, listError) in
            PopupManager.sharedInstance.dismissPopup(true, completion: {
                print("Error fetching user facebook data : \(error)")
                PopupManager.sharedInstance.showErrorPopup("Oups !", message: "Une erreure est survenue. Vérifie que tu es bien connecté à internet.", completion: nil)
            })
        }
    }
    
    @IBAction func emailConnexionTouched(_ sender: UIButton) {
        PopupManager.sharedInstance.showLoadingPopup("Connexion en cours...", message: nil, completion: {
            if self.emailString != nil && self.passwordString != nil {
                let email = self.emailString!
                let password = self.passwordString!
                
                UserSessionManager.sharedInstance.connectByEmail(email, andPassword: password,
                    success: {
                        PopupManager.sharedInstance.dismissPopup(true, completion: {
                            self.goToHome()
                        })
                        print("User connexion by email : success !")
                        
                    }, fail: { (error, listError) in
                        print("User connexion by email failed...")
                        PopupManager.sharedInstance.dismissPopup(true, completion: {
                            PopupManager.sharedInstance.showErrorPopup("Oups !", message: "L'email ou le mot de passe est incorrecte.", completion: nil)
                        })
                })
            }
        })
    }
    
    @IBAction func googlePlusButtonTouched(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        goBack()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
