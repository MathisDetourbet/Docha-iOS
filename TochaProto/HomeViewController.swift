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
import FBSDKShareKit
import SwiftyJSON
import SWTableViewCell
import PullToRefresh
import SACountingLabel

enum HomeSectionName: Int, CustomStringConvertible {
    case userTurn = 0
    case opponentTurn = 1
    case finished = 2
    case friends = 3
    
    var description: String {
        switch self {
        case .userTurn:
            return "TON TOUR"
        case .opponentTurn:
            return "SON TOUR"
        case .finished:
            return "TERMINÉS"
        case .friends:
            return "AMIS"
        }
    }
}

class HomeViewController: GameViewController, UITableViewDelegate, UITableViewDataSource, HomeUserTurnCellDelegate, HomeFriendsCellDelegate, SWTableViewCellDelegate, FBSDKSharingDelegate {
    
    let idsTableViewCell: [HomeSectionName : String] = [.userTurn : "idHomeUserTurnTableViewCell",
                                                        .opponentTurn :"idHomeOpponentTurnTableViewCell",
                                                        .finished : "idHomeGameFinishedTableViewCell",
                                                        .friends : "idHomeFriendsTableViewCell"]
    var data: [HomeSectionName: [Any]] = [:]
    var sortedDataKeys: [HomeSectionName] = []
    
    var isBubbleOpen: Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userDochosLabel: SACountingLabel!
    @IBOutlet weak var userPerfectLabel: SACountingLabel!
    @IBOutlet weak var userLevelBar: LevelBarView!
    @IBOutlet weak var userLevelLabel: UILabel!
    @IBOutlet weak var bubbleDochosImageView: UIImageView!
    @IBOutlet weak var bubblePerfectsImageView: UIImageView!
    
    
//MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildUI()
        self.navigationController?.isNavigationBarHidden = true
        
        //NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.refreshHome), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    deinit {
        tableView.removePullToRefresh(tableView.topPullToRefresh!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        refreshHome(withCompletion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkForTutorial()
    }
    
    func buildUI() {
        self.view.backgroundColor = UIColor.lightGrayDochaColor()
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 90))
        
        let newGameButton = UIButton(type: .custom)
        newGameButton.setImage(#imageLiteral(resourceName: "btn_newgame"), for: UIControlState())
        newGameButton.addTarget(self, action: #selector(HomeViewController.newGameButtonTouched), for: .touchUpInside)
        newGameButton.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(newGameButton)
        
        headerView.addConstraint(NSLayoutConstraint(item: newGameButton, attribute: .centerX, relatedBy: .equal, toItem: headerView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        headerView.addConstraint(NSLayoutConstraint(item: newGameButton, attribute: .centerY, relatedBy: .equal, toItem: headerView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        
        tableView.tableHeaderView = headerView
        tableView.backgroundColor = UIColor.lightGrayDochaColor()
        
        let refresher = PullToRefresh()
        tableView.addPullToRefresh(refresher) {
            self.refreshHome(
                withCompletion: {
                    self.tableView.endRefreshing(at: Position.top)
                }
            )
        }
        
        bubbleDochosImageView.isHidden = true
        bubblePerfectsImageView.isHidden = true
    }
    
    func checkForTutorial() {
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
    }
    
    
//MARK: Load Data Methods
    
    func loadUserInfos() {
        let userData = UserSessionManager.sharedInstance.getUserInfosAndAvatarImage(withImageSize: .large)
        
        if let user = userData.user, let avatarImage = userData.avatarImage {
            userNameLabel.text = user.pseudo
            
            let image = avatarImage
            userAvatarImageView.image = image
            userAvatarImageView.applyCircle(withBorderColor: UIColor.white)
            
            let dochos = Float(user.dochos)
            let perfectPrice = Float(user.perfectPriceCpt)
            let level = user.levelMaxUnlocked!
            let levelPercentage = CGFloat(user.levelPercentage!)
            userDochosLabel.countFrom(0.0, to: dochos, withDuration: 1.0, andAnimationType: .easeInOut, andCountingType: .int)
            userPerfectLabel.countFrom(0.0, to: perfectPrice, withDuration: 1.0, andAnimationType: .easeInOut, andCountingType: .int)
            userLevelLabel.text = "Niveau \(level)"
            self.view.layoutIfNeeded()
            userLevelBar.updateLevelBar(withLevelPercent: levelPercentage)
        }
    }
    
    func refreshHome(withCompletion completion: (() -> Void)?) {
        loadUserInfos()
        loadAllData {
            self.sortedDataKeys = Array(self.data.keys)
            self.sortedDataKeys.sort(by: { (first, second) -> Bool in
                first.rawValue < second.rawValue
            })
            self.tableView.reloadData()
            completion?()
        }
    }
    
    func loadAllData(withCompletion completion: (() -> Void)?) {
        MatchManager.sharedInstance.getAllMatch(
            success: { (allMatch) in
                
                self.sortMatchArray(matchArray: allMatch)
                self.loadFriends(
                    withCompletion: {
                        if let completion = completion {
                            completion()
                        }
                    }
                )
                
            }) { (error) in
                PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorNoInternetConnection)
                
                if let completion = completion {
                    completion()
                }
        }
    }
    
    func loadFriends(withCompletion completion: (() -> Void)?) {
        if UserSessionManager.sharedInstance.isFacebookUser() {
            MatchManager.sharedInstance.getQuickPlayers(byOrder: "activity", andLimit: 10,
                success: { (friends) in
                    
                    self.data[HomeSectionName.friends] = friends
                    if let completion = completion {
                        completion()
                    }
                    
                }, fail: { (error) in
                    if let completion = completion {
                        completion()
                    }
                }
            )
            
        } else {
            completion?()
        }
    }
    
    func sortMatchArray(matchArray: [Match]){
        let keys = data.keys
        for key in keys {
            if key != .friends {
                data[key]?.removeAll()
            }
        }
        
        for match in matchArray {
            
            switch match.status {
            case .userTurn:
                if data[HomeSectionName.userTurn] == nil {
                    data[HomeSectionName.userTurn] = []
                }
                data[HomeSectionName.userTurn]!.append(match)
                break
                
            case .opponentTurn, .waiting:
                if data[HomeSectionName.opponentTurn] == nil {
                    data[HomeSectionName.opponentTurn] = []
                }
                data[HomeSectionName.opponentTurn]!.append(match)
                break
                
            case .won, .lost, .tie:
                if data[HomeSectionName.finished] == nil {
                    data[HomeSectionName.finished] = []
                }
                data[HomeSectionName.finished]!.append(match)
                break
            }
        }
    }
    
    
//MARK: Table View Controller - Data Source Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sortedDataKeys[section] == HomeSectionName.friends {
            return 1
            
        } else {
            let sectionValue = sortedDataKeys[section]
            if let array = data[sectionValue] {
                return array.count
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedDataKeys[section].description
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if sortedDataKeys[indexPath.section] == HomeSectionName.userTurn {
            
            // TON TOUR
            let cell = tableView.dequeueReusableCell(withIdentifier: idsTableViewCell[.userTurn]!, for: indexPath) as! HomeUserTurnTableViewCell
            
            let match = data[.userTurn]?[indexPath.row] as! Match
            let opponentPlayer = match.opponent
            
            cell.opponentNameLabel.text = opponentPlayer.pseudo
            cell.opponentScoreLabel.text = String(match.opponentScore ?? 0)
            cell.userScoreLabel.text = String(match.userScore ?? 0)
            cell.match = match
            cell.delegateUserTurn = self
            cell.delegate = self
            cell.indexPath = indexPath
            cell.isOnlineIndicatorImageView.isHidden = opponentPlayer.isOnline ? false : true
            
            if let level = opponentPlayer.level {
                cell.opponentLevelLabel.text = "Niveau \(level)"
                
            } else {
                cell.opponentLevelLabel.text = "Niveau ?"
            }
            
            opponentPlayer.getAvatarImage(for: .medium,
                completionHandler: { (image) in
                    cell.opponentImageView.image = image
                    cell.opponentImageView.applyCircle()
                }
            )
            
            cell.rightUtilityButtons = [buildDeleteButtonCell()]
            
            return cell
            
        } else if sortedDataKeys[indexPath.section] == HomeSectionName.opponentTurn {
            
            // SON TOUR
            let cell = tableView.dequeueReusableCell(withIdentifier: idsTableViewCell[.opponentTurn]!, for: indexPath) as! HomeOpponentTurnTableViewCell
            
            let match = data[.opponentTurn]?[indexPath.row] as! Match
            let opponentPlayer = match.opponent
            
            cell.opponentNameLabel.text = opponentPlayer.pseudo
            cell.opponentScoreLabel.text = String(match.opponentScore ?? 0)
            cell.userScoreLabel.text = String(match.userScore ?? 0)
            cell.delegate = self
            cell.isOnlineIndicatorImageView.isHidden = opponentPlayer.isOnline ? false : true
            
            if let level = opponentPlayer.level {
                cell.opponentLevelLabel.text = "Niveau \(level)"
                
            } else {
                cell.opponentLevelLabel.text = "Niveau ?"
            }
            
            opponentPlayer.getAvatarImage(for: .medium,
                completionHandler: { (image) in
                    cell.opponentImageView.image = image
                    cell.opponentImageView.applyCircle()
                }
            )
            
            if match.status == .opponentTurn && match.opponent.playerType != .defaultPlayer {
                cell.rightUtilityButtons = [buildDeleteButtonCell()]
            }
            
            return cell
            
        } else if sortedDataKeys[indexPath.section] == HomeSectionName.finished {
            
            // TERMINES
            let cell = tableView.dequeueReusableCell(withIdentifier: idsTableViewCell[.finished]!, for: indexPath) as! HomeGameFinishedTableViewCell
            
            let match = data[.finished]?[indexPath.row] as! Match
            let opponentPlayer = match.opponent
            
            cell.opponentNameLabel.text = opponentPlayer.pseudo
            cell.opponentScoreLabel.text = String(match.opponentScore!)
            cell.userScoreLabel.text = String(match.userScore!)
            cell.delegate = self
            cell.isOnlineIndicatorImageView.isHidden = opponentPlayer.isOnline ? false : true
            
            if let level = opponentPlayer.level {
                cell.opponentLevelLabel.text = "Niveau \(level)"
                
            } else {
                cell.opponentLevelLabel.text = "Niveau ?"
            }
            
            opponentPlayer.getAvatarImage(for: .medium,
                completionHandler: { (image) in
                    cell.opponentImageView.image = image
                    cell.opponentImageView.applyCircle()
                }
            )
            
            cell.matchResult = match.getMatchResult()
            cell.rightUtilityButtons = [buildDeleteButtonCell()]
            
            return cell
            
        } else {
            
            // AMIS
            let cell = tableView.dequeueReusableCell(withIdentifier: idsTableViewCell[.friends]!, for: indexPath) as! HomeFriendsTableViewCell
            cell.delegate = self
            cell.friends = data[HomeSectionName.friends] as! [Player]
            cell.collectionView.reloadData()
            
            return cell
        }
    }
    

//MARK: Table View Controller - Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == HomeSectionName.friends.rawValue {
            
            
        } else {
            let sectionType = sortedDataKeys[indexPath.section]
            let matchData = data[sectionType]?[indexPath.row] as! Match
            let matchVC = self.storyboard?.instantiateViewController(withIdentifier: "idGameplayMatchViewController") as! GameplayMatchViewController
            MatchManager.sharedInstance.currentMatch = matchData
            matchVC.match = matchData
            self.navigationController?.pushViewController(matchVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        headerView.backgroundColor = UIColor.lightGrayDochaColor()
        
        let sectionLabel = UILabel(frame: CGRect(x: 10.0, y: 5.0, width: 100.0, height: 28.0))
        sectionLabel.textColor = UIColor.darkBlueDochaColor()
        sectionLabel.text = sortedDataKeys[section].description
        sectionLabel.font = UIFont(name: "Montserrat-Semibold", size: 12)
        headerView.addSubview(sectionLabel)
        
        return headerView
    }
    
    
//MARK: SWTableViewCell - Delegate Methods
    
    func swipeableTableViewCell(_ cell: SWTableViewCell!, didTriggerRightUtilityButtonWith index: Int) {
        let indexPath = tableView.indexPath(for: cell)
        
        if let indexPath = indexPath {
            let sectionType = sortedDataKeys[indexPath.section]
            let match = data[sectionType]?[indexPath.row] as! Match
            
            MatchManager.sharedInstance.deleteMatch(ForMatchID: match.id, andRoundID: match.rounds.last?.id,
                success: {
                    
                    let sectionType = self.sortedDataKeys[indexPath.section]
                    self.data[sectionType]?.remove(at: indexPath.row)
                    
                    if self.data[sectionType]!.isEmpty {
                        self.data.removeValue(forKey: sectionType)
                    }
                    
                    self.tableView.beginUpdates()
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    self.tableView.endUpdates()
                    
                }, fail: { (error) in
                    PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorOccured)
                }
            )
        }
    }
    
    func buildDeleteButtonCell() -> UIButton! {
        let deleteButton = UIButton(type: .custom)
        deleteButton.backgroundColor = UIColor.redDochaColor()
        deleteButton.setImage(UIImage(named: "bin_icon"), for: UIControlState())
        
        return deleteButton
    }

    
//MARK: HomePlayCellDelegate Methods
    
    func newGameButtonTouched() {
        let newGameFindOpponentVC = self.storyboard?.instantiateViewController(withIdentifier: "idNewGameFindOpponentViewController") as! NewGameFindOpponentViewController
        self.navigationController?.pushViewController(newGameFindOpponentVC, animated: true)
    }
    
    
//MARK: HomeUserTurnCellDelegate Methods
    
    func playButtonTouched(withIndexPath indexPath: IndexPath) {
        let sectionType = sortedDataKeys[indexPath.section]
        let matchData = data[sectionType]?[indexPath.row] as! Match
        let matchVC = self.storyboard?.instantiateViewController(withIdentifier: "idGameplayMatchViewController") as! GameplayMatchViewController
        MatchManager.sharedInstance.currentMatch = matchData
        matchVC.match = matchData
        self.navigationController?.pushViewController(matchVC, animated: true)
    }
    
    func playButtonTouched(withMatch match: Match?) {
        if let match = match {
            let currentRound = match.rounds.last
            
            if let category = currentRound?.category {
                MatchManager.sharedInstance.loadPlayersInfos(
                    withCompletion: {
                        
                        let launcherVC = self.storyboard?.instantiateViewController(withIdentifier: "idGameplayLauncherViewController") as! GameplayLauncherViewController
                        launcherVC.categorySelected = category
                        MatchManager.sharedInstance.currentMatch = match
                        MatchManager.sharedInstance.opponentPlayer = match.opponent
                        self.navigationController?.pushViewController(launcherVC, animated: true)
                    }
                )
                
            } else {
                let newGameCategorieSelectionVC = self.storyboard?.instantiateViewController(withIdentifier: "idNewGameCategorieSelectionViewController") as! NewGameCategorieSelectionViewController
                MatchManager.sharedInstance.currentMatch = match
                self.navigationController?.pushViewController(newGameCategorieSelectionVC, animated: true)
            }
        }
    }
    
    
//MARK: HomeFriendsCellDelegate Methods
    
    func displayAllFriendsButtonTouched() {}
    
    func challengeFacebookFriendsCellTouched(withFriend friend: Player) {
        let matchManager = MatchManager.sharedInstance
        
        if matchManager.hasAlreadyMatch(with: friend) {
            let match = matchManager.getMatch(for: friend)
            
            if let match = match {
                let matchVC = self.storyboard?.instantiateViewController(withIdentifier: "idGameplayMatchViewController") as! GameplayMatchViewController
                matchVC.match = match
                self.navigationController?.pushViewController(matchVC, animated: true)
            }
            
        } else {
            matchManager.postMatch(withOpponentPseudo: friend.pseudo,
                success: { (match) in
                    
                    MatchManager.sharedInstance.loadPlayersInfos(
                        withCompletion: {
                            
                            let newGameCategorieSelectionVC = self.storyboard?.instantiateViewController(withIdentifier: "idNewGameCategorieSelectionViewController") as! NewGameCategorieSelectionViewController
                            self.navigationController?.pushViewController(newGameCategorieSelectionVC, animated: true)
                        }
                    )
                    
            }) { (error) in
                PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorOccured)
            }
        }
    }
    
//    func inviteFacebookFriendsCellTouched() {
//        PopupManager.sharedInstance.showInfosPopup("Info", message: "Encore un peu de patience, cette fonctionnalité sera prochainement disponible. 😉", completion: nil)
//        let content = FBSDKAppInviteContent()
//        content.appLinkURL = NSURL(string: "https://itunes.apple.com/fr/app/docha/id722842223?mt=8")
//        FBSDKAppInviteDialog.showFromViewController(self, withContent: content, delegate: self)
//    }
    
//    func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [AnyHashable: Any]!) {
//        PopupManager.sharedInstance.showSuccessPopup("Succès", message: "Tes amis ont bien été invités.", completion: nil)
//    }
//    
//    func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: NSError!) {
//        PopupManager.sharedInstance.showInfosPopup("Oups !", message: "Encore un peu de patience, cette foncitonnalité sera bientôt disponible !", completion: nil)
//    }
    
    
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
        // Facebook Sharing
        let content = FBSDKShareLinkContent()
        content.contentURL = URL(string: "http://www.docha.fr")
        let shareDialog = FBSDKShareDialog()
        shareDialog.fromViewController = self
        shareDialog.shareContent = content
        shareDialog.mode = .shareSheet
        shareDialog.show()
    }
    
    @IBAction func bubblePerfectsButtonTouched(_ sender: UIButton) {
        toggleBubble(false)
    }
    
    @IBAction func bubbleDochosButtonTouched(_ sender: UIButton) {
        toggleBubble(true)
    }
    
    
//MARK: FBSDKSharingDelegate
    
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable: Any]!) {
        PopupManager.sharedInstance.showSuccessPopup(message: Constants.PopupMessage.SuccessMessage.kSuccessFBSharing)
    }
    
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorFBFriendsInvite +  " " + Constants.PopupMessage.ErrorMessage.kErrorOccured)
    }
    
    func sharerDidCancel(_ sharer: FBSDKSharing!) {
        
    }
}
