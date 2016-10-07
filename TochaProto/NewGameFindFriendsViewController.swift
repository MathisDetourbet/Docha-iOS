//
//  NewGameFindFriendsViewController.swift
//  Docha
//
//  Created by Mathis D on 19/09/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

class NewGameFindFriendsViewController: GameViewController, UITableViewDataSource, UITableViewDelegate, NewGameFindFriendsTableViewCellDelegate {
    
    var friendsList: [AnyObject]? = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightTableViewConstraint: NSLayoutConstraint!
    
    
//MARK: Life View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let friendsList = self.friendsList {
            heightTableViewConstraint.constant = CGFloat(friendsList.count) * tableView.rowHeight
            
        } else {
            heightTableViewConstraint.constant = 0.0
        }
    }
    
    
//MARK: UITableView - Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let friendsCount = friendsList?.count {
            return friendsCount
            
        } else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "idNewGameFindFriendsCell", for: indexPath) as! NewGameFindFriendsTableViewCell
        cell.delegate = self
        
        return cell
    }
    
    
//MARK: UITableView - Delegate
    
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
        if let numberOfFriends = friendsList?.count {
            sectionLabel.text = "\(numberOfFriends) AMIS"
        } else {
            sectionLabel.text = "0 AMI"
        }
        sectionLabel.font = UIFont(name: "Montserrat-Semibold", size: 12)
        headerView.addSubview(sectionLabel)
        
        return headerView
    }
    
    
//MARK: @IBActions
    
    @IBAction func inviteFriendsButtonTouched(_ sender: UIButton) {
        
    }
    
    @IBAction func backButtonTouched(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func challengeFriendButtonTouched() {
        
    }
}
