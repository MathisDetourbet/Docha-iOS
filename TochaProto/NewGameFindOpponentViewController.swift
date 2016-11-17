//
//  NewGameFindOpponentViewController.swift
//  Docha
//
//  Created by Mathis D on 01/09/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import FBSDKShareKit

class NewGameFindOpponentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
}

class NewGameFriendsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var friendImageView: UIImageView!
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var friendOnlineIndicatorImageView: UIImageView!
}

class NewGameFindOpponentViewController: GameViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, FBSDKGameRequestDialogDelegate {
    
    let titlesArray = ["Amis Facebook", "Aléatoire", "Rechercher un joueur"]
    let subTitlesArray = ["Défie un de tes amis", "Défie une personne au hasard", "Défie une personne grâce à son email ou son pseudo"]
    let imagesViewsArray = ["facebook_icon", "random_icon", "search_icon"]
    let tableViewRowHeight: CGFloat = 70.0
    var quickPlayers: [Player] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inviteFBFriendsButton: UIButton!
    
    
//MARK: Life View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildUI()
        loadQuickPlayers(withCompletion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func buildUI() {
        configNavigationBarWithTitle("Trouve un adversaire")
        self.tableView.tableFooterView = UIView()
        self.view.backgroundColor = UIColor.lightGrayDochaColor()
        collectionView.backgroundColor = UIColor.lightGrayDochaColor()
        
        tableView.backgroundColor = UIColor.lightGrayDochaColor()
    }
    
    func loadQuickPlayers(withCompletion completion: (() -> Void)?) {
        MatchManager.sharedInstance.getQuickPlayers(byOrder: "activity", andLimit: 5,
            success: { (players) in
                self.quickPlayers = players
                self.collectionView.reloadData()
                
            }) { (error) in
        }
    }

    
//MARK: UICollectionView - Data Source Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if quickPlayers.isEmpty {
            inviteFBFriendsButton.isHidden = false
            
        } else {
            inviteFBFriendsButton.isHidden = true
        }
        
        return quickPlayers.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "idNewGameFriendsCollectionViewCell", for: indexPath) as! NewGameFriendsCollectionViewCell
        
        let player = quickPlayers[indexPath.item]
        cell.friendNameLabel.text = player.pseudo
        player.getAvatarImage(for: .large,
            completionHandler: { (image) in
                cell.friendImageView.image = image
                cell.friendImageView.applyCircle(withBorderColor: UIColor.white)
            }
        )
        cell.friendOnlineIndicatorImageView.isHidden = !player.isOnline
        
        return cell
    }
    
    
//MARK: UICollectionView - Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let player = quickPlayers[indexPath.row]
        
        let matchManager = MatchManager.sharedInstance
        
        if matchManager.hasAlreadyMatch(with: player) {
            let match = matchManager.getMatch(for: player)
            
            if let match = match {
                self.goToMatch(match, animated: false)
            }
            
        } else {
            PopupManager.sharedInstance.showLoadingPopup(message: Constants.PopupMessage.LoadingMessage.kLoadingMatchCreation) {
                matchManager.postMatch(withOpponentPseudo: player.pseudo,
                    success: { (match) in
                        
                        PopupManager.sharedInstance.dismissPopup(true) {
                            MatchManager.sharedInstance.loadPlayersInfos(
                                withCompletion: {
                                    
                                    let newGameCategorieSelectionVC = self.storyboard?.instantiateViewController(withIdentifier: "idNewGameCategorieSelectionViewController") as! NewGameCategorieSelectionViewController
                                    self.navigationController?.pushViewController(newGameCategorieSelectionVC, animated: true)
                            }
                            )
                        }
                        
                }) { (error) in
                    PopupManager.sharedInstance.dismissPopup(true) {
                        PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorOccured)
                    }
                }
            }
        }
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    

//MARK: UITableView - Data Source Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idNewGameFindOpponentTableViewCell", for: indexPath) as! NewGameFindOpponentTableViewCell
        cell.titleLabel.text = titlesArray[(indexPath as NSIndexPath).row]
        cell.subTitleLabel.text = subTitlesArray[(indexPath as NSIndexPath).row]
        cell.cellImageView.image = UIImage(named: imagesViewsArray[(indexPath as NSIndexPath).row])
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    
//MARK: UITableView - Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).row == 0 {
            let newGameFacebookFriendsVC = self.storyboard?.instantiateViewController(withIdentifier: "idNewGameFindFriendsViewController") as! NewGameFindFriendsViewController
            self.navigationController?.pushViewController(newGameFacebookFriendsVC, animated: true)
            
        } else if (indexPath as NSIndexPath).row == 1 {
            PopupManager.sharedInstance.showLoadingPopup(message: Constants.PopupMessage.LoadingMessage.kLoadingMatchCreation) {
                MatchManager.sharedInstance.postMatch(
                    success: { (match) in
                        
                        PopupManager.sharedInstance.dismissPopup(true) {
                            MatchManager.sharedInstance.loadPlayersInfos {
                                
                                if let _ = match.rounds.last?.category {
                                    let launcherVC = self.storyboard?.instantiateViewController(withIdentifier: "idGameplayLauncherViewController") as! GameplayLauncherViewController
                                    self.navigationController?.pushViewController(launcherVC, animated: true)
                                    
                                } else {
                                    let newGameCategorieSelectionVC = self.storyboard?.instantiateViewController(withIdentifier: "idNewGameCategorieSelectionViewController") as! NewGameCategorieSelectionViewController
                                    self.navigationController?.pushViewController(newGameCategorieSelectionVC, animated: true)
                                }
                            }
                        }
                        
                }) { (error) in
                    PopupManager.sharedInstance.dismissPopup(true) {
                        PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorOccured)
                    }
                }
            }
            
        } else if (indexPath as NSIndexPath).row == 2 {
            let newGameFindByPseudoVC = self.storyboard?.instantiateViewController(withIdentifier: "idNewGameFindByPseudoViewController") as! NewGameFindByPseudoViewController
            self.navigationController?.pushViewController(newGameFindByPseudoVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewRowHeight
    }
    
    
//MARK: @IBAction Methods
    
    @IBAction func inviteFBFriendsButtonTouched(_ sender: UIButton) {
        let gameRequestContent = FBSDKGameRequestContent()
        gameRequestContent.message = "Viens me défier sur Docha ! Télécharge l'application sur ce lien : http://www.docha.fr"
        gameRequestContent.title = "Invite tes amis"
        
        FBSDKGameRequestDialog.show(with: gameRequestContent, delegate: self)
    }
    
    
    @IBAction func backTouched(_ sender: UIBarButtonItem) {
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
