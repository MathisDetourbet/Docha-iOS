//
//  NewGameFindByPseudoViewController.swift
//  Docha
//
//  Created by Mathis D on 23/09/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class NewGameFindByPseudoViewController: GameViewController, UITableViewDataSource, UITableViewDelegate, NewGameFindFriendsTableViewCellDelegate, UITextFieldDelegate {
    
    var playersList: [AnyObject]?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightTableViewConstraint: NSLayoutConstraint!
    
//MARK: Life View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configNavigationBarWithTitle("Rechercher un joueur")
        
        if let playersList = self.playersList {
            heightTableViewConstraint.constant = CGFloat(playersList.count) * tableView.rowHeight
            
        } else {
            heightTableViewConstraint.constant = 0.0
        }
    }
    
    
//MARK: UITable View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let players = self.playersList {
            return players.count
            
        } else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idNewGameFindFriendsCell", for: indexPath) as! NewGameFindFriendsTableViewCell
        cell.delegate = self
        return cell
    }
    
    
//MARK: UITableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.width, height: 28))
        headerView.backgroundColor = UIColor.clear
        let sectionLabel = UILabel(frame: CGRect(x: 15.0, y: 5.0, width: 100.0, height: 28.0))
        sectionLabel.textColor = UIColor.darkBlueDochaColor()
        if let numberOfFriends = playersList?.count {
            sectionLabel.text = "\(numberOfFriends) RÉSULTATS"
        } else {
            sectionLabel.text = "0 RÉSULTATS"
        }
        sectionLabel.font = UIFont(name: "Montserrat-Semibold", size: 12)
        headerView.addSubview(sectionLabel)
        
        return headerView
    }
    
    
//MARK: NewGameFindFriendsTableViewCell Delegate
    
    func challengeFriendButtonTouched() {
        
    }
    
    
//MARK: @IBActions Methods
    
    @IBAction func findButtonTouched(_ sender: UIButton) {
        
    }
    
    @IBAction func goBackButtonTouched(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}
