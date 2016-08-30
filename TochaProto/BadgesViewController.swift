//
//  BadgesViewController.swift
//  Docha
//
//  Created by Mathis D on 24/08/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class BadgesViewController: RootViewController, UITableViewDelegate, UITableViewDataSource {
    
    let idBadgeTableViewCell = "idBadgeTableViewCell"
    let badgesTitles = ["ESPOIR", "EXPERT", "MAÎTRE", "STAR", "MASTEUR", "FLAMBEUR", "GÉNIE"]
    let badgesDescriptions = ["Trouve 5 perfects", "Trouve 25 perfects", "Trouve 100 perfects", "Trouve 500 perfects", "Trouve 3 perfects dans une seule partie", "Trouve 4 perfects dans une seule partie", "Trouve 5 perfects dans une seule partie"]
    let badgesRewards = [25, 100, 500, 3000, 500, 1000, 5000]
    let perfectsBadgesNumber = [5, 25, 100, 500]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNavigationBarWithTitle("Badges", andFontSize: 15.0)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return badgesTitles.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(idBadgeTableViewCell, forIndexPath: indexPath) as! BadgeTableViewCell
        
        let userSession = UserSessionManager.sharedInstance.currentSession()!
        let badgesUnlockedIdentifiers = userSession.badgesUnlockedIdentifiers
        let perfectUserCpt = userSession.perfectPriceCpt
        cell.titleLabel.text = badgesTitles[indexPath.row]
        cell.descriptionLabel.text = badgesDescriptions[indexPath.row]
        let badgesIdentifiers = Constants.GameCenterLeaderBoardIdentifiers.kBadgesIdentifiers
        if let badgesUnlockedIdentifiers = badgesUnlockedIdentifiers {
            if badgesUnlockedIdentifiers.contains(badgesIdentifiers[indexPath.row]) == true {
                cell.badgeImageView.image = UIImage(named: "badge_2")
                cell.progressionLabel.text = "100 %"
                
            } else {
                cell.badgeImageView.image = UIImage(named: "badge_icon_blocked")
                if indexPath.row < perfectsBadgesNumber.count {
                    var progressionPercent = Int((Double(perfectUserCpt)/Double(perfectsBadgesNumber[indexPath.row])) * 100)
                    if progressionPercent > 100 {
                        progressionPercent = 100
                    }
                    cell.progressionLabel.text = "\(progressionPercent) %"
                    
                } else {
                    cell.progressionLabel.text = "0 %"
                }
            }
        } else {
            cell.badgeImageView.image = UIImage(named: "badge_icon_blocked")
            if indexPath.row < perfectsBadgesNumber.count {
                var progressionPercent = Int((Double(perfectUserCpt)/Double(perfectsBadgesNumber[indexPath.row])) * 100)
                if progressionPercent > 100 {
                    progressionPercent = 100
                }
                cell.progressionLabel.text = "\(progressionPercent) %"
                
            } else {
                cell.progressionLabel.text = "0 %"
            }
        }
        cell.rewardDochosLabel.text = "\(badgesRewards[indexPath.row])"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        return
    }
    
    
//MARK: @IBActions
    
    @IBAction func backButtonTouched(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}