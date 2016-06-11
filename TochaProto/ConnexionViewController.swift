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
        self.configNavigationBarWithTitle("Connexion")
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
            // Success
            if UserSessionManager.sharedInstance.currentSession()?.categoryFavorite != nil {
                self.goToHome()
            } else {
                let categoryViewController = self.storyboard?.instantiateViewControllerWithIdentifier("idInscriptionCategorySelectionViewController") as! InscriptionCategorySelectionViewController
                self.navigationController?.pushViewController(categoryViewController, animated: true)
            }
        }) { (error, listError) in
            // Fail
            print("Error fetching user facebook data : \(error)")
            print("list error : \(listError)")
        }
    }
    
    @IBAction func emailConnexionTouched(sender: UIButton) {
        if self.emailString != nil && passwordString != nil {
            var dicoParams = [String:AnyObject]()
            dicoParams["email"] = self.emailString!
            dicoParams["password"] = self.passwordString!
            
        UserSessionManager.sharedInstance.connectByEmail(dicoParams,
            success: {
                print("User connexion by email : success !")
                self.goToHome()
                
            }, fail: { (error, listError) in
                print("User connexion by email failed...")
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