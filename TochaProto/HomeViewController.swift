//
//  HomeViewController.swift
//  Docha
//
//  Created by Mathis D on 06/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import AlamofireImage
import ReachabilitySwift
import SCLAlertView
import Amplitude_iOS
import FBSDKShareKit
import SwiftyJSON

class HomeViewController: GameViewController, UITableViewDelegate, UITableViewDataSource, HomePlayCellDelegate, HomeFriendsCellDelegate, FBSDKAppInviteDialogDelegate {
    
    let idsTableViewCell: [String] = ["idHomePlayTableViewCell", "idHomeFriendsTableViewCell", "idHomeBadgesTableViewCell"]
    let userGameManager: UserGameStateManager = UserGameStateManager.sharedInstance
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    
//MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserInfos()
    }
    
    func getFriendsList() {
        
//        let userSession = UserSessionManager.sharedInstance.currentSession() as? UserSessionFacebook
//        let fbID = (userSession?.facebookID)! as String
//        let request = FBSDKGraphRequest(graphPath: "\(fbID)/friends", parameters: ["fields": "id, email"], HTTPMethod: "GET")
//        request.startWithCompletionHandler({ (connexion, result, error) in
//            let jsonResult = JSON(result)
//            let array = jsonResult["data"].arrayValue
//            let dico = jsonResult["data"].dictionaryValue
//            print(array)
//        })
        
        /*
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logInWithReadPermissions(["user_friends"],
                                                fromViewController: self)
        { (result, error) -> Void in
            
            if error != nil {
                print("Facebook login : process error : \(error)")
                
                return
            } else if (result.isCancelled) {
                print("Facebook login : cancelled")
                return
            } else {
                //let fbloginresult : FBSDKLoginManagerLoginResult = result
                
                //if(fbloginresult.grantedPermissions.contains("data")) {
                    //print("Facebook Access token : \(FBSDKAccessToken.currentAccessToken().tokenString)")
                    
                    if((FBSDKAccessToken.currentAccessToken()) != nil) {
                        
//                        let profilRequest = ProfilRequest()
//                        profilRequest.getUserFriendsDochaInstalled(FBSDKAccessToken.currentAccessToken().tokenString,
//                            success: { (friendsList) in
//                                print("Success get friends ! : \(friendsList)")
//                            }, fail: { (error, listErrors) in
//                                print("Error get user friends list")
//                        })
                        
                    } else {
                        print("Token is nil")
                    }
                //}
            }
        }
         */
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configGameNavigationBar()
        configTitleViewDocha()
        
        if UserSessionManager.sharedInstance.needsToUpdateHome {
            loadUserInfos()
            UserSessionManager.sharedInstance.needsToUpdateHome = false
        }
        
        // Amplitude
        Amplitude.instance().logEvent("TabNavHome")
    }
    
    
//MARK: Load Data Methods
    
    func loadUserInfos() {
        if let userSession = UserSessionManager.sharedInstance.currentSession() {
            
            if userSession.isKindOfClass(UserSessionEmail) {
                let userSessionEmail = userSession as! UserSessionEmail
                if userSession.username == "" {
                    if let firstName = userSessionEmail.firstName, lastName = userSessionEmail.lastName {
                        self.userNameLabel.text = "\(firstName) \(Array(arrayLiteral: lastName)[0])."
                        
                    } else {
                        self.userNameLabel.text = ""
                    }
                    
                } else {
                    self.userNameLabel.text = userSession.username
                }
                
                
                let profilImagePrefered = userSessionEmail.profilImagePrefered
                var profilImage: UIImage?
                
                if profilImagePrefered == .AvatarDochaImage && userSession.avatar != ""  {
                    if let avatarString = userSessionEmail.avatar {
                        profilImage = UIImage(named: avatarString)
                    }
                    
                } else {
                    if let photoImage = userSessionEmail.getUserProfileImage() {
                        profilImage = photoImage
                    }
                }
                
                self.avatarImageView.image = profilImage
                
            } else if userSession.isKindOfClass(UserSessionFacebook) {
                let userSessionFacebook = userSession as! UserSessionFacebook
                
                if userSession.username != "" {
                    self.userNameLabel.text = userSession.username
                    
                } else if let firstName = userSessionFacebook.firstName, lastName = userSessionFacebook.lastName {
                    self.userNameLabel.text = "\(firstName) \(lastName[0])."
                }
                
                let profilImagePrefered = userSessionFacebook.profilImagePrefered
                var profilImage: UIImage?
                
                if profilImagePrefered == .AvatarDochaImage && userSession.avatar != ""  {
                    if let avatarString = userSessionFacebook.avatar {
                        profilImage = UIImage(named: avatarString)
                    }
                    
                } else if profilImagePrefered == .FacebookImage {
                    if let fbImageURL = userSessionFacebook.facebookImageURL {
                        self.avatarImageView.downloadedFrom(link: fbImageURL, contentMode: .ScaleToFill, WithCompletion: { (success) in
                            if success {
                                if userSession.gender == "M" || userSession.gender == "U" {
                                    profilImage = UIImage(named: "avatar_man_profil")
                                } else {
                                    profilImage = UIImage(named: "avatar_woman_profil")
                                }
                                
                            } else {
                                profilImage = self.avatarImageView.image
                            }
                        })
                    }
                    
                } else {
                    if let photoImage = userSessionFacebook.getUserProfileImage() {
                        profilImage = photoImage
                    }
                }
                
                self.avatarImageView.image = profilImage
                
            } else {
                self.userNameLabel.text = ""
                self.avatarImageView.image = UIImage(named: "avatar_man_profil")
            }
        }
        
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.height/2
        self.avatarImageView.layer.borderWidth = 3.0
        self.avatarImageView.layer.borderColor = UIColor.whiteColor().CGColor
        self.avatarImageView.layer.masksToBounds = false
        self.avatarImageView.clipsToBounds = true
    }
    
    
//MARK: Table View Controller - Data Source Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = self.tableView.dequeueReusableCellWithIdentifier(self.idsTableViewCell[indexPath.row], forIndexPath: indexPath) as! HomePlayTableViewCell
            cell.delegate = self
            cell.levelLabel.text = "Niveau \(self.userGameManager.getUserLevel())"
            cell.levelBarView.initLevelBar()
            cell.levelBarView.updateLevelBarWithWidth(CGFloat(UserGameStateManager.sharedInstance.getExperienceProgressionInPercent()))
            return cell
            
        } else if indexPath.row == 1 {
            let cell = self.tableView.dequeueReusableCellWithIdentifier(self.idsTableViewCell[indexPath.row], forIndexPath: indexPath) as! HomeFriendsTableViewCell
            cell.delegate = self
            return cell
            
        } else {
            let cell = self.tableView.dequeueReusableCellWithIdentifier(self.idsTableViewCell[indexPath.row], forIndexPath: indexPath) as! HomeBadgesTableViewCell
            return cell
        }
    }
    
    
//MARK: Table View Controller - Delegate Methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        return
    }
    
    func playButtonTouched() {
        
        // Amplitude Event
        Amplitude.instance().logEvent("HomeGameLaunched")
        
        let productManager = ProductManager.sharedInstance
        
        self.presentViewController(DochaPopupHelper.sharedInstance.showLoadingPopup("Nous préparons tes produits...")!, animated: true, completion: {
            
            productManager.getPackOfProducts({ (finished, packOfProducts) in
                if finished && packOfProducts != nil {
                    self.dismissViewControllerAnimated(true, completion: { 
                        let gameplayVC = self.storyboard?.instantiateViewControllerWithIdentifier("idGameplayViewController") as! GameplayViewController
                        gameplayVC.productsList = packOfProducts
                        self.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(gameplayVC, animated: true)
                    })
                    
                } else {
                    print("Error when loading products...")
                    self.presentViewController(DochaPopupHelper.sharedInstance.showErrorPopup("Oups", message: "Il semblerait que vous ne soyez pas connecté à internet... :( Essayer à nouveau ultérieurement")!, animated: true, completion: nil)
                }
            })
        })
    }
    

//MARK: HomeFriendsCellDelegate Methods
    
    func displayAllFriendsButtonTouched() {
        
    }
    
    func inviteFacebookFriendsCellTouched() {
        let content = FBSDKAppInviteContent()
        content.appLinkURL = NSURL(string: "URL_IOS_APP")
        FBSDKAppInviteDialog.showFromViewController(self, withContent: content, delegate: self)
    }
    
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        self.presentViewController(DochaPopupHelper.sharedInstance.showSuccessPopup("Succès", message: "Vos amis ont bien été invités. Docha te remercie beaucoup pour ton aide.")!, animated: true, completion: nil)
    }
    
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: NSError!) {
        self.presentViewController(DochaPopupHelper.sharedInstance.showErrorPopup("Oups !", message: "Un peu de patience, cette fonctionnalité sera bientôt disponible !")!, animated: true, completion: nil)
    }
    
    
//MARK: @IBActions Methods
    
    @IBAction func profilImageTouched(sender: AnyObject) {
        // Amplitude
        Amplitude.instance().logEvent("HomeClickPhoto")
    }
    
    
//MARK: Push Segue Methods
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "idPushGameplaySegue" {
            self.hidesBottomBarWhenPushed = true
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "idPushGameplaySegue" {
            let reachability: Reachability
            do {
                reachability = try Reachability.reachabilityForInternetConnection()
            } catch {
                print("Unable to create Reachability")
                return false
            }
            
            reachability.whenUnreachable = { reachability in
                dispatch_async(dispatch_get_main_queue()) {
                    print("Not reachable")
                }
            }
        }
        return true
    }
}