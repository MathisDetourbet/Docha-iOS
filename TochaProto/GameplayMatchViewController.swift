//
//  GameplayMatchViewController.swift
//  Docha
//
//  Created by Mathis D on 16/09/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

class GameplayMatchViewController: GameViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
//MARK: UITableView - Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
            
        } else {
            return "ROUND \(section)"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "idGameplayMatchScoreCell", for: indexPath) as! GameplayMatchScoreTableViewCell
        
        return cell
    }
    
    
//MARK: UITableView - Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
            
        } else {
            let headerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.width, height: 28))
            headerView.backgroundColor = UIColor.clear
            let sectionLabel = UILabel(frame: CGRect(x: 5.0, y: 5.0, width: 100.0, height: 28.0))
            sectionLabel.textColor = UIColor.darkBlueDochaColor()
            sectionLabel.text = "ROUND \(section)"
            sectionLabel.font = UIFont(name: "Montserrat-Semibold", size: 12)
            headerView.addSubview(sectionLabel)
            
            return headerView
        }
    }
    
//MARK: @IBActions
    
    @IBAction func playButtonTouched(_ sender: UIButton) {
        
    }
    
    @IBAction func withdrawButtonTouched(_ sender: UIButton) {
        
    }
}
