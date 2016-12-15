//
//  GameplayRewardsMatchTieViewController.swift
//  Docha
//
//  Created by Mathis D on 09/12/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

class GameplayRewardsMatchTieViewController: GameViewController {
    
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.animatedLikeBubbleWithDelay(1.0, duration: 0.5)
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
