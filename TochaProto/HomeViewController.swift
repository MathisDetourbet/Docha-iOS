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
import SWTableViewCell
import PullToRefresh

class HomeViewController: GameViewController, UITableViewDelegate, UITableViewDataSource, HomeUserTurnCellDelegate, HomeFriendsCellDelegate, FBSDKAppInviteDialogDelegate, SWTableViewCellDelegate {
    
    let idsTableViewCell: [String] = ["idHomeUserTurnTableViewCell", "idHomeOpponentTurnTableViewCell", "idHomeGameFinishedTableViewCell", "idHomeFriendsTableViewCell"]
    let userGameManager: UserGameStateManager = UserGameStateManager.sharedInstance
    let sectionsNames = ["TON TOUR", "SON TOUR", "TERMINÉS", "AMIS"]
    
    let numberOfRows = [2, 1, 2, 1]
    
    var isBubbleOpen: Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userLevelBar: LevelBarView!
    @IBOutlet weak var userLevelLabel: UILabel!
    @IBOutlet weak var bubbleDochosImageView: UIImageView!
    @IBOutlet weak var bubblePerfectsImageView: UIImageView!
    
    
//MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserInfos()
        UserGameStateManager.sharedInstance.authenticateLocalPlayer()
        self.navigationController?.navigationBarHidden = true
    }
    
    deinit {
        tableView.removePullToRefresh(tableView.topPullToRefresh!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        configGameNavigationBar()
        
        if UserSessionManager.sharedInstance.needsToUpdateHome {
            loadUserInfos()
            UserSessionManager.sharedInstance.needsToUpdateHome = false
        }
        
        buildUI()
        
        // Amplitude
        Amplitude.instance().logEvent("TabNavHome")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func buildUI() {
        self.view.backgroundColor = UIColor.lightGrayDochaColor()
        
        let headerView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 90.0))
        
        let newGameButton = UIButton(type: .Custom)
        newGameButton.translatesAutoresizingMaskIntoConstraints = false
        newGameButton.setImage(UIImage(named: "btn_newgame-1"), forState: .Normal)
        newGameButton.addTarget(self, action: #selector(HomeViewController.newGameButtonTouched), forControlEvents: .TouchUpInside)
        headerView.addSubview(newGameButton)
        
        //headerView.addConstraint(NSLayoutConstraint(item: newGameButton, attribute: .Top, relatedBy: .Equal, toItem: headerView, attribute: .Top, multiplier: 1.0, constant: 15.0))
        //headerView.addConstraint(NSLayoutConstraint(item: newGameButton, attribute: .Bottom, relatedBy: .Equal, toItem: headerView, attribute: .Bottom, multiplier: 1.0, constant: 15.0))
        //headerView.addConstraint(NSLayoutConstraint(item: newGameButton, attribute: .Leading, relatedBy: .Equal, toItem: headerView, attribute: .Leading, multiplier: 1.0, constant: 8.0))
        //headerView.addConstraint(NSLayoutConstraint(item: newGameButton, attribute: .Trailing, relatedBy: .Equal, toItem: headerView, attribute: .Trailing, multiplier: 1.0, constant: 8.0))
        headerView.addConstraint(NSLayoutConstraint(item: newGameButton, attribute: .CenterX, relatedBy: .Equal, toItem: headerView, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        headerView.addConstraint(NSLayoutConstraint(item: newGameButton, attribute: .CenterY, relatedBy: .Equal, toItem: headerView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        
        self.tableView.tableHeaderView = headerView
        
        self.tableView.backgroundColor = UIColor.lightGrayDochaColor()
        let refresher = PullToRefresh()
        self.tableView.addPullToRefresh(refresher) {}
        
        self.userLevelLabel.text = "Niveau \(self.userGameManager.getUserLevel())"
        self.userLevelBar.initLevelBar()
        self.userLevelBar.updateLevelBarWithWidth(CGFloat(UserGameStateManager.sharedInstance.getExperienceProgressionInPercent()))
        
        self.bubbleDochosImageView.hidden = true
        self.bubblePerfectsImageView.hidden = true
    }
    
    
//MARK: Load Data Methods
    
    func loadUserInfos() {
        if let userSession = UserSessionManager.sharedInstance.currentSession() {
            
            if userSession.isKindOfClass(UserSessionEmail) {
                let userSessionEmail = userSession as! UserSessionEmail
                
                if userSession.pseudo == "" {
                    if let firstName = userSessionEmail.firstName, lastName = userSessionEmail.lastName {
                        self.userNameLabel.text = "\(firstName) \(Array(arrayLiteral: lastName)[0])."
                        
                    } else {
                        self.userNameLabel.text = ""
                    }
                    
                } else {
                    self.userNameLabel.text = userSession.pseudo
                }
                
                var profilImage: UIImage?
                
                if let avatar = userSession.avatar {
                    profilImage = UIImage(named: avatar)
                    
                } else if let gender = userSession.gender {
                    if gender == "M" || userSession.gender == "U" {
                        profilImage = UIImage(named: "avatar_man_profil")
                        userSession.avatar = "avatar_man_profil"
                        
                    } else {
                        profilImage = UIImage(named: "avatar_woman_profil")
                        userSession.avatar = "avatar_woman_profil"
                    }
                    userSession.saveSession()
                    
                } else {
                    profilImage = UIImage(named: "avatar_man_profil")
                }
                
                self.avatarImageView.image = profilImage
                
            } else if userSession.isKindOfClass(UserSessionFacebook) {
                let userSessionFacebook = userSession as! UserSessionFacebook
                
                if userSession.pseudo != "" {
                    self.userNameLabel.text = userSession.pseudo
                    
                } else if let firstName = userSessionFacebook.firstName, lastName = userSessionFacebook.lastName {
                    self.userNameLabel.text = "\(firstName) \(lastName[0])."
                }
                
                var profilImage: UIImage?
                
                if let fbImageURL = userSessionFacebook.facebookImageURL {
                    self.avatarImageView.downloadedFrom(link: fbImageURL, contentMode: .ScaleToFill, WithCompletion: { (success) in
                        if success == false {
                            if let gender = userSession.gender {
                                if gender == "M" || gender == "U" {
                                    profilImage = UIImage(named: "avatar_man_profil")
                                    
                                } else {
                                    profilImage = UIImage(named: "avatar_woman_profil")
                                }
                                self.avatarImageView.image = profilImage
                                
                            } else {
                                profilImage = UIImage(named: "avatar_man_profil")
                            }
                        }
                    })
                    
                } else {
                    profilImage = UIImage(named: "avatar_man_profil")
                }
                
            } else {
                self.userNameLabel.text = ""
                self.avatarImageView.image = UIImage(named: "avatar_man_profil")
            }
        }
        
        self.avatarImageView.applyCircleBorder()
    }
    
    
//MARK: Table View Controller - Data Source Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfRows[section]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sectionsNames.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionsNames[section]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // TON TOUR
            let cell = self.tableView.dequeueReusableCellWithIdentifier(self.idsTableViewCell[indexPath.section], forIndexPath: indexPath) as! HomeUserTurnTableViewCell
            cell.opponentNameLabel.text = "Martin A."
            cell.opponentLevelLabel.text = "Niveau 3"
            cell.opponentScoreLabel.text = "1"
            cell.userScoreLabel.text = "0"
            cell.opponentImageView.image = UIImage(named: "avatar_man_marin")
            cell.delegateUserTurn = self
            cell.delegate = self
            cell.rightUtilityButtons = [self.buildDeleteButtonCell()]
            
            return cell
            
        } else if indexPath.section == 1 {
            // SON TOUR
            let cell = self.tableView.dequeueReusableCellWithIdentifier(self.idsTableViewCell[indexPath.section], forIndexPath: indexPath) as! HomeOpponentTurnTableViewCell
            cell.opponentNameLabel.text = "Alice A."
            cell.opponentLevelLabel.text = "Niveau 1"
            cell.opponentScoreLabel.text = "1"
            cell.userScoreLabel.text = "2"
            cell.opponentImageView.image = UIImage(named: "avatar_woman")
            cell.rightUtilityButtons = [self.buildDeleteButtonCell()]
            
            return cell
            
        } else if indexPath.section == 2 {
            // TERMINES
            let cell = self.tableView.dequeueReusableCellWithIdentifier(self.idsTableViewCell[indexPath.section], forIndexPath: indexPath) as! HomeGameFinishedTableViewCell
            cell.opponentNameLabel.text = "Tristan B."
            cell.opponentLevelLabel.text = "Niveau 8"
            cell.opponentScoreLabel.text = "3"
            cell.userScoreLabel.text = "1"
            cell.opponentImageView.image = UIImage(named: "avatar_man_super")
            cell.wonGame = true
            cell.rightUtilityButtons = [self.buildDeleteButtonCell()]
            
            return cell
            
        } else {
            // AMIS
            let cell = self.tableView.dequeueReusableCellWithIdentifier(self.idsTableViewCell[indexPath.section], forIndexPath: indexPath) as! HomeFriendsTableViewCell
            cell.delegate = self
            
            return cell
        }
    }
    
    
//MARK: Table View Controller - Delegate Methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        return
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRectMake(0, 0, self.tableView.frame.width, 30))
        headerView.backgroundColor = UIColor.lightGrayDochaColor()
        
        let sectionLabel = UILabel(frame: CGRectMake(10.0, 5.0, 100.0, 28.0))
        sectionLabel.textColor = UIColor.darkBlueDochaColor()
        sectionLabel.text = self.sectionsNames[section]
        sectionLabel.font = UIFont(name: "Montserrat-Semibold", size: 12)
        headerView.addSubview(sectionLabel)
        
        return headerView
    }
    
    
//MARK: SWTableViewCell - Delegate Methods
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        
    }

    
//MARK: HomePlayCellDelegate Methods
    
    func newGameButtonTouched() {
        let newGameFindOpponentVC = self.storyboard?.instantiateViewControllerWithIdentifier("idNewGameFindOpponentViewController") as! NewGameFindOpponentViewController
        self.navigationController?.pushViewController(newGameFindOpponentVC, animated: true)
    }
    
    
//MARK: HomeUserTurnCellDelegate Methods
    
    func playButtonTouched() {
//        let gameplayVC = self.storyboard?.instantiateViewControllerWithIdentifier("idGameplayMainViewController") as! GameplayMainViewController
//        self.navigationController?.pushViewController(gameplayVC, animated: true)
        //        Amplitude.instance().logEvent("HomeGameLaunched")
        //
        //        PopupManager.sharedInstance.showLoadingPopup("Chargement en cours...", message: "Nous préparons tes produits.", completion: {
        //            dispatch_async(dispatch_get_main_queue(), {
        //
        //                ProductManager.sharedInstance.getPackOfProducts({ (finished, packOfProducts) in
        //
        //                    if finished && packOfProducts != nil {
        //                        PopupManager.sharedInstance.dismissPopup(true, completion: {
        //                            let gameplayVC = self.storyboard?.instantiateViewControllerWithIdentifier("idGameplayViewController") as! GameplayViewController
        //                            gameplayVC.productsList = packOfProducts
        //                            self.hidesBottomBarWhenPushed = true
        //                            self.navigationController?.pushViewController(gameplayVC, animated: true)
        //                        })
        //
        //                    } else {
        //                        print("Error when loading products...")
        //                        PopupManager.sharedInstance.showErrorPopup("Oups !", message: "La connexion internet semble interrompue. Essaie ultérieurement", completion: nil)
        //                    }
        //                })
        //            })
        //        })
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
    
//MARK: HomeBadgeDelegate Methods
    
    func showAllBadges() {
        let badgesVC = self.storyboard?.instantiateViewControllerWithIdentifier("idBadgeViewController") as! BadgesViewController
        self.navigationController?.pushViewController(badgesVC, animated: true)
    }
    
    func inviteFacebookFriendsCellTouched() {
        PopupManager.sharedInstance.showInfosPopup("Info", message: "Encore un peu de patience, cette fonctionnalité sera prochainement disponible. 😉", completion: nil)
//        let content = FBSDKAppInviteContent()
//        content.appLinkURL = NSURL(string: "https://itunes.apple.com/fr/app/docha/id722842223?mt=8")
//        FBSDKAppInviteDialog.showFromViewController(self, withContent: content, delegate: self)
    }
    
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        PopupManager.sharedInstance.showSuccessPopup("Succès", message: "Tes amis ont bien été invités.", completion: nil)
    }
    
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: NSError!) {
        PopupManager.sharedInstance.showInfosPopup("Oups !", message: "Encore un peu de patience, cette foncitonnalité sera bientôt disponible !", completion: nil)
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
    
    
//MARK: Bubbles Events Methods
    
    func toggleBubble(isBubbleDochos: Bool) {
        
        if isBubbleDochos {
            animateBubble(self.bubbleDochosImageView, openBubble: self.bubbleDochosImageView.hidden)
            self.isBubbleOpen = !self.bubbleDochosImageView.hidden
            if self.bubblePerfectsImageView.hidden == false {
                animateBubble(self.bubblePerfectsImageView, openBubble: false)
            }
            
        } else {
            animateBubble(self.bubblePerfectsImageView, openBubble: self.bubblePerfectsImageView.hidden)
            self.isBubbleOpen = !self.bubblePerfectsImageView.hidden
            self.bubbleDochosImageView.hidden = self.bubbleDochosImageView.hidden ? false : true
            if self.bubbleDochosImageView.hidden == false {
                animateBubble(self.bubbleDochosImageView, openBubble: false)
            }
        }
    }
    
    func animateBubble(bubble: UIImageView, openBubble: Bool) {
        bubble.hidden = !openBubble
        var fromValue = 0.0
        var toValue = 0.0
        
        if openBubble {
            fromValue = 0.0
            toValue = 1.0
            
        } else {
            fromValue = 1.0
            toValue = 0.0
        }
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = 0.1
        scaleAnimation.fromValue = fromValue
        scaleAnimation.toValue = toValue
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        scaleAnimation.autoreverses = false
        scaleAnimation.repeatCount = 0
        bubble.layer.addAnimation(scaleAnimation, forKey: nil)
    }
    
    
//MARK: @IBActions Methods
    
    @IBAction func preferencesButtonTouched(sender: UIButton) {
        let preferencesVC = self.storyboard?.instantiateViewControllerWithIdentifier("idPreferencesNavController") as! UINavigationController
        self.presentViewController(preferencesVC, animated: true, completion: nil)
    }
    
    @IBAction func rankingButtonTouched(sender: UIButton) {
        
    }
    
    @IBAction func sharingButtonTouched(sender: UIButton) {
        
    }
    
    @IBAction func bubblePerfectsButtonTouched(sender: UIButton) {
        toggleBubble(false)
    }
    
    @IBAction func bubbleDochosButtonTouched(sender: UIButton) {
        toggleBubble(true)
    }
    
//MARK: Push Segue Methods
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "idPushGameplaySegue" {
            self.hidesBottomBarWhenPushed = true
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "idPushGameplaySegue" {
            var reachability: Reachability
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
    
    func buildDeleteButtonCell() -> UIButton! {
        let deleteButton = UIButton(type: .Custom)
        deleteButton.backgroundColor = UIColor.redDochaColor()
        deleteButton.setImage(UIImage(named: "bin_icon"), forState: .Normal)
        
        return deleteButton
    }
}