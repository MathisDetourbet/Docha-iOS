//
//  RankingViewController.swift
//  Docha
//
//  Created by Mathis D on 19/09/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class RankingViewController: GameViewController, UITableViewDataSource, UITableViewDelegate {
    
    var friendsList: [AnyObject]?
    var generalList: [AnyObject]?
    var currentList: [AnyObject]?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var userRankingLabel: UILabel!
    @IBOutlet weak var userDochosLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var heightTableViewConstraint: NSLayoutConstraint!
    
//MARK: Life View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        
        currentList = (segmentControl.selectedSegmentIndex == 0) ? friendsList : generalList
    }
    
    func buildUI() {
        configNavigationBarWithTitle("Classement")
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let currentList = self.currentList {
            heightTableViewConstraint.constant = CGFloat(currentList.count) * tableView.rowHeight
            
        } else {
            heightTableViewConstraint.constant = 0.0
        }
    }
    
    
//MARK: UITableView - Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let currentList = self.currentList {
            return currentList.count
            
        } else {
            return 0
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idRankingTableViewCell", forIndexPath: indexPath) as! RankingTableViewCell
        
        if indexPath.row == 0 {
            cell.rankImageView.image = UIImage(named: "gold.png")
            
        } else if indexPath.row == 1 {
            cell.rankImageView.image = UIImage(named: "silver.png")
            
        } else if indexPath.row == 2 {
            cell.rankImageView.image = UIImage(named: "bronze.png")
            
        } else {
            cell.rankImageView.hidden = true
        }
        
        return cell
    }
    
    
//MARK: UITableView - Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 61.0
    }
    
    
//MARK: @IBActions
    
    @IBAction func didChangeValueSegmentControl(sender: UISegmentedControl) {
        currentList = (segmentControl.selectedSegmentIndex == 0) ? friendsList : generalList
        tableView.reloadData()
    }
    
    @IBAction func doneButtonTouched(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func shareButtonTouched(sender: UIBarButtonItem) {
        
    }
}