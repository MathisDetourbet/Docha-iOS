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
    var newLevel: Int?
    var matchResult: MatchResult?
    
    @IBOutlet weak var dochosLabel: SACountingLabel!
    @IBOutlet weak var nextButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildUI()
    }
    
    func buildUI() {
        nextButton.animatedLikeBubbleWithDelay(1.0, duration: 0.5)
        dochosLabel.countFrom(0, to: Float(dochosWon), withDuration: 3.0, andAnimationType: .easeInOut, andCountingType: .int)
    }
    
    @IBAction func nextButtonTouched(_ sender: UIButton) {
        if let newLevel = newLevel {
            let rewardsLevelUpVC = self.storyboard?.instantiateViewController(withIdentifier: "idGameplayRewardsLevelUpViewController") as! GameplayRewardsLevelUpViewController
            rewardsLevelUpVC.newUserLevel = newLevel
            rewardsLevelUpVC.matchResult = matchResult
            self.navigationController?.pushViewController(rewardsLevelUpVC, animated: true)
            
        } else {
            if let matchResult = matchResult {
                // Let's display the matchResultVC
                switch matchResult {
                case .won:
                    let rewardVC = self.storyboard?.instantiateViewController(withIdentifier: "idGameplayRewardsMatchWonViewController") as! GameplayRewardsMatchWonViewController
                    self.navigationController?.pushViewController(rewardVC, animated: true)
                    break
                    
                case .lost:
                    let rewardVC = self.storyboard?.instantiateViewController(withIdentifier: "idGameplayRewardsMatchLoseViewController") as! GameplayRewardsMatchLoseViewController
                    self.navigationController?.pushViewController(rewardVC, animated: true)
                    break
                    
                case .tie:
                    let rewardVC = self.storyboard?.instantiateViewController(withIdentifier: "idGameplayRewardsMatchTieViewController") as! GameplayRewardsMatchTieViewController
                    self.navigationController?.pushViewController(rewardVC, animated: true)
                    break
                }
                
            } else {
                let match = MatchManager.sharedInstance.currentMatch
                
                if let match = match {
                    goToMatch(match, animated: true)
                    
                } else {
                    goToHome()
                }
            }
        }
    }
}
