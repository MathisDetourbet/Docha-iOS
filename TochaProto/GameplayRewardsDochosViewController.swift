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
    
    
    
    @IBOutlet weak var dochosLabel: SACountingLabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dochosLabel.countFrom(0, to: 10, withDuration: 2.0, andAnimationType: .easeInOut, andCountingType: .int)
    }
    
    @IBAction func nextButtonTouched(_ sender: UIButton) {
        self.goToHome()
    }
}
