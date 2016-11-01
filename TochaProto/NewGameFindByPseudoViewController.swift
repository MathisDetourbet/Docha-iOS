//
//  NewGameFindByPseudoViewController.swift
//  Docha
//
//  Created by Mathis D on 23/09/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

class NewGameFindByPseudoViewController: GameViewController, UITableViewDataSource, UITableViewDelegate, NewGameFindFriendsTableViewCellDelegate, UITextFieldDelegate {
    
    var players: [Player]?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
//MARK: Life View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configNavigationBarWithTitle("Rechercher un joueur")
        tableView.tableFooterView = UIView()
    }
    
    func findPlayer() {
        MatchManager.sharedInstance.findPlayer(byPseudo: searchTextField.text!,
            success: { (players) in
                self.players = players
                self.tableView.reloadData()
                
            }) { (error) in
                PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorOccured)
        }
    }
    
    
//MARK: UITable View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let players = self.players {
            return players.count
            
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "idNewGameFindPlayerCell", for: indexPath) as! NewGameFindPlayerTableViewCell
        
        if let players = self.players {
            let player = players[indexPath.row]
            cell.friendPseudoLabel.text = player.pseudo
            player.getAvatarImage(for: .medium,
                completionHandler: { (image) in
                    cell.friendAvatarImageView.image = image
                    cell.friendAvatarImageView.applyCircle()
                }
            )
            
            cell.friendOnlineIndicatorImageView.isHidden = !player.isOnline
            cell.delegate = self
        }
        
        return cell
    }
    
    
//MARK: UITableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.width, height: 28))
        headerView.backgroundColor = self.view.backgroundColor
        let sectionLabel = UILabel(frame: CGRect(x: 15.0, y: 5.0, width: 100.0, height: 28.0))
        sectionLabel.textColor = UIColor.darkBlueDochaColor()
        if let numberOfFriends = players?.count {
            sectionLabel.text = "\(numberOfFriends) RÉSULTATS"
        } else {
            sectionLabel.text = "0 RÉSULTATS"
        }
        sectionLabel.font = UIFont(name: "Montserrat-Semibold", size: 12)
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
            matchManager.postMatch(withOpponentPseudo: player.pseudo,
                success: { (match) in
                    
                    let newGameCategorieSelectionVC = self.storyboard?.instantiateViewController(withIdentifier: "idNewGameCategorieSelectionViewController") as! NewGameCategorieSelectionViewController
                    MatchManager.sharedInstance.currentMatch = match
                    self.navigationController?.pushViewController(newGameCategorieSelectionVC, animated: true)
                    
            }) { (error) in
                PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorOccured)
            }
        }
    }
    
    
//MARK: @IBActions Methods
    
    @IBAction func findButtonTouched(_ sender: UIButton) {
        if let searchText = searchTextField.text {
            if searchText.isEmpty == false {
                findPlayer()
            }
        }
    }
    
    @IBAction func goBackButtonTouched(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
