//
//  HomeViewController.swift
//  Docha
//
//  Created by Mathis D on 06/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import AlamofireImage
import ReachabilitySwift
import SCLAlertView
import Amplitude_iOS

class HomeViewController: GameViewController, UITableViewDelegate, UITableViewDataSource, HomePlayCellDelegate, HomeFriendsCellDelegate {
    
    let idsTableViewCell: [String] = ["idHomePlayTableViewCell", "idHomeFriendsTableViewCell", "idHomeBadgesTableViewCell"]
    let userGameManager: UserGameStateManager = UserGameStateManager.sharedInstance
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    
//MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserInfos()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configGameNavigationBar()
        configTitleViewDocha()
        
        // Amplitude
        Amplitude.instance().logEvent("TabNavHome")
    }
    
    
//MARK: Load Data Methods
    
    func loadUserInfos() {
        if let userSession = UserSessionManager.sharedInstance.currentSession() {
            
            if userSession.isKindOfClass(UserSessionEmail) {
                let userSessionEmail = userSession as! UserSessionEmail
                if userSession.username == "" {
                    if let firstName = userSessionEmail.firstName, lastName = userSessionEmail.lastName {
                        self.userNameLabel.text = "\(firstName) \(Array(arrayLiteral: lastName)[0])."
                        
                    } else {
                        self.userNameLabel.text = ""
                    }
                    
                } else {
                    self.userNameLabel.text = userSession.username
                }
                
                if let profileImage = userSession.getUserProfileImage() {
                    self.avatarImageView.image = profileImage
                    
                } else if let avatarString = userSessionEmail.avatar {
                    self.avatarImageView.image = UIImage(named: avatarString)
                    
                } else {
                    self.avatarImageView.image = UIImage(named: "avatar_man_profil")
                }
                
            } else if userSession.isKindOfClass(UserSessionFacebook) {
                let userSessionFacebook = userSession as! UserSessionFacebook
                
                if let firstName = userSessionFacebook.firstName, lastName = userSessionFacebook.lastName {
                    self.userNameLabel.text = "\(firstName) \(lastName[0])."
                }
                
                if let profileImage = userSession.getUserProfileImage() {
                    avatarImageView.image = profileImage
                    
                } else {
                    if let fbImageURL = userSessionFacebook.facebookImageURL {
                        avatarImageView.downloadedFrom(link: fbImageURL, contentMode: .ScaleToFill, WithCompletion: nil)
                    }
                }
            } else {
                self.userNameLabel.text = ""
                self.avatarImageView.image = UIImage(named: "avatar_man_profil")
            }
        }
        
        avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.height/2
        avatarImageView.layer.borderWidth = 3.0
        avatarImageView.layer.borderColor = UIColor.whiteColor().CGColor
        avatarImageView.layer.masksToBounds = false
        avatarImageView.clipsToBounds = true
    }
    
    
//MARK: Table View Controller - Data Source Methods
    
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
            cell.levelLabel.text = "Niveau \(self.userGameManager.getUserLevel())"
            cell.levelBarView.initLevelBar()
            cell.levelBarView.updateLevelBarWithWidth(CGFloat(UserGameStateManager.sharedInstance.getExperienceProgressionInPercent()))
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
    
    
//MARK: Table View Controller - Delegate Methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        return
    }
    
    func playButtonTouched() {
        
        // Amplitude Event
        Amplitude.instance().logEvent("HomeGameLaunched")
        
        let loadingView = LoadingView(frame: self.view.frame, loadingType: .Gameplay)
        self.navigationController?.view.addSubview(loadingView)
        loadingView.startLoading()
        
        let productManager = ProductManager.sharedInstance
        productManager.loadProductsWithCurrentCategory()
        
        var packOfProducts = productManager.loadPackOfProducts()
        
        productManager.downloadProductsImages(packOfProducts!, WithCompletion: { (finished) in
            if finished {
                UIView.animateWithDuration(0.2, animations: {
                    loadingView.alpha = 0.0
                    
                    }, completion: { (finished) in
                        loadingView.dismissView()
                })
                loadingView.dismissView()
                
                let productsImages = productManager.productsImages
                
                for index in 0...productsImages!.count-1 {
                    packOfProducts![index].image = productsImages!["\(packOfProducts![index].id)"]
                }
                let gameplayVC = self.storyboard?.instantiateViewControllerWithIdentifier("idGameplayViewController") as! GameplayViewController
                gameplayVC.productsList = packOfProducts
                self.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(gameplayVC, animated: true)
                
            } else {
                print("Error when loading products...")
                SCLAlertView.init().showError("Oups !", subTitle: "Il semblerait que vous ne soyez pas connecté à internet... :( Essayer à nouveau utlérieurement")
            }
        })
    }
    
    func displayAllFriendsButtonTouched() {
        
    }
    
    @IBAction func profilImageTouched(sender: AnyObject) {
        // Amplitude
        Amplitude.instance().logEvent("HomeClickPhoto")
    }
    
//MARK: Push Segue Methods
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "idPushGameplaySegue" {
            self.hidesBottomBarWhenPushed = true
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "idPushGameplaySegue" {
            let reachability: Reachability
            do {
                reachability = try Reachability.reachabilityForInternetConnection()
            } catch {
                print("Unable to create Reachability")
                return false
            }
            
            reachability.whenUnreachable = { reachability in
                dispatch_async(dispatch_get_main_queue()) {
                    print("Not reachable")
                }
            }
        }
        return true
    }
}