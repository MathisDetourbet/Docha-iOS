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
    func challengeFacebookFriendsCellTouched(withFriend friend: Player)
    func inviteFBFriendsButtonTouched()
}

class HomeFriendCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var friendAvatarImageView: UIImageView!
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var friendOnlineIndicatorImageView: UIImageView!
}

class HomeFriendsTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let friendsAvatarsImages: [String] = ["avatar_woman_medium", "avatar_man_medium", "avatar_woman_medium", "avatar_woman_medium"]
    let friendsNamesString = ["Alice J.", "Pierre A.", "Morgane J.", "Inviter"]
    let idHomeFriendsCollectionViewCell = "idHomeFriendCollectionViewCell"
    
    var friends: [Player] = []
    var delegate: HomeFriendsCellDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var inviteFBFriendsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
//MARK: Collection View Data Source Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if friends.isEmpty {
            inviteFBFriendsButton.isHidden = false
        } else {
            
            inviteFBFriendsButton.isHidden = true
        }
        
        return friends.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idHomeFriendsCollectionViewCell, for: indexPath) as! HomeFriendCollectionViewCell
        
        let friend = friends[indexPath.row]
        cell.friendNameLabel.text = friend.pseudo
        if let avatarImage = friend.avatarImage {
            cell.friendAvatarImageView.image = avatarImage
            cell.friendAvatarImageView.applyCircle(withBorderColor: UIColor.lightGrayDochaColor())
            
        } else {
            friend.getAvatarImage(for: .medium,
                completionHandler: { (image) in
                    cell.friendAvatarImageView.image = image
                    cell.friendAvatarImageView.applyCircle(withBorderColor: UIColor.lightGrayDochaColor())
                }
            )
        }
        cell.friendOnlineIndicatorImageView.isHidden = friend.isOnline ? false : true
        
        return cell
    }
    
    
//MARK: Collection View Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.challengeFacebookFriendsCellTouched(withFriend: friends[indexPath.row])
    }
    
    
//MARK: @IBActions
    
    @IBAction func inviteFBFriendsButtonTouched(_ sender: UIButton) {
        self.delegate?.inviteFBFriendsButtonTouched()
    }
    
    @IBAction func showAllFriendsButtonTouched(_ sender: UIButton) {
        self.delegate?.displayAllFriendsButtonTouched()
    }
}
