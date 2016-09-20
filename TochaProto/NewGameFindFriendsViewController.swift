//
//  NewGameFindFriendsViewController.swift
//  Docha
//
//  Created by Mathis D on 19/09/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class NewGameFindFriendsViewController: GameViewController, UITableViewDataSource, UITableViewDelegate, NewGameFindFriendsTableViewCellDelegate {
    
    var friendsList: [AnyObject]? = []
    
    @IBOutlet weak var tableView: UITableView!
    
    
//MARK: Life View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
//MARK: UITableView - Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let friendsCount = friendsList?.count {
            return friendsCount
            
        } else {
            return 0
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("idNewGameFindFriendsCell", forIndexPath: indexPath) as! NewGameFindFriendsTableViewCell
        cell.delegate = self
        
        return cell
    }
    
    
//MARK: UITableView - Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRectMake(0.0, 0.0, tableView.frame.width, 28))
        headerView.backgroundColor = UIColor.clearColor()
        let sectionLabel = UILabel(frame: CGRectMake(5.0, 5.0, 100.0, 28.0))
        sectionLabel.textColor = UIColor.darkBlueDochaColor()
        if let numberOfFriends = self.friendsList?.count {
            sectionLabel.text = "\(numberOfFriends) AMIS"
        } else {
            sectionLabel.text = "0 AMI"
        }
        sectionLabel.font = UIFont(name: "Montserrat-Semibold", size: 12)
        headerView.addSubview(sectionLabel)
        
        return headerView
    }
    
    
//MARK: @IBActions
    
    @IBAction func inviteFriendsButtonTouched(sender: UIButton) {
        
    }
    
    @IBAction func backButtonTouched(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func challengeFriendButtonTouched() {
        
    }
}