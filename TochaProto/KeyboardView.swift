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
    
    var numbersArray: [Int]?
    
    @IBOutlet var counterViewArray: [CounterView]!
    @IBOutlet weak var centaineCounterView: CounterView!
    @IBOutlet weak var dizaineCounterView: CounterView!
    @IBOutlet weak var uniteCounterView: CounterView!
    @IBOutlet weak var centsLabel: UILabel!
    
    @IBOutlet weak var circularTimer: MBCircularProgressBarView!
    
    func initCounterData() {
        numbersArray = []
        
        for _ in 0...counterViewArray.count {
            numbersArray?.append(-1)
        }
    }
    
    func initCountersViews() {
        initCounterData()
        
        for counterView in counterViewArray {
            counterView.counterImage = JDFlipImageView(frame: CGRectMake(0.0, 0.0, counterView.bounds.width, counterView.bounds.height))
            counterView.counterImage.image = UIImage(named: "counter_base")
            counterView.counterImage.contentMode = .ScaleAspectFit
        }
    }
    
    func resetCountersViews() {
        for counterView in counterViewArray {
            counterView.counterImage.setImageAnimated(
                UIImage(named: "counter_base"),
                duration: 0.5,
                completion: { (finished) in
                    counterView.currentNumber = -1
                    self.initCounterData()
            })
        }
    }
}