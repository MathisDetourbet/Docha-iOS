//
//  ConnexionViewController.swift
//  DochaProto
//
//  Created by Mathis D on 22/05/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

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
        
        if((FBSDKAccessToken.currentAccessToken()) != nil) {
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email, gender, birthday"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                
                if (error == nil) {
                    print(result)
                    
                    var dicoUserData = [String:AnyObject]()
                    
                    if let
                        email = result["email"] as? String,
                        firstName = result["first_name"] as? String,
                        lastName = result["last_name"] as? String,
                        facebookID = result["id"] as? String,
                        gender = result["gender"] as? String,
                        birthday = result["birthday"] as? String
                    {
                        dicoUserData["email"] = email
                        dicoUserData["first_name"] = firstName
                        dicoUserData["last_name"] = lastName
                        dicoUserData["facebook_id"] = facebookID
                        
                        if gender == "male" {
                            dicoUserData["gender"] = "M"
                        } else {
                            dicoUserData["gender"] = "F"
                        }
                        
                        let birthdayFormatter = NSDateFormatter()
                        birthdayFormatter.dateFormat = "dd-MM-yyyy"
                        let birthdayDate = birthdayFormatter.dateFromString(birthday as String)
                        dicoUserData["date_birthday"] = birthdayDate
                    }
                    
                    UserSessionManager.sharedInstance.connectByFacebook(
                        dicoUserData,
                        success: {
                            let menuNavViewController = self.storyboard?.instantiateViewControllerWithIdentifier("idMenuNavController") as! UINavigationController
                            NavSchemeManager.sharedInstance.changeRootViewController(menuNavViewController)
                        
                        }, fail: { (error, listError) in
                            print("error saving Facebook user data in database : \(error)")
                            print("list error : \(listError)")
                    })
                } else {
                    print("Facebook get user data : error : \(error)")
                }
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