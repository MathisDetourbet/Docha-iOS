//
//  InscriptionIdentifiantsViewController.swift
//  DochaProto
//
//  Created by Mathis D on 27/05/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import TextFieldEffects
import SCLAlertView
import GoogleSignIn
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
        return emailTest.evaluateWithObject(self)
    }
}


class InscriptionIdentifiantsViewController: RootViewController, UITextFieldDelegate {
    
    var emailString: String?
    var passwordString: String?
    
    @IBOutlet weak var btnLoginFacebook: FBSDKLoginButton!
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.registerButton.enabled = true
        self.navigationController!.setNavigationBarHidden(false, animated: false)
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.configNavigationBarWithTitle("Inscription")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
                if case 6...128 = passwordString.characters.count {
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
    
    @IBAction func registerWithFacebookTouched(sender: UIButton) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logInWithReadPermissions(["email", "public_profile"], fromViewController: self)
        { (result, error) -> Void in
            
            if error != nil {
                print("Facebook login : process error : \(error)")
                
                return
            } else if (result.isCancelled) {
                print("Facebook login : cancelled")
                return
            } else {
                let fbloginresult : FBSDKLoginManagerLoginResult = result
                
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
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.facebookSignIn({
            // Success
            PopupManager.sharedInstance.dismissPopup(true, completion: { 
                self.goToHome()
            })
        }) { (error, listError) in
            // Fail
            PopupManager.sharedInstance.dismissPopup(true, completion: { 
                PopupManager.sharedInstance.showInfosPopup("Oups !", message: "Une erreur est survenue. Essaie à nouveau ultérieurement.", completion: nil)
            })
            print("error saving Facebook user data in database : \(error)")
            print("list error : \(listError)")
        }
    }


    @IBAction func registerWithGooglePlusTouched(sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func registerButtonTouched(sender: UIButton) {
        if  isEmailValid() {
            
            if isPasswordValid() {
                let currentSessionManager = UserSessionManager.sharedInstance
                if currentSessionManager.dicoUserDataInscription == nil {
                    currentSessionManager.dicoUserDataInscription = [String:AnyObject]()
                }
                if let email = self.emailString, password = self.passwordString {
                    currentSessionManager.dicoUserDataInscription!["email"] = email
                    currentSessionManager.dicoUserDataInscription!["password"] = password
                    
                    let inscriptionInfosUserVC = self.storyboard?.instantiateViewControllerWithIdentifier("idInscriptionInfosUserViewController") as! InscriptionInfosUserViewController
                    self.navigationController?.pushViewController(inscriptionInfosUserVC, animated: true)
                }
                
            } else {
                PopupManager.sharedInstance.showErrorPopup("Oups !", message: "Vérifie que ton mot de passe possède au minimum 6 caractères.", completion: nil)
            }
        } else {
            PopupManager.sharedInstance.showErrorPopup("Oups !", message: "Cette adresse email n'est pas valide.", completion: nil)
        }
    }
    
    @IBAction func EmailTextFieldEditingChanged(sender: HoshiTextField) {
        isEmailValid()
        isPasswordValid()
    }
    
    @IBAction func PasswordTextFieldEditingChanged(sender: HoshiTextField) {
        isPasswordValid()
        isEmailValid()
    }
}
