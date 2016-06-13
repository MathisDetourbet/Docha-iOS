//
//  HomeViewController.swift
//  Docha
//
//  Created by Mathis D on 06/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import AlamofireImage

class HomeViewController: RootViewController, UITableViewDelegate, UITableViewDataSource, HomePlayCellDelegate, HomeFriendsCellDelegate {
    
    let idsTableViewCell: [String] = ["idHomePlayTableViewCell", "idHomeFriendsTableViewCell", "idHomeBadgesTableViewCell"]
    var userSession: UserSession?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var perfectNumberLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dochosNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesBottomBarWhenPushed = true
        
        if let userSession = UserSessionManager.sharedInstance.currentSession() {
            
            if let userSessionEmail = self.userSession as? UserSessionEmail {
                if let firstName = userSessionEmail.firstName, lastName = userSessionEmail.lastName {
                    self.userNameLabel.text = "\(firstName) \(Array(arrayLiteral: lastName)[0])"
                }
                
                if let avatarString = userSessionEmail.avatar {
                    self.avatarImageView.image = UIImage(named: avatarString)
                }
            } else if let userSessionFacebook = userSession as? UserSessionFacebook {
                if let pseudo = userSessionFacebook.username {
                    self.userNameLabel.text = pseudo
                }
                
                if let fbImageURL = userSessionFacebook.facebookImageURL {
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        let downloader = ImageDownloader()
                        let URLRequest = NSURLRequest(URL: NSURL(string: fbImageURL)!)
                        downloader.downloadImage(URLRequest: URLRequest) { response in
                            if let image = response.result.value {
                                self.avatarImageView.image = image
                            }
                        }
                    }
                }
            } else {
                self.userNameLabel.text = ""
            }
            
            self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width/2
            self.avatarImageView.clipsToBounds = true
            self.avatarImageView.layer.borderWidth = 2.0
            self.avatarImageView.layer.borderColor = UIColor.whiteColor().CGColor
        }
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
            cell.levelLabel.text = self.userSession?.levelMaxUnlocked != nil ? "Niveau \(self.userSession?.levelMaxUnlocked)" : "Niveau 1"
            
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