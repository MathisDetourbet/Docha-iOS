//
//  KeyboardView.swift
//  Docha
//
//  Created by Mathis D on 10/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import MBCircularProgressBar

protocol KeyboardViewDelegate {
    func validatePricing()
    func eraseAllCounters()
    func clickOnPadWithNumber(number: Int)
}

class KeyboardView: UIView {
    
    var delegate: KeyboardViewDelegate?
    
    @IBOutlet var padButtons: [UIButton]!
    @IBOutlet weak var eraseButton: UIButton!
    @IBOutlet weak var validButton: UIButton!
    
    
    @IBAction func validatePricing(sender: UIButton) {
        self.delegate?.validatePricing()
    }
    
    @IBAction func eraseAllCounters(sender: UIButton) {
        self.delegate?.eraseAllCounters()
    }
    
    @IBAction func clickOnPad(sender: UIButton) {
        let padNumber = sender.tag
        self.delegate?.clickOnPadWithNumber(padNumber)
    }
}

class CounterContainerView: UIView {
    
    @IBOutlet weak var centaineCounterView: CounterView!
    @IBOutlet weak var dizaineCounterView: CounterView!
    @IBOutlet weak var uniteCounterView: CounterView!
    @IBOutlet weak var centsLabel: UILabel!
    
    @IBOutlet weak var circularTimer: MBCircularProgressBarView!
}