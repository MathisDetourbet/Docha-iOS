//
//  GameplayMatchViewController.swift
//  Docha
//
//  Created by Mathis D on 16/09/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import PullToRefresh

enum RoundTypeCell {
    case beginningOrFinishedCell
    case yourTurnCell
    case waitingCell
}

class GameplayMatchViewController: GameViewController, UITableViewDelegate, UITableViewDataSource, RoundYourTurnCellDelegate {
    
    var match: Match?
    var currentRound: Round?
    var sortedRounds: [(roundType: RoundTypeCell, roundData: Round)] = []
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var withdrawButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildUI()
        
        let refresher = PullToRefresh()
        tableView.addPullToRefresh(refresher) {
            if let match = self.match {
                self.loadMatch(withMatchID: match.id,
                    andCompletion: {
                        self.sortRounds()
                        self.tableView.endRefreshing(at: Position.top)
                    }
                )
            }
        }
    }
    
    deinit {
        tableView.removePullToRefresh(tableView.topPullToRefresh!)
    }
    
    func buildUI() {
        self.navigationController?.isNavigationBarHidden = false
        configNavigationBarWithTitle("Match")
        tableView.tableFooterView = UIView()
        
        sortRounds()
        
        if let match = match {
            
            if match.rounds.isEmpty == false {
                
                if let currentRound = match.getCurrentRound() {
                    
                    if (currentRound.userScore == nil) && (match.status == .userTurn) {
                        playButton.isEnabled = true
                        
                    } else {
                        playButton.isEnabled = false
                    }
                    
                    if match.status == .waiting {
                        withdrawButton.isEnabled = false
                    }
                    
                } else {
                    if match.status == .userTurn {
                        playButton.isEnabled = true
                        
                    } else {
                        playButton.isEnabled = false
                    }
                }
            }
        }
    }
    
    func sortRounds() {
        sortedRounds = []
        
        if let match = self.match {
            var index = 0
            for round in match.rounds {
                
                if (round.userScore == nil && round.opponentScore == nil)
                    || (round.userScore != nil && round.opponentScore != nil) {
                    sortedRounds.append((.beginningOrFinishedCell, round))
                    
                } else if (round.userScore == nil) && (round.opponentScore != nil) {
                    sortedRounds.append((.yourTurnCell, round))
                    
                } else if (round.userScore != nil) && (round.opponentScore == nil) {
                    sortedRounds.append((.waitingCell, round))
                }
                
                index += 1
            }
            
            if index < match.maxRounds {
                for _ in index..<match.maxRounds {
                    sortedRounds.append((.beginningOrFinishedCell, Round.getEmptyRound()))
                }
            }
        }
        
        tableView.reloadData()
    }
    
    func loadMatch(withMatchID matchID: Int, andCompletion completion: (() -> Void)?) {
        MatchManager.sharedInstance.getMatch(withMatchID: matchID,
            success: { (match) in
                self.match = match
                completion?()
            
            }) { (error) in
                PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorOccured, doneActionCompletion: {
                        completion?()
                    }
                )
        }
    }
    
    
//MARK: UITableView - Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedRounds.count + 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
            
        } else {
            return "ROUND \(section)"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 136.0
            
        } else {
            return 71.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "idGameplayMatchScoreCell", for: indexPath) as! GameplayMatchScoreTableViewCell
            
            let userData = UserSessionManager.sharedInstance.getUserInfosAndAvatarImage(withImageSize: .large)
            
            if let user = userData.user, let userAvatarImage = userData.avatarImage {
                cell.userNameLabel.text = user.pseudo
                cell.userNameLabel.textColor = UIColor.darkBlueDochaColor()
                cell.userAvatarImageView.image = userAvatarImage
                cell.userAvatarImageView.applyCircle(withBorderColor: UIColor.white)
            }
            
            if let match = match {
                let opponentPlayer = match.opponent
                cell.opponentNameLabel.text = opponentPlayer.pseudo
                cell.opponentNameLabel.textColor = UIColor.darkBlueDochaColor()
                opponentPlayer.getAvatarImage(for: .large,
                    completionHandler: { (image) in
                        cell.opponentAvatarImageView.image = image
                        cell.opponentAvatarImageView.applyCircle(withBorderColor: UIColor.white)
                    }
                )
                                
                cell.scoreLabel.text = "\(match.userScore ?? 0) : \(match.opponentScore ?? 0)"
            }
            
            return cell
            
        } else {
            let round = sortedRounds[indexPath.section-1]
            
            switch round.roundType {
                
            case .beginningOrFinishedCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: "idGameplayMatchRoundFinishedCell", for: indexPath) as! GameplayMatchRoundFinishedCell
                if (round.roundData.userScore != nil) && (round.roundData.opponentScore != nil) && (round.roundData.category != nil) {
                    cell.updateTimeline(withUserScore: round.roundData.userScore, andOpponentScore: round.roundData.opponentScore)
                }
                
                return cell
                
            case .yourTurnCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: "idGameplayMatchRoundYourTurnCell", for: indexPath) as! GameplayMatchRoundYourTurnCell
                cell.delegate = self
                
                return cell
                
            case .waitingCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: "idGameplayMatchRoundWaitingCell", for: indexPath) as! GameplayMatchRoundWaitingCell
                if round.roundData.userScore != nil {
                    cell.updateTimeline(withUserScore: round.roundData.userScore)
                }
                
                return cell
            }
        }
    }
    
    
//MARK: UITableView - Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0
        }
        
        return 35.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 5))
            headerView.backgroundColor = UIColor.clear
            return headerView
            
        } else {
            let headerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.width, height: 35.0))
            headerView.backgroundColor = UIColor.clear
            
            let sectionLabel = UILabel(frame: CGRect(x: 0.0, y: 5.0, width: 70.0, height: headerView.frame.size.height))
            sectionLabel.textColor = UIColor.darkBlueDochaColor()
            sectionLabel.font = UIFont(name: "Montserrat-ExtraBold", size: 12.0)
            sectionLabel.text = "ROUND \(section)"
            sectionLabel.sizeToFit()
            sectionLabel.center = CGPoint(x: tableView.center.x, y: headerView.frame.size.height - sectionLabel.frame.size.height/2 - 5.0)
            headerView.addSubview(sectionLabel)
            
            return headerView
        }
    }
    
    
//MARK: Cells Delegate
    
    func yourTurnButtonTouched() {
        MatchManager.sharedInstance.loadPlayersInfos {
            
            if let category = self.currentRound?.category {
                let launcherVC = self.storyboard?.instantiateViewController(withIdentifier: "idGameplayLauncherViewController") as! GameplayLauncherViewController
                launcherVC.categorySelected = category
                self.navigationController?.pushViewController(launcherVC, animated: true)
                
            } else {
                let newGameCategorieSelectionVC = self.storyboard?.instantiateViewController(withIdentifier: "idNewGameCategorieSelectionViewController") as! NewGameCategorieSelectionViewController
                MatchManager.sharedInstance.currentMatch = self.match
                self.navigationController?.pushViewController(newGameCategorieSelectionVC, animated: true)
            }
        }
    }
    
    
//MARK: @IBActions
    
    @IBAction func playButtonTouched(_ sender: UIButton) {
        if (currentRound?.category == nil) && (match?.status == .userTurn) {
            let newGameCategorieSelectionVC = self.storyboard?.instantiateViewController(withIdentifier: "idNewGameCategorieSelectionViewController") as! NewGameCategorieSelectionViewController
            MatchManager.sharedInstance.currentMatch = match
            self.navigationController?.pushViewController(newGameCategorieSelectionVC, animated: true)
            
        } else {
            let categorySelected = currentRound?.category
            let launcherVC = self.storyboard?.instantiateViewController(withIdentifier: "idGameplayLauncherViewController") as! GameplayLauncherViewController
            launcherVC.categorySelected = categorySelected
            self.navigationController?.pushViewController(launcherVC, animated: true)
        }
    }
    
    @IBAction func withdrawButtonTouched(_ sender: UIButton) {
        
    }
    
    @IBAction func backButtonTouched(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
