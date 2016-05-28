//
//  LevelsSelectionViewController.swift
//  DochaProto
//
//  Created by Mathis D on 29/04/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class LevelsSelectionViewController: RootViewController, UITableViewDataSource, UITableViewDelegate {
    
    let MAX_LEVEL = 8
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//# MARK: UITableViewDataSource methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MAX_LEVEL
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
   
//# MARK: UITableviewDelegate methods
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idLevelsTableViewCell", forIndexPath: indexPath)
        
        if let levelCell = cell as? LevelsTableViewCell {
            levelCell.titleLevelLabel.text = String("Level \(indexPath.row + 1)")
            levelCell.priceLevelLabel.text = String(indexPath.row*100)
            
            let levelMax: Int
            let userState = UserSessionManager.sharedInstance.currentSession()
            levelMax = userState.levelMaxUnlocked
            
            if  indexPath.row+1 <= levelMax {
                levelCell.canvasImageView.hidden = true
                levelCell.coinsImageView.hidden = true
                levelCell.priceLevelLabel.hidden = true
                return levelCell
            }
            
            cell.userInteractionEnabled = false
            return levelCell
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // load products
        ProductManager.sharedInstance.loadPacksOfProducts()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gameplayViewController = storyboard.instantiateViewControllerWithIdentifier("idGameplayViewController") as! GameplayViewController
        self.navigationController?.pushViewController(gameplayViewController, animated: true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
