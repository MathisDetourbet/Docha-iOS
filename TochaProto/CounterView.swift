//
//  CounterView.swift
//  TochaProto
//
//  Created by Mathis D on 10/01/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import UIKit

class CounterView: UIImageView {
    let NUMBER_MAX = 10
    var counterImage: JDFlipImageView! {
        didSet {
            self.counterImage.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(self.counterImage)
            
            self.addConstraint(NSLayoutConstraint(item: counterImage, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: counterImage, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: counterImage, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: counterImage, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0))
        }
    }
    var isSelected: Bool = false {
        didSet {
            if isSelected {
                self.image = UIImage(named: "counter_number_start")
            } else {
                self.image = UIImage(named: "counter_number_start")
            }
        }
    }
    var numberLabel: UILabel!
    var currentNumber: Int! = -1 {
        didSet {
            if currentNumber >= 10 {
                currentNumber = 0
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, isSelected: Bool, numberLabel: UILabel) {
        self.init(frame:CGRect.zero)
        
        self.numberLabel = numberLabel
        self.isSelected = isSelected
        
        self.counterImage = JDFlipImageView(frame: CGRectMake(0, 0, 50, 50))
        self.counterImage.image = UIImage(named: "counter_number_start")
        self.counterImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraint(NSLayoutConstraint(item: self.counterImage, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.counterImage, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.counterImage, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.counterImage, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func startCounterAnimation(WithNumber newNumber: Int, completion: (finished: Bool) -> Void) {
        if newNumber == -1 {
            if newNumber == currentNumber! {
                self.isSelected = false
                completion(finished: true)
                return
            }
            self.currentNumber! = newNumber
            self.counterImage.setImageAnimated(UIImage(named: "counter_number_start"), duration: 0.5, completion: { (finished) -> Void in
                if finished {
                    completion(finished: false)
                }
            })
        }
        
        // Calcul de l'écart entre l'ancien nombre et le nouveau : rang
        var range: Int
        if currentNumber != -1 {
            if currentNumber! > newNumber {
                range = NUMBER_MAX - currentNumber! + newNumber
            } else if currentNumber! == newNumber {
                self.isSelected = false
                completion(finished: true)
                return
            } else {
                range = newNumber - abs(currentNumber!)
            }
        } else {
            range = newNumber + 1
        }
        
        if range == 0 {
            self.isSelected = false
            completion(finished: true)
            return
        } else if range == 1 {
            self.currentNumber! += 1
            let currentNumberStr = String(self.currentNumber!)
            self.counterImage.setImageAnimated(UIImage(named: String(currentNumberStr + "_counter")), duration: 0.5, completion: { (finished) -> Void in
                if finished {
                    self.isSelected = false
                    completion(finished: true)
                }
            })
        } else {
            var opArray: [NSBlockOperation] = []
            let queue: NSOperationQueue = NSOperationQueue.mainQueue()
            for i in 1...range {
                self.currentNumber! += 1
                var currentNumberStr = String(self.currentNumber!)
                let opBlock: NSBlockOperation = NSBlockOperation(block: ({ () -> Void in
                    self.counterImage.setImageAnimated(UIImage(named: String(currentNumberStr + "_counter")), duration: 0.3, completion: { (finished) -> Void in
                        if finished {
                            currentNumberStr = String(self.currentNumber!)
                        }
                    })
                }))
                opBlock.qualityOfService = .UserInteractive
                if (i-1) != 0 {
                    opBlock.addDependency(opArray[opArray.count-1])
                }
                opArray.append(opBlock)
            }
            for opBlock in opArray {
                queue.addOperation(opBlock)
            }
            
            self.isSelected = false
            completion(finished: true)
        }
    }
}
