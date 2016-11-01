//
//  RankingViewController.swift
//  Docha
//
//  Created by Mathis D on 19/09/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import Kingfisher
import PullToRefresh

class RankingViewController: GameViewController, UITableViewDataSource, UITableViewDelegate {
    
    var friendsList: [Player] = []
    var generalList: [Player] = []
    var currentList: [Player] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var userRankingLabel: UILabel!
    @IBOutlet weak var userPerfectsLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
//MARK: Life View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        loadUserInfos()
        
        currentList = (segmentControl.selectedSegmentIndex == 0) ? friendsList : generalList
        (segmentControl.selectedSegmentIndex == 0) ? loadFriendsRankingData(withCompletion: nil) : loadGeneralRankingData(withCompletion: nil)
    }
    
    deinit {
        tableView.removePullToRefresh(tableView.topPullToRefresh!)
    }
    
    func buildUI() {
        configNavigationBarWithTitle("Classements")
        self.view.backgroundColor = UIColor.lightGrayDochaColor()
        tableView.tableFooterView = UIView()
        
        let font = UIFont.systemFont(ofSize: 15.0)
        segmentControl.setTitleTextAttributes([NSFontAttributeName: font], for: .normal)
        
        let refresher = PullToRefresh()
        tableView.addPullToRefresh(refresher) {
            if self.segmentControl.selectedSegmentIndex == 0 {
                self.friendsList = []
                self.loadFriendsRankingData(
                    withCompletion: {
                        self.tableView.endRefreshing(at: Position.top)
                    }
                )
                
            } else {
                self.generalList = []
                self.loadGeneralRankingData(
                    withCompletion: {
                        self.tableView.endRefreshing(at: Position.top)
                    }
                )
            }
        }
    }
    
    func loadUserInfos() {
        let user = UserSessionManager.sharedInstance.currentSession()
        
        if let user = user {
            userRankingLabel.text = String(user.rank)
            userPerfectsLabel.text = String(user.perfectPriceCpt)
        }
    }
    
    func loadFriendsRankingData(withCompletion completion: (() -> Void)?) {
        if friendsList.isEmpty {
            MatchManager.sharedInstance.getFacebookFriends(
                success: { (friends) in
                    
                    self.friendsList = friends
                    self.currentList = self.friendsList
                    self.tableView.reloadData()
                    completion?()
                    
            }) { (error) in
                PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorOccured, viewController: self, doneActionCompletion: {
                    completion?()
                    }
                )
            }
            
        } else {
            currentList = friendsList
            completion?()
        }
    }
    
    func loadGeneralRankingData(withCompletion completion: (() -> Void)?) {
        if generalList.isEmpty {
            MatchManager.sharedInstance.getGeneralRanking(
                success: { (players) in
                    
                    self.generalList = players
                    self.currentList = self.generalList
                    self.tableView.reloadData()
                    completion?()
                    
            }) { (error) in
                PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorOccured, viewController: self, doneActionCompletion: {
                        completion?()
                    }
                )
            }
        } else {
            currentList = generalList
            completion?()
        }
    }
    
    
//MARK: UITableView - Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idRankingTableViewCell", for: indexPath) as! RankingTableViewCell
        
        let player = currentList[indexPath.row]
        cell.userNameLabel.text = player.pseudo
        cell.rankLabel.text = "#" + String(indexPath.row+1)
        cell.userDochosLabel.text = String(player.perfects)
        
        player.getAvatarImage(for: .medium,
            completionHandler: { (image) in
                cell.userImageView.image = image
                cell.userImageView.applyCircle()
            }
        )
        
        if (indexPath as NSIndexPath).row == 0 {
            cell.rankImageView.isHidden = false
            cell.rankImageView.image = UIImage(named: "gold.png")
            
        } else if (indexPath as NSIndexPath).row == 1 {
            cell.rankImageView.isHidden = false
            cell.rankImageView.image = UIImage(named: "silver.png")
            
        } else if (indexPath as NSIndexPath).row == 2 {
            cell.rankImageView.isHidden = false
            cell.rankImageView.image = UIImage(named: "bronze.png")
            
        } else {
            cell.rankImageView.isHidden = true
        }
        
        return cell
    }
    
    
//MARK: UITableView - Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61.0
    }
    
    
//MARK: @IBActions
    
    @IBAction func didChangeValueSegmentControl(_ sender: UISegmentedControl) {
        (segmentControl.selectedSegmentIndex == 0) ? loadFriendsRankingData(withCompletion: nil) : loadGeneralRankingData(withCompletion: nil)
        tableView.reloadData()
    }
    
    @IBAction func doneButtonTouched(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareButtonTouched(_ sender: UIBarButtonItem) {
        
    }
}
