//
//  CounterView.swift
//  TochaProto
//
//  Created by Mathis D on 10/01/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import UIKit

enum CounterViewAfterType {
    case perfect
    case green
    case red
}

class CounterView: UIImageView {
    let NUMBER_MAX = 10
    let DURATION_COUNTER_ANIMATION = 0.2 as CGFloat
    var counterImage: JDFlipImageView! {
        didSet {
            counterImage.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(counterImage)
            
            self.addConstraint(NSLayoutConstraint(item: counterImage, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: counterImage, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: counterImage, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: counterImage, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0))
        }
    }
    var isSelected: Bool = false {
        didSet {
            if isSelected {
                self.image = UIImage(named: "counter_base")
            } else {
                self.image = UIImage(named: "counter_base")
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
        
        self.counterImage = JDFlipImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.counterImage.image = UIImage(named: "counter_base")
        self.counterImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraint(NSLayoutConstraint(item: self.counterImage, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.counterImage, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.counterImage, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.counterImage, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func startCounterAnimationWithNumber(number newNumber: Int, completion: ((_ finished: Bool) -> Void)?) {
        if newNumber == -1 {
            if newNumber == currentNumber! {
                self.isSelected = false
                completion?(true)
                return
            }
            self.currentNumber! = newNumber
            self.counterImage.setImageAnimated(UIImage(named: "counter_base"), duration: DURATION_COUNTER_ANIMATION, completion: { (finished) -> Void in
                if finished {
                    completion?(false)
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
                completion?(true)
                return
                
            } else {
                range = newNumber - abs(currentNumber!)
            }
        } else {
            range = newNumber + 1
        }
        
        if range == 0 {
            self.isSelected = false
            completion?(true)
            return
            
        } else if range == 1 {
            self.currentNumber! += 1
            let currentNumberStr = String(self.currentNumber!)
            self.counterImage.setImageAnimated(
                UIImage(named: String("counter_" + currentNumberStr)),
                duration: DURATION_COUNTER_ANIMATION,
                completion: { (finished) -> Void in
                if finished {
                    self.isSelected = false
                    completion?(true)
                }
            })
            
        } else {
            var opArray: [BlockOperation] = []
            let queue: OperationQueue = OperationQueue.main
            for i in 1...range {
                self.currentNumber! += 1
                var currentNumberStr = String(self.currentNumber!)
                let opBlock: BlockOperation = BlockOperation(block: ({ () -> Void in
                    self.counterImage.setImageAnimated(
                        UIImage(named: String("counter_" + currentNumberStr)),
                        duration: self.DURATION_COUNTER_ANIMATION,
                        completion: { (finished) -> Void in
                        if finished {
                            currentNumberStr = String(self.currentNumber!)
                        }
                    })
                }))
                opBlock.qualityOfService = .userInteractive
                if (i-1) != 0 {
                    opBlock.addDependency(opArray[opArray.count-1])
                }
                opArray.append(opBlock)
            }
            for opBlock in opArray {
                queue.addOperation(opBlock)
            }
            
            self.isSelected = false
            completion?(true)
        }
    }
    
    func setCounterViewAfterWithCounterViewAfterType(_ type: CounterViewAfterType) {
        switch type {
        case .perfect: counterImage.image = UIImage(named: "counter_perfect"); break
        case .green: counterImage.image = UIImage(named: "counter_right"); break
        default: counterImage.image = UIImage(named: "counter_wrong"); break
        }
    }
}
