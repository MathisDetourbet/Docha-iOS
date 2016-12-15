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
    var matchResult: MatchResult?
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var dochosLabel: SACountingLabel!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildUI()
    }
    
    func buildUI() {
        
        nextButton.animatedLikeBubbleWithDelay(1.0, duration: 0.5)
        
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
            if let match = match {
                goToMatch(match, animated: true)
                
            } else {
                goToHome()
            }
        }
    }
}
