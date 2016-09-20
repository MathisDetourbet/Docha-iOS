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
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var userRankingLabel: UILabel!
    @IBOutlet weak var userDochosLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
//MARK: Life View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
    }
    
    func buildUI() {
        configNavigationBarWithTitle("Classement")
    }
    
    
//MARK: UITableView - Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("idRankingTableViewCell", forIndexPath: indexPath) as! RankingTableViewCell
        
        
        return cell
    }
    
    
//MARK: UITableView - Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
//MARK: @IBActions
    
    @IBAction func doneButtonTouched(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func shareButtonTouched(sender: UIBarButtonItem) {
        
    }
}