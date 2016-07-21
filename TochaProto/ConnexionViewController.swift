//
//  ConnexionViewController.swift
//  DochaProto
//
//  Created by Mathis D on 22/05/2016.
//  Copyright © 2016 LaTV. All rights reserved.
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
        self.configNavigationBarWithTitle("Connexion", andFontSize: 13.0)
        hideKeyboardWhenTappedAround()
        self.connexionEmailButton.enabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
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
    
    @IBAction func EmailTextFieldEditingChanged(sender: HoshiTextField) {
        self.connexionEmailButton.enabled = (isEmailValid() && isPasswordValid()) ? true : false
    }
    
    @IBAction func PasswordTextFieldEditingChanged(sender: HoshiTextField) {
        self.connexionEmailButton.enabled = (isPasswordValid() && isEmailValid()) ? true : false
    }
    
    @IBAction func facebookButtonTouched(sender: UIButton) {
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
            self.dismissViewControllerAnimated(false, completion: nil)
            
            if UserSessionManager.sharedInstance.currentSession()?.categoryFavorite != nil {
                self.goToHome()
            } else {
                let categoryViewController = self.storyboard?.instantiateViewControllerWithIdentifier("idInscriptionCategorySelectionViewController") as! InscriptionCategorySelectionViewController
                categoryViewController.comeFromConnexionVC = true
                self.navigationController?.pushViewController(categoryViewController, animated: true)
            }
        }) { (error, listError) in
            print("Error fetching user facebook data : \(error)")
            print("list error : \(listError)")
            self.presentViewController(DochaPopupHelper.sharedInstance.showErrorPopup("Oups...", message: "Une erreure est survenue. Vérifie que tu es bien connecté à internet.")!, animated: true, completion: nil)
        }
    }
    
    @IBAction func emailConnexionTouched(sender: UIButton) {
        self.presentViewController(DochaPopupHelper.sharedInstance.showLoadingPopup()!, animated: true, completion: nil)
        
        if self.emailString != nil && passwordString != nil {
            let email = self.emailString!
            let password = self.passwordString!
            
        UserSessionManager.sharedInstance.connectByEmail(email, andPassword: password,
            success: {
                self.dismissViewControllerAnimated(false, completion: nil)
                print("User connexion by email : success !")
                self.goToHome()
                
            }, fail: { (error, listError) in
                self.dismissViewControllerAnimated(false, completion: nil)
                print("User connexion by email failed...")
                self.presentViewController(DochaPopupHelper.sharedInstance.showErrorPopup("Oups...", message: "L'email ou le mot de passe est incorrecte")!, animated: true, completion: nil)
            })
        }
    }
    
    @IBAction func googlePlusButtonTouched(sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func backButtonTapped(sender: UIBarButtonItem) {
        goBack()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}