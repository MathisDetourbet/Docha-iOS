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
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var dochosLabel: SACountingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func nextButtonTouched(_ sender: UIButton) {
        self.goToHome()
    }
}
