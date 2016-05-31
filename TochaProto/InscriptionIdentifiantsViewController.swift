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
                    self.emailTextField.borderActiveColor = UIColor.greenColor()
                    self.emailTextField.borderInactiveColor = UIColor.greenColor()
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
        
        self.emailTextField.borderActiveColor = UIColor.redColor()
        self.emailTextField.borderInactiveColor = UIColor.redColor()
        
        return false
    }
    
    func isPasswordValid() -> Bool {
        if let passwordString = passwordTextField.text {
            if !passwordString.isEmpty {
                self.passwordTextField.borderActiveColor = UIColor.greenColor()
                self.passwordTextField.borderInactiveColor = UIColor.greenColor()
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
        
        self.passwordTextField.borderActiveColor = UIColor.redColor()
        self.passwordTextField.borderInactiveColor = UIColor.redColor()
        
        return false
    }
    
    @IBAction func registerWithFacebookTouched(sender: UIButton) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logInWithReadPermissions(["email", "public_profile"],
                                                fromViewController: self)
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
                    self.getFBUserData()
                }
            }
        }
    }
    
    func getFBUserData() {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.facebookSignIn({
            // Success
            let categoryViewController = self.storyboard?.instantiateViewControllerWithIdentifier("idMenuNavViewController") as! MenuViewController
            NavSchemeManager.sharedInstance.changeRootViewController(categoryViewController)
        }) { (error, listError) in
            // Fail
            print("error saving Facebook user data in database : \(error)")
            print("list error : \(listError)")
        }
    }


    @IBAction func registerWithGooglePlusTouched(sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func registerButtonTouched(sender: UIButton) {
        let currentSessionManager = UserSessionManager.sharedInstance
        if currentSessionManager.dicoUserDataInscription == nil {
            currentSessionManager.dicoUserDataInscription = [String:AnyObject]()
        }
        if let email = self.emailString, password = self.passwordString {
            currentSessionManager.dicoUserDataInscription!["email"] = email
            currentSessionManager.dicoUserDataInscription!["password"] = password
        }
    }
    
    @IBAction func backButtonTapped(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func EmailTextFieldEditingChanged(sender: HoshiTextField) {
        self.registerButton.enabled = (isEmailValid() && isPasswordValid()) ? true : false
    }
    
    @IBAction func PasswordTextFieldEditingChanged(sender: HoshiTextField) {
        self.registerButton.enabled = (isPasswordValid() && isEmailValid()) ? true : false
    }
}
