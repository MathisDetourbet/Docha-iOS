//
//  InscriptionIdentifiantsViewController.swift
//  DochaProto
//
//  Created by Mathis D on 27/05/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import TextFieldEffects
import SwiftyJSON

// Dismiss keyboard on UITextField for UIViewControllers
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}


class InscriptionIdentifiantsViewController: RootViewController, UITextFieldDelegate {
    
    var emailString: String?
    var passwordString: String?
    var categoryFavorites: [String]?
    
    @IBOutlet weak var btnLoginFacebook: FBSDKLoginButton!
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        registerButton.isEnabled = true
        self.navigationController!.setNavigationBarHidden(false, animated: false)
        self.navigationItem.setHidesBackButton(true, animated: false)
        configNavigationBarWithTitle("Inscription")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
                if case 8...128 = passwordString.characters.count {
                    self.passwordTextField.borderActiveColor = UIColor.blueDochaColor()
                    self.passwordTextField.borderInactiveColor = UIColor.blueDochaColor()
                    self.passwordString = passwordTextField.text
                    return true
                }
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
    
    @IBAction func registerWithFacebookTouched(_ sender: UIButton) {
        if self.categoryFavorites == nil {
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logIn(withReadPermissions: ["email", "public_profile", "user_friends", "user_birthday"], from: self)
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
            // Success
            let data = [UserDataKey.kCategoryPrefered : self.categoryFavorites!]
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
            
        }) { (error) in
            // Failure
            PopupManager.sharedInstance.dismissPopup(true, completion: { 
                PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorNoInternetConnection)
            })
            print("error saving Facebook user data in database : \(error)")
        }
    }
    
    @IBAction func registerButtonTouched(_ sender: UIButton) {
        if isEmailValid() {
            if isPasswordValid() {
                
                PopupManager.sharedInstance.showLoadingPopup(message: nil,
                    completion: {
                        UserSessionManager.sharedInstance.registrationByEmail(self.emailString!, andPassword: self.passwordString!,
                            success: {
                                let data = [UserDataKey.kCategoryPrefered: self.categoryFavorites! as AnyObject]
                                UserSessionManager.sharedInstance.updateUser(withData: data,
                                    success: {
                                        PopupManager.sharedInstance.dismissPopup(true,
                                            completion: {
                                                let inscriptionInfosUserVC = self.storyboard?.instantiateViewController(withIdentifier: "idInscriptionInfosUserViewController") as! InscriptionInfosUserViewController
                                                self.navigationController?.pushViewController(inscriptionInfosUserVC, animated: true)
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
                                
                            }, fail: { (error) in
                                PopupManager.sharedInstance.dismissPopup(true,
                                    completion: {
                                        PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorNoInternetConnection)
                                    }
                                )
                            }
                        )
                    }
                )
                
            } else {
                PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorRegistrationPasswordMinimumCharacters)
            }
            
        } else {
            PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorRegistrationEmailNotValid)
        }
    }
    
    @IBAction func EmailTextFieldEditingChanged(_ sender: HoshiTextField) {
        _ = isEmailValid()
        _ = isPasswordValid()
    }
    
    @IBAction func PasswordTextFieldEditingChanged(_ sender: HoshiTextField) {
        _ = isPasswordValid()
        _ = isEmailValid()
    }
}
