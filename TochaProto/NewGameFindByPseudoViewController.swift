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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let players = self.playersList {
            return players.count
            
        } else {
            return 0
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idNewGameFindFriendsCell", forIndexPath: indexPath) as! NewGameFindFriendsTableViewCell
        cell.delegate = self
        return cell
    }
    
    
//MARK: UITableView Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRectMake(0.0, 0.0, tableView.frame.width, 28))
        headerView.backgroundColor = UIColor.clearColor()
        let sectionLabel = UILabel(frame: CGRectMake(15.0, 5.0, 100.0, 28.0))
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
    
    @IBAction func findButtonTouched(sender: UIButton) {
        
    }
    
    @IBAction func goBackButtonTouched(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}