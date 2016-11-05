//
//  GameplayRewardsLevelUpViewController.swift
//  Docha
//
//  Created by Mathis D on 25/10/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import SACountingLabel

class GameplayRewardsLevelUpViewController: GameViewController {
    
    var newUserLevel: Int?
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var dochosLabel: SACountingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dochosLabel.isHidden = true
        if let newUserLevel = newUserLevel {
            levelLabel.text = "Niveau \(newUserLevel)"
            
        } else if let newUserLevel = UserSessionManager.sharedInstance.currentSession()?.levelMaxUnlocked {
            levelLabel.text = "Niveau \(newUserLevel)"
            
        } else {
            levelLabel.text = nil
        }
    }
    
    
    @IBAction func nextButtonTouched(_ sender: UIButton) {
        let match = MatchManager.sharedInstance.currentMatch
        
        if let match = match {
            goToMatch(match, animated: true)
            
        } else {
            goToHome()
        }
    }
}
