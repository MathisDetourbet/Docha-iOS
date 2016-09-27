//
//  CircularProgressBarHelper.swift
//  Docha
//
//  Created by Mathis D on 29/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import MBCircularProgressBar

private var timerLabelAssocKey = 0

//MARK: Circular Progress Bar Methods
extension MBCircularProgressBarView {
    var timerLabel: UILabel? {
        get {
            return objc_getAssociatedObject(self, &timerLabelAssocKey) as? UILabel
        }
        set {
            return objc_setAssociatedObject(self, &timerLabelAssocKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func initProgressBarWithCoolDown(_ cooldown: Int, andColorLabel colorLabel: UIColor) {
        
        self.maxValue = 100
        self.value = 100
        
        if self.timerLabel == nil {
            self.timerLabel = UILabel(frame: CGRect(x: self.frame.width/2, y: self.frame.height/2, width: 30.0, height: 30.0))
            self.timerLabel?.text = String(cooldown)
            self.timerLabel?.font = UIFont(name: "Montserrat-ExtraBold", size: 22.0)
            self.timerLabel?.textColor = colorLabel
            self.timerLabel?.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(timerLabel!)
            self.addConstraint(NSLayoutConstraint(item: self.timerLabel!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0))
            self.addConstraint(NSLayoutConstraint(item: self.timerLabel!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        }
    }
    
    func updateTimerLabelWithTime(_ time: Int) {
        self.timerLabel?.text = String(time)
    }
    
    func stopTimer() {
        self.timerLabel?.text = ""
    }
}
