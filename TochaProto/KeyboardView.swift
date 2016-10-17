//
//  KeyboardView.swift
//  Docha
//
//  Created by Mathis D on 10/06/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import MBCircularProgressBar

protocol KeyboardViewDelegate {
    func validatePricing()
    func eraseAllCounters()
    func clickOnPad(withNumber number: Int)
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
    
    func enabledKeyboard(_ enabled: Bool) {
        for padButton in padButtons {
            padButton.isEnabled = enabled
        }
        eraseButton.isEnabled = enabled
        validButton.isEnabled = enabled
    }
    
    func enableEreaseButton(_ enabled: Bool) {
        self.eraseButton.isEnabled = enabled
    }
    
    func enableValidButton(_ enabled: Bool) {
        self.validButton.isEnabled = enabled
    }
    
    @IBAction func validatePricing(_ sender: UIButton) {
        self.delegate?.validatePricing()
    }
    
    @IBAction func eraseAllCounters(_ sender: UIButton) {
        self.delegate?.eraseAllCounters()
        self.validButton.isEnabled = false
        self.eraseButton.isEnabled = false
    }
    
    @IBAction func clickOnPad(_ sender: UIButton) {
        let padNumber = sender.tag
        self.delegate?.clickOnPad(withNumber: padNumber)
        self.eraseButton.isEnabled = true
    }
}
