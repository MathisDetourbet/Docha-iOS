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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func getFriendsList() {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logInWithReadPermissions(["user_friends"], fromViewController: self)
        { (result, error) -> Void in
            
            if error != nil {
                print("Facebook login : process error : \(error)")
                return
                
            } else if (result.isCancelled) {
                print("Facebook login : cancelled")
                return
                
            } else {
                let fbloginresult : FBSDKLoginManagerLoginResult = result
                
                if(fbloginresult.grantedPermissions.contains("user_friends")) {
                    print("Facebook Access token : \(FBSDKAccessToken.currentAccessToken().tokenString)")
                    
                    if((FBSDKAccessToken.currentAccessToken()) != nil) {
                        let fbRequest = FBSDKGraphRequest(graphPath:"/me/friends", parameters: nil);
                        fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
                        
                            if error == nil {
                                print("Friends are : \(result)")
                                let jsonResponse = JSON(result)
                                let arrayFriends = jsonResponse["data"].array
                                print(arrayFriends!.count)
                                
                            } else {
                                print("Error Getting Friends \(error)")
                            }
                        }
                        
                    } else {
                        print("Token is nil")
                    }
                }
 
            }
        }
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
        
            self.tabBarController!.presentViewController(PopupManager.sharedInstance.showLoadingPopup("Chargement en cours...", message: "Nous préparons tes produits."), animated: true) {
                PopupManager.sharedInstance.modalAnimationFinished()
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    ProductManager.sharedInstance.getPackOfProducts({ (finished, packOfProducts) in
                        if finished && packOfProducts != nil {
                            self.dismissViewControllerAnimated(true, completion: {
                                let gameplayVC = self.storyboard?.instantiateViewControllerWithIdentifier("idGameplayViewController") as! GameplayViewController
                                gameplayVC.productsList = packOfProducts
                                self.hidesBottomBarWhenPushed = true
                                self.navigationController?.pushViewController(gameplayVC, animated: true)
                            })
                            
                        } else {
                            print("Error when loading products...")
                            self.tabBarController!.presentViewController(PopupManager.sharedInstance.showErrorPopup("Oups !", message: "La connexion internet semble interrompue. Essaie ultérieurement"), animated: true) {
                                PopupManager.sharedInstance.modalAnimationFinished()
                            }
                        }
                    })
                })
            }
    }
    

//MARK: HomeFriendsCellDelegate Methods
    
    func displayAllFriendsButtonTouched() {
        let params = ["fields" : "id, first_name, last_name, email, picture"]
        let fbRequest = FBSDKGraphRequest(graphPath:"/me/friends", parameters: params);
        fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            
            if error == nil {
                let jsonResponse = JSON(result)
                let arrayFriends = jsonResponse["data"].array
                print(arrayFriends!)
            } else {
                print("Error Getting Friends \(error)")
            }
        }
    }
    
    func inviteFacebookFriendsCellTouched() {
        let content = FBSDKAppInviteContent()
        content.appLinkURL = NSURL(string: "https://itunes.apple.com/fr/app/docha/id722842223?mt=8")
        FBSDKAppInviteDialog.showFromViewController(self, withContent: content, delegate: self)
    }
    
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        self.tabBarController!.presentViewController(PopupManager.sharedInstance.showSuccessPopup("Succès", message: "Vos amis ont bien été invités."), animated: true) {
            PopupManager.sharedInstance.modalAnimationFinished()
        }
    }
    
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: NSError!) {
        self.tabBarController!.presentViewController(PopupManager.sharedInstance.showInfosPopup("Oups !", message: "Encore un peu de patience, cette foncitonnalité sera bientôt disponible"), animated: true) {
            PopupManager.sharedInstance.modalAnimationFinished()
        }
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