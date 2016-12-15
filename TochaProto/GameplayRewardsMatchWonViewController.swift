//
//  GameplayRewardsMatchWonViewController.swift
//  Docha
//
//  Created by Mathis D on 09/12/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import SAConfettiView

class GameplayRewardsMatchWonViewController: GameViewController {
    
    @IBOutlet var starsImageViews: [UIImageView]!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildUI()
        animateStars()
    }
    
    func buildUI() {
        // Hide stars
        for star in starsImageViews {
            star.alpha = 0.0
        }
        
        nextButton.animatedLikeBubbleWithDelay(1.0, duration: 0.5)
        
        let confettiView = SAConfettiView(frame: self.view.bounds)
        confettiView.type = .confetti
        confettiView.colors = [UIColor.redDochaColor(), UIColor.blueDochaColor(), UIColor.white, UIColor.yellowDochaColor()]
        self.view.insertSubview(confettiView, belowSubview: nextButton)
        confettiView.startConfetti()
    }
    
    func animateStars() {
        for star in starsImageViews {
            animateShine(with: star)
        }
    }
    
    func animateShine(with star: UIImageView) {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .allowUserInteraction, animations: {
            star.alpha = 1.0
        }, completion: { (_) in
            UIView.animate(withDuration: 0.5, animations: {
                star.alpha = 0.0
            })
        })
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
