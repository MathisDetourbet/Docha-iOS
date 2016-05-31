//
//  ConnexionViewController.swift
//  DochaProto
//
//  Created by Mathis D on 22/05/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import SwiftyJSON
// Google+
import GoogleSignIn

class ConnexionViewController: RootViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var backButtonItem: UIBarButtonItem!
    @IBOutlet weak var btnLoginFacebook: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNavigationBarWithTitle("Connexion")
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.setNavigationBarHidden(false, animated: false)
        GIDSignIn.sharedInstance().uiDelegate = self
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
            let categoryViewController = self.storyboard?.instantiateViewControllerWithIdentifier("idInscriptionCategorySelectionViewController") as! InscriptionCategorySelectionViewController
            self.navigationController?.pushViewController(categoryViewController, animated: true)
        }) { (error, listError) in
            // Fail
            print("Error fetching user facebook data : \(error)")
            print("list error : \(listError)")
        }
    }
    
    @IBAction func emailConnexionTouched(sender: UIButton) {
        UserSessionManager.sharedInstance.connectByEmail(<#T##dicoParams: [String : AnyObject]##[String : AnyObject]#>, success: <#T##() -> Void#>, fail: <#T##(error: NSError, listError: [AnyObject]) -> Void#>)
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