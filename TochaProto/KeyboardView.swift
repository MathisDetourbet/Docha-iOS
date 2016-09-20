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
    
    @IBOutlet weak var counterContainerView: CounterContainerView!
    
    @IBOutlet var padButtons: [UIButton]!
    @IBOutlet weak var eraseButton: UIButton!
    @IBOutlet weak var validButton: UIButton!
    
    func reset() {
        enableValidButton(false)
        enableEreaseButton(false)
    }
    
    func enabledKeyboard(enabled: Bool) {
        for padButton in padButtons {
            padButton.enabled = enabled
        }
        eraseButton.enabled = enabled
        validButton.enabled = enabled
    }
    
    func enableEreaseButton(enabled: Bool) {
        self.eraseButton.enabled = enabled
    }
    
    func enableValidButton(enabled: Bool) {
        self.validButton.enabled = enabled
    }
    
    @IBAction func validatePricing(sender: UIButton) {
        self.delegate?.validatePricing()
    }
    
    @IBAction func eraseAllCounters(sender: UIButton) {
        self.delegate?.eraseAllCounters()
        self.validButton.enabled = false
        self.eraseButton.enabled = false
    }
    
    @IBAction func clickOnPad(sender: UIButton) {
        let padNumber = sender.tag
        self.delegate?.clickOnPadWithNumber(padNumber)
        self.eraseButton.enabled = true
    }
}