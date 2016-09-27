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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let currentList = self.currentList {
            return currentList.count
            
        } else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idRankingTableViewCell", for: indexPath) as! RankingTableViewCell
        
        if (indexPath as NSIndexPath).row == 0 {
            cell.rankImageView.image = UIImage(named: "gold.png")
            
        } else if (indexPath as NSIndexPath).row == 1 {
            cell.rankImageView.image = UIImage(named: "silver.png")
            
        } else if (indexPath as NSIndexPath).row == 2 {
            cell.rankImageView.image = UIImage(named: "bronze.png")
            
        } else {
            cell.rankImageView.isHidden = true
        }
        
        return cell
    }
    
    
//MARK: UITableView - Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61.0
    }
    
    
//MARK: @IBActions
    
    @IBAction func didChangeValueSegmentControl(_ sender: UISegmentedControl) {
        currentList = (segmentControl.selectedSegmentIndex == 0) ? friendsList : generalList
        tableView.reloadData()
    }
    
    @IBAction func doneButtonTouched(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareButtonTouched(_ sender: UIBarButtonItem) {
        
    }
}
