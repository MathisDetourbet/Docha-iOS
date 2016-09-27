//
//  BadgesViewController.swift
//  Docha
//
//  Created by Mathis D on 24/08/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
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
        self.configNavigationBarWithTitle("Badges")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return badgesTitles.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: idBadgeTableViewCell, for: indexPath) as! BadgeTableViewCell
        
        let userSession = UserSessionManager.sharedInstance.currentSession()!
        let badgesUnlockedIdentifiers = userSession.badgesUnlockedIdentifiers
        let perfectUserCpt = userSession.perfectPriceCpt
        cell.titleLabel.text = badgesTitles[(indexPath as NSIndexPath).row]
        cell.descriptionLabel.text = badgesDescriptions[(indexPath as NSIndexPath).row]
        let badgesIdentifiers = Constants.GameCenterLeaderBoardIdentifiers.kBadgesIdentifiers
        if let badgesUnlockedIdentifiers = badgesUnlockedIdentifiers {
            if badgesUnlockedIdentifiers.contains(badgesIdentifiers[(indexPath as NSIndexPath).row]) == true {
                cell.badgeImageView.image = UIImage(named: "badge_2")
                cell.progressionLabel.text = "100 %"
                
            } else {
                cell.badgeImageView.image = UIImage(named: "badge_icon_blocked")
                if (indexPath as NSIndexPath).row < perfectsBadgesNumber.count {
                    var progressionPercent = Int((Double(perfectUserCpt)/Double(perfectsBadgesNumber[(indexPath as NSIndexPath).row])) * 100)
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
            if (indexPath as NSIndexPath).row < perfectsBadgesNumber.count {
                var progressionPercent = Int((Double(perfectUserCpt)/Double(perfectsBadgesNumber[(indexPath as NSIndexPath).row])) * 100)
                if progressionPercent > 100 {
                    progressionPercent = 100
                }
                cell.progressionLabel.text = "\(progressionPercent) %"
                
            } else {
                cell.progressionLabel.text = "0 %"
            }
        }
        cell.rewardDochosLabel.text = "\(badgesRewards[(indexPath as NSIndexPath).row])"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
    
    
//MARK: @IBActions
    
    @IBAction func backButtonTouched(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
