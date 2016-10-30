//
//  NewGameFindFriendsViewController.swift
//  Docha
//
//  Created by Mathis D on 19/09/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

class NewGameFindFriendsViewController: GameViewController, UITableViewDataSource, UITableViewDelegate, NewGameFindFriendsTableViewCellDelegate {
    
    var friends: [Player]? = []
    
    @IBOutlet weak var tableView: UITableView!
    
    
//MARK: Life View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildUI()
        getFacebookFriends()
    }
    
    func buildUI() {
        if UserSessionManager.sharedInstance.currentSession()!.isKind(of: UserSessionEmail.self) {
            tableView.isHidden = true
        }
        tableView.tableFooterView = UIView()
    }
    
    func getFacebookFriends() {
        MatchManager.sharedInstance.getFacebookFriends(
            success: { (friends) in
                
                self.friends = friends
                self.tableView.reloadData()
                
            }) { (error) in
                PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorOccured)
        }
    }
    
    
//MARK: UITableView - Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let friendsCount = friends?.count {
            return friendsCount
            
        } else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "idNewGameFindFriendsCell", for: indexPath) as! NewGameFindFriendsTableViewCell
        
        if let friends = self.friends {
            let friend = friends[indexPath.row]
            cell.friendPseudoLabel.text = friend.pseudo
            
            if friend.playerType == .facebookPlayer {
                cell.friendAvatarImageView.kf.setImage(with: URL(string: friend.avatarUrl)!,
                    completionHandler: { (image, error, _, _) in
                        if image != nil {
                            cell.friendAvatarImageView.image = image!.roundCornersToCircle()
                        }
                    }
                )
            }
            if let fullName = friend.fullName {
                cell.friendNameLabel.text = fullName
            }
            cell.delegate = self
            cell.friendOnlineIndicatorImageView.isHidden = !friend.isOnline
        }
        
        return cell
    }
    
    
//MARK: UITableView - Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.width, height: 28))
        headerView.backgroundColor = UIColor.clear
        let sectionLabel = UILabel(frame: CGRect(x: 15.0, y: 5.0, width: 100.0, height: 28.0))
        sectionLabel.textColor = UIColor.darkBlueDochaColor()
        if let numberOfFriends = friends?.count {
            sectionLabel.text = "\(numberOfFriends) AMIS"
        } else {
            sectionLabel.text = "0 AMI"
        }
        sectionLabel.font = UIFont(name: "Montserrat-Semibold", size: 12)
        sectionLabel.sizeToFit()
        sectionLabel.center = CGPoint(x: headerView.frame.size.width * 0.10, y: (headerView.frame.size.height - sectionLabel.frame.size.height/2) - 5.0)
        headerView.addSubview(sectionLabel)
        
        return headerView
    }
    

//MARK: NewGameFindFriendsTableViewCell Delegate
    
    func challengeFriendButtonTouched(withPseudo pseudo: String!) {
        MatchManager.sharedInstance.postMatch(withOpponentPseudo: pseudo,
            success: { (match) in
                
                let newGameCategorieSelectionVC = self.storyboard?.instantiateViewController(withIdentifier: "idNewGameCategorieSelectionViewController") as! NewGameCategorieSelectionViewController
                MatchManager.sharedInstance.currentMatch = match
                self.navigationController?.pushViewController(newGameCategorieSelectionVC, animated: true)
                
        }) { (error) in
            PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorOccured)
        }
    }
    
    
//MARK: @IBActions
    
    @IBAction func inviteFriendsButtonTouched(_ sender: UIButton) {
        
    }
    
    @IBAction func backButtonTouched(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
