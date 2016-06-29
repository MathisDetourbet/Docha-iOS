//
//  GameplayDebriefViewController.swift
//  Docha
//
//  Created by Mathis D on 23/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import PBWebViewController

class GameplayDebriefViewController: GameViewController, UITableViewDelegate, UITableViewDataSource, DebriefCellDelegate {
    
    var productsPlayed: [Product]?
    var webViewController: PBWebViewController?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var rewardDochosLabel: UILabel!
    @IBOutlet weak var rewardPerfectLabel: UILabel!
    @IBOutlet weak var timelineView: TimelineView!
    @IBOutlet weak var perfectLabel: UILabel!
    @IBOutlet weak var dochosLabel: UILabel!
    
    @IBOutlet weak var widthLevelBarConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gameManager = UserGameStateManager.sharedInstance
        gameManager.calculRewards()
        let rewardsWon = gameManager.getRewards()
        rewardDochosLabel.text = "+ \(rewardsWon.dochos!)"
        rewardPerfectLabel.text = "+ \(rewardsWon.perfects!)"
        
        let oldExprience = gameManager.getExperienceProgressionInPercent()
        widthLevelBarConstraint.constant = CGFloat(oldExprience)
        
        gameManager.saveRewards()
        let newExperience = gameManager.getExperienceProgressionInPercent()
        UIView.animateWithDuration(1.0, delay: 1.0, options: .LayoutSubviews, animations: {
            self.widthLevelBarConstraint.constant = CGFloat(newExperience)
        }, completion: nil)
        
        // Update nav bar
        configGameNavigationBar()
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
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        return
    }
    
    
    //MARK: @IBActions
    
    @IBAction func goHomeButtonTouched(sender: UIButton) {
        self.goToHome()
    }
    
    @IBAction func newGameButtonTouched(sender: UIButton) {
        
    }
    
    func discoverProductActionWithURL(url: String) {
        self.webViewController = PBWebViewController()
        self.webViewController!.URL = NSURL(string: url)
        
        let activity = UIActivity()
        self.webViewController?.applicationActivities = [activity]
        self.navigationController?.pushViewController(self.webViewController!, animated: true)
    }
}