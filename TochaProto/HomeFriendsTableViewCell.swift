//
//  HomeFriendsTableViewCell.swift
//  Docha
//
//  Created by Mathis D on 06/06/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
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
    
    let friendsAvatarsImages: [String] = ["avatar_woman_medium", "avatar_man_medium", "avatar_woman_medium", "avatar_woman_medium"]
    let friendsNamesString = ["Alice J.", "Pierre A.", "Morgane J.", "Inviter"]
    let idHomeFriendsCollectionViewCell = "idHomeFriendCollectionViewCell"
    
    var friendsCollection: [AnyObject]? = ["" as AnyObject, "" as AnyObject, "" as AnyObject, "" as AnyObject]
    var delegate: HomeFriendsCellDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
//MARK: Collection View Data Source Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.friendsCollection!.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: idHomeFriendsCollectionViewCell, for: indexPath) as! HomeFriendCollectionViewCell
        cell.friendAvatarImageView.image = UIImage(named: self.friendsAvatarsImages[(indexPath as NSIndexPath).item])
        cell.friendNameLabel.text = self.friendsNamesString[(indexPath as NSIndexPath).item]
        
        return cell
    }
    
    
//MARK: Collection View Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).item == ((self.friendsCollection?.count)!-1) {
            self.delegate?.inviteFacebookFriendsCellTouched()
        }
    }
    
    
//MARK: @IBActions
    
    @IBAction func showAllFriendsButtonTouched(_ sender: UIButton) {
        self.delegate?.displayAllFriendsButtonTouched()
    }
}
