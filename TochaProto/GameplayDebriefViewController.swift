//
//  GameplayDebriefViewController.swift
//  Docha
//
//  Created by Mathis D on 23/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import PBWebViewController
import Amplitude_iOS

class GameplayDebriefViewController: GameViewController, UITableViewDelegate, UITableViewDataSource, DebriefCellDelegate {
    
    var productsPlayed: [Product]?
    var webViewController: PBWebViewController?
    var rewards: [Reward]?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var rewardDochosLabel: UILabel!
    @IBOutlet weak var rewardPerfectLabel: UILabel!
    @IBOutlet weak var timelineView: TimelineView!
    @IBOutlet weak var perfectLabel: UILabel!
    @IBOutlet weak var dochosLabel: UILabel!
    @IBOutlet weak var levelBarView: LevelBarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Amplitude
        Amplitude.instance().logEvent("DebriefingGameFinished")
        buildUI()
        
    }
    
    func buildUI() {
        let gameManager = UserGameStateManager.sharedInstance
        gameManager.calculRewards()
        self.rewards = gameManager.getGameRewards()
        
        var totalDochosWon = 0
        var totalPerfects = 0
        for reward in self.rewards! {
            totalDochosWon += reward.dochos!
            if reward.perfect! {
                totalPerfects += 1
            }
        }
        rewardDochosLabel.text = "+ \(totalDochosWon)"
        rewardPerfectLabel.text = "+ \(totalPerfects)"
        
        let oldExprience = gameManager.getExperienceProgressionInPercent()
        self.levelBarView.initLevelBar()
        self.levelBarView.updateLevelBarWithWidth(CGFloat(oldExprience))
        
        gameManager.saveRewards()
        self.levelLabel.text = "Niveau \(gameManager.userSession.levelMaxUnlocked)"
        let newExperience = gameManager.getExperienceProgressionInPercent()
        self.levelBarView.updateLevelBarWithWidth(CGFloat(newExperience))
        
        // Save products ID Played
        ProductManager.sharedInstance.saveProductsIDPlayed()
        
        // Update rewards in the BDD
        updateRewards()
        
        // Update nav bar
        configGameNavigationBar()
    }
    
    func updateRewards() {
        let params = UserSessionManager.sharedInstance.currentSession()?.generateJSONFromUserSession()
        UserSessionManager.sharedInstance.updateUserProfil(params!, success: {
                
                print("Success categories VC")
            }) { (error, listError) in
                print("Fail categories VC")
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.productsPlayed?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("idDebriefTableViewCell") as? DebriefTableViewCell
        cell?.productNameLabel.text = self.productsPlayed![indexPath.row].model
        cell?.productImageView.image = self.productsPlayed![indexPath.row].image
        cell?.productBrandNameLabel.text = self.productsPlayed![indexPath.row].brand
        cell?.productLink = self.productsPlayed![indexPath.row].pageURL
        cell?.delegate = self
        cell?.dochosLabel.text = "\(String(self.rewards![indexPath.row].dochos!))"
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Amplitude Event
        Amplitude.instance().logEvent("DebriefingClickProductCell")
    }
    
    
//MARK: @IBActions
    
    @IBAction func goHomeButtonTouched(sender: UIButton) {
        // Amplitude Event
        Amplitude.instance().logEvent("DebriefingClickHomeButton")
        self.goToHome()
    }
    
    @IBAction func newGameButtonTouched(sender: UIButton) {
        // Amplitude Event
        Amplitude.instance().logEvent("DebriefingClickNewGameButton")
        
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
                self.presentViewController(DochaPopupHelper.sharedInstance.showErrorPopup("Oups !", message: "Il semblerait que vous ne soyez pas connecté à internet... :( Essayer à nouveau utlérieurement")!, animated: true, completion: nil)
            }
        })
    }
    
    func discoverProductActionWithURL(url: String) {
        // Amplitude Event
        Amplitude.instance().logEvent("DebriefingDiscoverPriceButton")
        
        self.webViewController = PBWebViewController()
        self.webViewController!.URL = NSURL(string: url)
        
        let activity = UIActivity()
        self.webViewController?.applicationActivities = [activity]
        self.navigationController?.pushViewController(self.webViewController!, animated: true)
    }
}