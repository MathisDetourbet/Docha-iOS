//
//  HomeFriendsTableViewCell.swift
//  Docha
//
//  Created by Mathis D on 06/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

protocol HomeFriendsCellDelegate {
    func displayAllFriendsButtonTouched()
    func inviteFacebookFriendsCellTouched()
}

class HomeFriendCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var friendAvatarImageView: UIImageView!
    @IBOutlet weak var friendNameLabel: UILabel!
}

class HomeFriendsTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let friendsAvatarsImages: [String] = ["avatar_woman_indian", "avatar_man_geek", "avatar_woman_blond", "facebook_icon_circle"]
    let friendsNamesString = ["Alice J.", "Marine A.", "Morgane J.", "Inviter"]
    let idHomeFriendsCollectionViewCell = "idHomeFriendCollectionViewCell"
    
    var friendsCollection: [AnyObject]? = ["", "", "", ""]
    var delegate: HomeFriendsCellDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    //MARK: Collection View Data Source Methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.friendsCollection!.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier(idHomeFriendsCollectionViewCell, forIndexPath: indexPath) as! HomeFriendCollectionViewCell
        cell.friendAvatarImageView.image = UIImage(named: self.friendsAvatarsImages[indexPath.item])
        cell.friendNameLabel.text = self.friendsNamesString[indexPath.item]
        
        return cell
    }
    
    
    //MARK: Collection View Delegate Methods
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.item == ((self.friendsCollection?.count)!-1) {
            self.delegate?.inviteFacebookFriendsCellTouched()
        }
    }
    
    
    //MARK: @IBActions
    
    @IBAction func showAllFriendsButtonTouched(sender: UIButton) {
        self.delegate?.displayAllFriendsButtonTouched()
    }
}