//
//  HomeBadgesTableViewCell.swift
//  Docha
//
//  Created by Mathis D on 06/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

protocol HomeBadgeDelegate {
    func showAllBadges()
}

class HomeBadgeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var badgeTitleLabel: UILabel!
}

class HomeBadgesTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let badgesTitles = ["ESPOIR", "EXPERT", "MAÎTRE", "STAR", "MASTEUR", "FLAMBEUR", "GÉNIE"]
    var delegate: HomeBadgeDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return badgesTitles.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("idHomeBadgeCollectionViewCell", forIndexPath: indexPath) as! HomeBadgeCollectionViewCell
        
        let userSession = UserSessionManager.sharedInstance.currentSession()!
        let badgesUnlockedIdentifiers = userSession.badgesUnlockedIdentifiers
        let allBadgeIdentifiers = Constants.GameCenterLeaderBoardIdentifiers.kBadgesIdentifiers
        cell.badgeTitleLabel.text = badgesTitles[indexPath.item]
        if let badgesUnlockedIdentifiers = badgesUnlockedIdentifiers {
            if badgesUnlockedIdentifiers.contains(allBadgeIdentifiers[indexPath.row]) == true {
                cell.badgeImageView.image = UIImage(named: "badge_2")
            } else {
                cell.badgeImageView.image = UIImage(named: "badge_icon_blocked")
            }
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.showAllBadges()
    }
    
    @IBAction func showAllBadges(sender: UIButton) {
        self.delegate?.showAllBadges()
    }
}