//
//  HomeViewController.swift
//  Docha
//
//  Created by Mathis D on 06/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class HomeViewController: RootViewController, UITableViewDelegate, UITableViewDataSource, HomePlayCellDelegate, HomeFriendsCellDelegate {
    
    let idsTableViewCell: [String] = ["idHomePlayTableViewCell", "idHomeFriendsTableViewCell", "idHomeBadgesTableViewCell"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = self.tableView.dequeueReusableCellWithIdentifier(self.idsTableViewCell[indexPath.row], forIndexPath: indexPath) as! HomePlayTableViewCell
            cell.delegate = self
            
            return cell
        } else if indexPath.row == 1 {
            let cell = self.tableView.dequeueReusableCellWithIdentifier(self.idsTableViewCell[indexPath.row], forIndexPath: indexPath) as! HomeFriendsTableViewCell
            cell.delegate = self
            return cell
        } else {
            let cell = self.tableView.dequeueReusableCellWithIdentifier(self.idsTableViewCell[indexPath.row], forIndexPath: indexPath) as! HomeBadgesTableViewCell
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func playButtonTouched() {
        // Start the game !
        
    }
    
    func displayAllFriendsButtonTouched() {
        
    }
}