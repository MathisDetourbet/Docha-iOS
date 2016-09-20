//
//  GameplayMatchViewController.swift
//  Docha
//
//  Created by Mathis D on 16/09/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class GameplayMatchViewController: GameViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
//MARK: UITableView - Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
            
        } else {
            return "ROUND \(section)"
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("idGameplayMatchScoreCell", forIndexPath: indexPath) as! GameplayMatchScoreTableViewCell
        
        return cell
    }
    
    
//MARK: UITableView - Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
            
        } else {
            let headerView = UIView(frame: CGRectMake(0.0, 0.0, tableView.frame.width, 28))
            headerView.backgroundColor = UIColor.clearColor()
            let sectionLabel = UILabel(frame: CGRectMake(5.0, 5.0, 100.0, 28.0))
            sectionLabel.textColor = UIColor.darkBlueDochaColor()
            sectionLabel.text = "ROUND \(section)"
            sectionLabel.font = UIFont(name: "Montserrat-Semibold", size: 12)
            headerView.addSubview(sectionLabel)
            
            return headerView
        }
    }
    
//MARK: @IBActions
    
    @IBAction func playButtonTouched(sender: UIButton) {
        
    }
    
    @IBAction func withdrawButtonTouched(sender: UIButton) {
        
    }
}