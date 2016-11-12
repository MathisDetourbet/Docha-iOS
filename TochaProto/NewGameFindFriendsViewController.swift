//
//  NewGameFindFriendsViewController.swift
//  Docha
//
//  Created by Mathis D on 19/09/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import FBSDKShareKit

class NewGameFindFriendsViewController: GameViewController, UITableViewDataSource, UITableViewDelegate, NewGameFindFriendsTableViewCellDelegate, FBSDKGameRequestDialogDelegate {
    
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
        MatchManager.sharedInstance.getQuickPlayers(byOrder: "activity", andLimit: 50,
            success: { (friends) in
                
                self.friends = friends
                self.tableView.reloadData()
                
            }, fail: { (error) in
                PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorOccured)
            }
        )
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
            
            friend.getAvatarImage(for: .medium,
                completionHandler: { (image) in
                    
                    cell.friendAvatarImageView.image = image
                    cell.friendAvatarImageView.applyCircle(withBorderColor: UIColor.lightGrayDochaColor())
                    friends[indexPath.row].avatarImage = image
                }
            )
            
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
        let matchManager = MatchManager.sharedInstance
        let player = Player.defaultPlayer()
        player.pseudo = pseudo
        
        if matchManager.hasAlreadyMatch(with: player) {
            let match = matchManager.getMatch(for: player)
            
            if let match = match {
                self.goToMatch(match, animated: false)
            }
            
        } else {
            if (UIApplication.shared.delegate as! AppDelegate).hasLowNetworkConnection() {
                PopupManager.sharedInstance.showLoadingPopup(message: Constants.PopupMessage.LoadingMessage.kLoadingJustAMoment,
                    completion: {
                        self.goToCategorieSelection(withPlayer: player)
                    }
                )
            } else {
                goToCategorieSelection(withPlayer: player)
            }
        }
    }
    
    private func goToCategorieSelection(withPlayer player: Player) {
        MatchManager.sharedInstance.postMatch(withOpponentPseudo: player.pseudo,
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
    
    
//MARK: @IBActions
    
    @IBAction func inviteFriendsButtonTouched(_ sender: UIButton) {
        let gameRequestContent = FBSDKGameRequestContent()
        gameRequestContent.message = "Viens me défier sur Docha ! Télécharge l'application sur ce lien : http://www.docha.fr"
        gameRequestContent.title = "Invite tes amis"
        
        FBSDKGameRequestDialog.show(with: gameRequestContent, delegate: self)
    }
    
    @IBAction func backButtonTouched(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
//MARK: FBSDKGameRequestDialog Delegate Methods
    
    func gameRequestDialog(_ gameRequestDialog: FBSDKGameRequestDialog!, didCompleteWithResults results: [AnyHashable : Any]!) {
        PopupManager.sharedInstance.showSuccessPopup(message: Constants.PopupMessage.SuccessMessage.kSuccessFBFriendsInvite)
    }
    
    func gameRequestDialog(_ gameRequestDialog: FBSDKGameRequestDialog!, didFailWithError error: Error!) {
        PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorFBFriendsInvite +  " " + Constants.PopupMessage.ErrorMessage.kErrorOccured)
    }
    
    func gameRequestDialogDidCancel(_ gameRequestDialog: FBSDKGameRequestDialog!) {
        
    }

}
