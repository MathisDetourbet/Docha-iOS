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
        
        if((FBSDKAccessToken.currentAccessToken()) != nil) {
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email, gender, birthday"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                
                if (error == nil) {
                    print(result)
                    let jsonResult = JSON(result)
                    var dicoUserData = [String:AnyObject]()
                    
                    dicoUserData["email"] = jsonResult["email"].string
                    dicoUserData["first_name"] = jsonResult["first_name"].string
                    dicoUserData["last_name"] = jsonResult["last_name"].string
                    dicoUserData["facebook_id"] = jsonResult["id"].string
                    
                    // Gender
                    if jsonResult["gender"].string == "male" {
                        dicoUserData["gender"] = "M"
                    } else {
                        dicoUserData["gender"] = "F"
                    }
                    
                    // Birthday
                    if let birthday = jsonResult["birthday"].string {
                        let birthdayFormatter = NSDateFormatter()
                        birthdayFormatter.dateFormat = "dd-MM-yyyy"
                        let birthdayDate = birthdayFormatter.dateFromString(birthday)
                        dicoUserData["date_birthday"] = birthdayDate
                    }
                    
                    // Picture
                    dicoUserData["image_url"] = jsonResult["picture"]["data"]["url"].string
                    
                    UserSessionManager.sharedInstance.connectByFacebook(
                        dicoUserData,
                        success: {
                            let categoryViewController = self.storyboard?.instantiateViewControllerWithIdentifier("idInscriptionCategorySelectionViewController") as! InscriptionCategorySelectionViewController
                            self.navigationController?.pushViewController(categoryViewController, animated: true)
                            
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