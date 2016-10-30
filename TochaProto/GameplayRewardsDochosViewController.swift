//
//  GameplayRewardsDochosViewController.swift
//  Docha
//
//  Created by Mathis D on 24/10/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import SACountingLabel

class GameplayRewardsDochosViewController: GameViewController {
    
    var dochosWon: Int = 0
    var showLevelUpVC: Bool = false
    
    @IBOutlet weak var dochosLabel: SACountingLabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dochosLabel.countFrom(0, to: Float(dochosWon), withDuration: 3.0, andAnimationType: .easeInOut, andCountingType: .int)
    }
    
    @IBAction func nextButtonTouched(_ sender: UIButton) {
        if showLevelUpVC {
            let rewardsLevelUpVC = self.storyboard?.instantiateViewController(withIdentifier: "idGameplayRewardsLevelUpViewController") as! GameplayRewardsLevelUpViewController
            self.navigationController?.pushViewController(rewardsLevelUpVC, animated: true)
            
        } else {
            let match = MatchManager.sharedInstance.currentMatch
            if let match = match {
                goToMatch(match)
                
            } else {
                goToHome()
            }
        }
    }
}
