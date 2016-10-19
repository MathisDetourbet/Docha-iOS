//
//  HomeViewController.swift
//  Docha
//
//  Created by Mathis D on 06/06/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import AlamofireImage
import Kingfisher
import Amplitude_iOS
import FBSDKShareKit
import SwiftyJSON
import SWTableViewCell
import PullToRefresh

enum HomeSectionName: Int {
    case userTurn = 0
    case opponentTurn = 1
    case finished = 2
    case friends = 3
}

class HomeViewController: GameViewController, UITableViewDelegate, UITableViewDataSource, HomeUserTurnCellDelegate, HomeFriendsCellDelegate, SWTableViewCellDelegate {
    
    let idsTableViewCell: [String] = ["idHomeUserTurnTableViewCell", "idHomeOpponentTurnTableViewCell", "idHomeGameFinishedTableViewCell", "idHomeFriendsTableViewCell"]
    let sectionsNames = ["TON TOUR", "SON TOUR", "TERMINÉS", "AMIS"]
    
    let numberOfRows = [2, 1, 2, 1]
    var sortedMatch: [[Match]] = []
    
    var isBubbleOpen: Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userDochosLabel: UILabel!
    @IBOutlet weak var userPerfectLabel: UILabel!
    @IBOutlet weak var userLevelBar: LevelBarView!
    @IBOutlet weak var userLevelLabel: UILabel!
    @IBOutlet weak var bubbleDochosImageView: UIImageView!
    @IBOutlet weak var bubblePerfectsImageView: UIImageView!
    
    
//MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserSessionManager.sharedInstance.hasFinishedTutorial() == false {
            let tutorialVC = self.storyboard?.instantiateViewController(withIdentifier: "idTutorialViewController") as! TutorialViewController
            if PopupManager.sharedInstance.isDisplayingPopup {
                PopupManager.sharedInstance.dismissPopup(true,
                    completion: {
                        self.navigationController?.present(tutorialVC, animated: true, completion: nil)
                    }
                )
            } else {
                self.navigationController?.present(tutorialVC, animated: true, completion: nil)
            }
        }
        
        loadUserInfos()
        loadAllMatch(withCompletion: nil)
        UserGameStateManager.sharedInstance.authenticateLocalPlayer()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    deinit {
        tableView.removePullToRefresh(tableView.topPullToRefresh!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        loadUserInfos()
        buildUI()
        
        // Amplitude
        Amplitude.instance().logEvent("TabNavHome")
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
        tableView.addPullToRefresh(refresher) { 
            self.loadAllMatch(
                withCompletion: {
                    self.tableView.endRefreshing(at: Position.top)
                }
            )
        }
        
        let userLevel = UserGameStateManager.sharedInstance.getUserLevel()
        userLevelLabel.text = "Niveau \(userLevel)"
        userLevelBar.updateLevelBarWithWidth(CGFloat(UserGameStateManager.sharedInstance.getExperienceProgressionInPercent()))
        
        bubbleDochosImageView.isHidden = true
        bubblePerfectsImageView.isHidden = true
    }
    
    
//MARK: Load Data Methods
    
    func loadUserInfos() {
        let userData = UserSessionManager.sharedInstance.getUserInfosAndAvatarImage(withImageSize: .large)
        userNameLabel.text = userData.user?.pseudo ?? Player.defaultPlayer().pseudo
        
        let image = userData.avatarImage ?? #imageLiteral(resourceName: "avatar_man_large")
        userAvatarImageView.image = image.roundCornersToCircle(withBorder: 10.0, color: UIColor.white)
        
        userDochosLabel.text = "\(userData.user!.dochos)"
        userPerfectLabel.text = "\(userData.user!.perfectPriceCpt)"
    }
    
    func loadAllMatch(withCompletion completion: (() -> Void)?) {
        MatchManager.sharedInstance.getAllMatch(
            success: { (allMatch) in
                
                self.sortedMatch = self.sortMatchArray(matchArray: allMatch)
                self.tableView.reloadData()
                completion?()
                
            }) { (error) in
                PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorNoInternetConnection)
                completion?()
        }
    }
    
    func sortMatchArray(matchArray: [Match]) -> [[Match]] {
        var sortedMatch: [[Match]] = [[], [], [], []]
        
        for match in matchArray {
            
            switch match.status {
            case .userTurn:
                sortedMatch[HomeSectionName.userTurn.rawValue].append(match)
                break
            case .opponentTurn, .waiting:
                sortedMatch[HomeSectionName.opponentTurn.rawValue].append(match)
                break
            case .won, .lost, .tie:
                sortedMatch[HomeSectionName.finished.rawValue].append(match)
                break
            }
        }
        
        return sortedMatch
    }
    
    
//MARK: Table View Controller - Data Source Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedMatch[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedMatch.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsNames[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath as NSIndexPath).section == HomeSectionName.userTurn.rawValue {
            // TON TOUR
            let cell = tableView.dequeueReusableCell(withIdentifier: idsTableViewCell[(indexPath as NSIndexPath).section], for: indexPath) as! HomeUserTurnTableViewCell
            let match = sortedMatch[HomeSectionName.userTurn.rawValue][indexPath.row]
            
            cell.opponentNameLabel.text = match.opponent.pseudo
            cell.opponentLevelLabel.text = "Niveau 1 (fake)"
            cell.opponentScoreLabel.text = String(match.opponentScore ?? 0)
            cell.userScoreLabel.text = String(match.userScore ?? 0)
            
            if match.opponent.playerType == .facebookPlayer {
                cell.opponentImageView.af_setImage(withURL: URL(string: match.opponent.avatarUrl)!)
                
            } else {
                cell.opponentImageView.image = UIImage(named: "\(match.opponent.avatarUrl)_medium")
            }
            
            cell.delegateUserTurn = self
            cell.delegate = self
            cell.rightUtilityButtons = [buildDeleteButtonCell()]
            
            return cell
            
        } else if (indexPath as NSIndexPath).section == HomeSectionName.opponentTurn.rawValue {
            // SON TOUR
            let cell = tableView.dequeueReusableCell(withIdentifier: idsTableViewCell[(indexPath as NSIndexPath).section], for: indexPath) as! HomeOpponentTurnTableViewCell
            let match = sortedMatch[HomeSectionName.opponentTurn.rawValue][indexPath.row]
            
            cell.opponentNameLabel.text = match.opponent.pseudo
            cell.opponentLevelLabel.text = "Niveau 1 (fake)"
            cell.opponentScoreLabel.text = String(match.opponentScore ?? 0)
            cell.userScoreLabel.text = String(match.userScore ?? 0)
            cell.delegate = self
            
            if match.opponent.playerType == .facebookPlayer {
                cell.opponentImageView.af_setImage(withURL: URL(string: match.opponent.avatarUrl)!)
                
            } else {
                cell.opponentImageView.image = UIImage(named: "\(match.opponent.avatarUrl)_medium")
            }
            
            if match.status == .opponentTurn {
                cell.rightUtilityButtons = [buildDeleteButtonCell()]
            }
            
            return cell
            
        } else if (indexPath as NSIndexPath).section == HomeSectionName.finished.rawValue {
            // TERMINES
            let cell = tableView.dequeueReusableCell(withIdentifier: idsTableViewCell[(indexPath as NSIndexPath).section], for: indexPath) as! HomeGameFinishedTableViewCell
            
            let match = sortedMatch[HomeSectionName.finished.rawValue][indexPath.row]
            
            cell.opponentNameLabel.text = match.opponent.pseudo
            cell.opponentLevelLabel.text = "Niveau 1 (fake)"
            cell.opponentScoreLabel.text = String(match.opponentScore!)
            cell.userScoreLabel.text = String(match.userScore!)
            cell.delegate = self
            
            if match.opponent.playerType == .facebookPlayer {
                cell.opponentImageView.af_setImage(withURL: URL(string: match.opponent.avatarUrl)!)
                
            } else {
                cell.opponentImageView.image = UIImage(named: "\(match.opponent.avatarUrl)_medium")
            }
            
            cell.matchResult = match.getMatchResult()
            cell.rightUtilityButtons = [buildDeleteButtonCell()]
            
            return cell
            
        } else {
            // AMIS
            let cell = tableView.dequeueReusableCell(withIdentifier: idsTableViewCell[(indexPath as NSIndexPath).section], for: indexPath) as! HomeFriendsTableViewCell
            cell.delegate = self
            
            return cell
        }
    }
    

//MARK: Table View Controller - Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == HomeSectionName.friends.rawValue {
            
            
        } else {
            let matchData = sortedMatch[indexPath.section][indexPath.row]
            let matchVC = self.storyboard?.instantiateViewController(withIdentifier: "idGameplayMatchViewController") as! GameplayMatchViewController
            MatchManager.sharedInstance.currentMatch = matchData
            matchVC.match = matchData
            self.navigationController?.pushViewController(matchVC, animated: true)
        }
        
        //tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
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
        let indexPath = tableView.indexPath(for: cell)
        
        if let indexPath = indexPath {
            let match = sortedMatch[indexPath.section][indexPath.row]
            MatchManager.sharedInstance.deleteMatch(ForMatchID: match.id, andRoundID: match.rounds.last?.id,
                success: {
                    
                    self.sortedMatch[indexPath.section].remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    
                }, fail: { (error) in
                    PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorOccured)
                }
            )
        }
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
