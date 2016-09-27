//
//  HomeViewController.swift
//  Docha
//
//  Created by Mathis D on 06/06/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import AlamofireImage
import Amplitude_iOS
import FBSDKShareKit
import SwiftyJSON
import SWTableViewCell
import PullToRefresh

class HomeViewController: GameViewController, UITableViewDelegate, UITableViewDataSource, HomeUserTurnCellDelegate, HomeFriendsCellDelegate, SWTableViewCellDelegate {
    
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
        self.navigationController?.isNavigationBarHidden = true
    }
    
    deinit {
        tableView.removePullToRefresh(tableView.topPullToRefresh!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        if UserSessionManager.sharedInstance.needsToUpdateHome {
            loadUserInfos()
            UserSessionManager.sharedInstance.needsToUpdateHome = false
        }
        
        buildUI()
        
        // Amplitude
        Amplitude.instance().logEvent("TabNavHome")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func buildUI() {
        self.view.backgroundColor = UIColor.lightGrayDochaColor()
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 90.0))
        
        let newGameButton = UIButton(type: .custom)
        newGameButton.setImage(UIImage(named: "btn_newgame"), for: UIControlState())
        newGameButton.addTarget(self, action: #selector(HomeViewController.newGameButtonTouched), for: .touchUpInside)
        newGameButton.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(newGameButton)
        
        headerView.addConstraint(NSLayoutConstraint(item: newGameButton, attribute: .centerX, relatedBy: .equal, toItem: headerView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        headerView.addConstraint(NSLayoutConstraint(item: newGameButton, attribute: .centerY, relatedBy: .equal, toItem: headerView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        
        tableView.tableHeaderView = headerView
        
        tableView.backgroundColor = UIColor.lightGrayDochaColor()
        let refresher = PullToRefresh()
        tableView.addPullToRefresh(refresher) {}
        
        userLevelLabel.text = "Niveau \(self.userGameManager.getUserLevel())"
        userLevelBar.initLevelBar()
        userLevelBar.updateLevelBarWithWidth(CGFloat(UserGameStateManager.sharedInstance.getExperienceProgressionInPercent()))
        
        bubbleDochosImageView.isHidden = true
        bubblePerfectsImageView.isHidden = true
    }
    
    
//MARK: Load Data Methods
    
    func loadUserInfos() {
        if let userSession = UserSessionManager.sharedInstance.currentSession() {
            
            if userSession.isKind(of: UserSessionEmail.self) {
                let userSessionEmail = userSession as! UserSessionEmail
                
                if userSession.pseudo == "" {
                    if let _ = userSessionEmail.firstName, let _ = userSessionEmail.lastName {
                        //userNameLabel.text = "\(firstName) \(Array(arrayLiteral: lastName)[0])."
                        userNameLabel.text = ""
                        
                    } else {
                        userNameLabel.text = ""
                    }
                    
                } else {
                    userNameLabel.text = userSession.pseudo
                }
                
                var profilImage: UIImage?
                
                if let avatar = userSession.avatar {
                    profilImage = UIImage(named: avatar)
                    
                } else if let gender = userSession.gender {
                    if gender == "M" || userSession.gender == "U" {
                        profilImage = UIImage(named: "avatar_man_large")
                        userSession.avatar = "avatar_man_large"
                        
                    } else {
                        profilImage = UIImage(named: "avatar_woman_large")
                        userSession.avatar = "avatar_woman_large"
                    }
                    userSession.saveSession()
                    
                } else {
                    profilImage = UIImage(named: "avatar_man_large")
                }
                
                avatarImageView.image = profilImage
                
            } else if userSession.isKind(of: UserSessionFacebook.self) {
                let userSessionFacebook = userSession as! UserSessionFacebook
                
                if userSession.pseudo != "" {
                    userNameLabel.text = userSession.pseudo
                    
                } else if let firstName = userSessionFacebook.firstName, let lastName = userSessionFacebook.lastName {
                    userNameLabel.text = "\(firstName) \(lastName[0])."
                }
                
                var profilImage: UIImage?
                
                if let fbImageURL = userSessionFacebook.facebookImageURL {
                    avatarImageView.downloadedFrom(link: fbImageURL, contentMode: .scaleToFill, WithCompletion: { (success) in
                        if success == false {
                            if let gender = userSession.gender {
                                if gender == "M" || gender == "U" {
                                    profilImage = UIImage(named: "avatar_man_large")
                                    
                                } else {
                                    profilImage = UIImage(named: "avatar_woman_large")
                                }
                                self.avatarImageView.image = profilImage
                                
                            } else {
                                profilImage = UIImage(named: "avatar_man_large")
                            }
                        }
                    })
                    
                } else {
                    profilImage = UIImage(named: "avatar_man_large")
                }
                
            } else {
                userNameLabel.text = ""
                avatarImageView.image = UIImage(named: "avatar_man_large")
            }
        }
        avatarImageView.image = UIImage(named: "avatar_man_large")
        avatarImageView.applyCircleBorder()
    }
    
    
//MARK: Table View Controller - Data Source Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsNames.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsNames[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).section == 0 {
            // TON TOUR
            let cell = tableView.dequeueReusableCell(withIdentifier: self.idsTableViewCell[(indexPath as NSIndexPath).section], for: indexPath) as! HomeUserTurnTableViewCell
            cell.opponentNameLabel.text = "Martin A."
            cell.opponentLevelLabel.text = "Niveau 3"
            cell.opponentScoreLabel.text = "1"
            cell.userScoreLabel.text = "0"
            cell.opponentImageView.image = UIImage(named: "avatar_man_medium")
            cell.delegateUserTurn = self
            cell.delegate = self
            cell.rightUtilityButtons = [self.buildDeleteButtonCell()]
            
            return cell
            
        } else if (indexPath as NSIndexPath).section == 1 {
            // SON TOUR
            let cell = tableView.dequeueReusableCell(withIdentifier: self.idsTableViewCell[(indexPath as NSIndexPath).section], for: indexPath) as! HomeOpponentTurnTableViewCell
            cell.opponentNameLabel.text = "Alice A."
            cell.opponentLevelLabel.text = "Niveau 1"
            cell.opponentScoreLabel.text = "1"
            cell.userScoreLabel.text = "2"
            cell.opponentImageView.image = UIImage(named: "avatar_woman_medium")
            cell.rightUtilityButtons = [self.buildDeleteButtonCell()]
            
            return cell
            
        } else if (indexPath as NSIndexPath).section == 2 {
            // TERMINES
            let cell = tableView.dequeueReusableCell(withIdentifier: self.idsTableViewCell[(indexPath as NSIndexPath).section], for: indexPath) as! HomeGameFinishedTableViewCell
            cell.opponentNameLabel.text = "Tristan B."
            cell.opponentLevelLabel.text = "Niveau 8"
            cell.opponentScoreLabel.text = "3"
            cell.userScoreLabel.text = "1"
            cell.opponentImageView.image = UIImage(named: "avatar_man_medium")
            cell.wonGame = true
            cell.rightUtilityButtons = [self.buildDeleteButtonCell()]
            
            return cell
            
        } else {
            // AMIS
            let cell = tableView.dequeueReusableCell(withIdentifier: self.idsTableViewCell[(indexPath as NSIndexPath).section], for: indexPath) as! HomeFriendsTableViewCell
            cell.delegate = self
            
            return cell
        }
    }
    
    
//MARK: Table View Controller - Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 30))
        headerView.backgroundColor = UIColor.lightGrayDochaColor()
        
        let sectionLabel = UILabel(frame: CGRect(x: 10.0, y: 5.0, width: 100.0, height: 28.0))
        sectionLabel.textColor = UIColor.darkBlueDochaColor()
        sectionLabel.text = self.sectionsNames[section]
        sectionLabel.font = UIFont(name: "Montserrat-Semibold", size: 12)
        headerView.addSubview(sectionLabel)
        
        return headerView
    }
    
    
//MARK: SWTableViewCell - Delegate Methods
    
    func swipeableTableViewCell(_ cell: SWTableViewCell!, didTriggerRightUtilityButtonWith index: Int) {
        
    }

    
//MARK: HomePlayCellDelegate Methods
    
    func newGameButtonTouched() {
        let newGameFindOpponentVC = self.storyboard?.instantiateViewController(withIdentifier: "idNewGameFindOpponentViewController") as! NewGameFindOpponentViewController
        self.navigationController?.pushViewController(newGameFindOpponentVC, animated: true)
    }
    
    
//MARK: HomeUserTurnCellDelegate Methods
    
    func playButtonTouched() {
        
    }

//MARK: HomeFriendsCellDelegate Methods
    
    func displayAllFriendsButtonTouched() {
        let params = ["fields" : "id, first_name, last_name, email, picture"]
        _ = FBSDKGraphRequest(graphPath:"/me/friends", parameters: params);
//        fbRequest?.start { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
//            
//            if error == nil {
//                let jsonResponse = JSON(result)
//                let arrayFriends = jsonResponse["data"].array
//                print(arrayFriends!)
//            } else {
//                print("Error Getting Friends \(error)")
//            }
//        }
    }
    
//MARK: HomeBadgeDelegate Methods
    
    func showAllBadges() {
        let badgesVC = self.storyboard?.instantiateViewController(withIdentifier: "idBadgeViewController") as! BadgesViewController
        self.navigationController?.pushViewController(badgesVC, animated: true)
    }
    
    func inviteFacebookFriendsCellTouched() {
        PopupManager.sharedInstance.showInfosPopup("Info", message: "Encore un peu de patience, cette fonctionnalité sera prochainement disponible. 😉", completion: nil)
//        let content = FBSDKAppInviteContent()
//        content.appLinkURL = NSURL(string: "https://itunes.apple.com/fr/app/docha/id722842223?mt=8")
//        FBSDKAppInviteDialog.showFromViewController(self, withContent: content, delegate: self)
    }
    
//    func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [AnyHashable: Any]!) {
//        PopupManager.sharedInstance.showSuccessPopup("Succès", message: "Tes amis ont bien été invités.", completion: nil)
//    }
//    
//    func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: NSError!) {
//        PopupManager.sharedInstance.showInfosPopup("Oups !", message: "Encore un peu de patience, cette foncitonnalité sera bientôt disponible !", completion: nil)
//    }
    
    /*
    func getFriendsList() {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logIn(withReadPermissions: ["user_friends"], from: self)
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
                    print("Facebook Access token : \(FBSDKAccessToken.current().tokenString)")
                    
                    if((FBSDKAccessToken.current()) != nil) {
                        let fbRequest = FBSDKGraphRequest(graphPath:"/me/friends", parameters: nil);
                        fbRequest.start { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
                            
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
    */
    
    
//MARK: Bubbles Events Methods
    
    func toggleBubble(_ isBubbleDochos: Bool) {
        
        if isBubbleDochos {
            animateBubble(bubbleDochosImageView, openBubble: bubbleDochosImageView.isHidden)
            isBubbleOpen = !bubbleDochosImageView.isHidden
            if bubblePerfectsImageView.isHidden == false {
                animateBubble(bubblePerfectsImageView, openBubble: false)
            }
            
        } else {
            animateBubble(bubblePerfectsImageView, openBubble: bubblePerfectsImageView.isHidden)
            isBubbleOpen = !bubblePerfectsImageView.isHidden
            bubbleDochosImageView.isHidden = bubbleDochosImageView.isHidden ? false : true
            if bubbleDochosImageView.isHidden == false {
                animateBubble(bubbleDochosImageView, openBubble: false)
            }
        }
    }
    
    func animateBubble(_ bubble: UIImageView, openBubble: Bool) {
        bubble.isHidden = !openBubble
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
        bubble.layer.add(scaleAnimation, forKey: nil)
    }
    
    
//MARK: @IBActions Methods
    
    @IBAction func preferencesButtonTouched(_ sender: UIButton) {
        let preferencesVC = self.storyboard?.instantiateViewController(withIdentifier: "idPreferencesNavController") as! UINavigationController
        self.present(preferencesVC, animated: true, completion: nil)
    }
    
    @IBAction func rankingButtonTouched(_ sender: UIButton) {
        let rankingVC = self.storyboard?.instantiateViewController(withIdentifier: "idRankingNavController") as! UINavigationController
        self.present(rankingVC, animated: true, completion: nil)
    }
    
    @IBAction func sharingButtonTouched(_ sender: UIButton) {
        
    }
    
    @IBAction func bubblePerfectsButtonTouched(_ sender: UIButton) {
        toggleBubble(false)
    }
    
    @IBAction func bubbleDochosButtonTouched(_ sender: UIButton) {
        toggleBubble(true)
    }
    
//MARK: Push Segue Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "idPushGameplaySegue" {
            self.hidesBottomBarWhenPushed = true
        }
    }
    
    func buildDeleteButtonCell() -> UIButton! {
        let deleteButton = UIButton(type: .custom)
        deleteButton.backgroundColor = UIColor.redDochaColor()
        deleteButton.setImage(UIImage(named: "bin_icon"), for: UIControlState())
        
        return deleteButton
    }
}
