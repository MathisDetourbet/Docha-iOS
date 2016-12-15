//
//  CardProductView.swift
//  Docha
//
//  Created by Mathis D on 06/09/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

class CardProductView: UIView {
    
    @IBOutlet weak var gaugeContainerView: UIView!
    @IBOutlet weak var userPinIconView: PinIconView!
    @IBOutlet weak var opponentPinIconView: PinIconView!
    
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productBrandLabel: UILabel!
    
    @IBOutlet weak var counterContainerView: CounterContainerView!
    
    @IBOutlet weak var centerXUserPinIconConstraint: NSLayoutConstraint!
    @IBOutlet weak var centerXOpponentPinIconConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userPinIconView.isHidden = true
        userPinIconView.animationType = .shake(repeatCount: 1)
        userPinIconView.delay = 0.0
        userPinIconView.duration = 1.0
        userPinIconView.velocity = 2
        userPinIconView.force = 0.5
        
        userPinIconView.setAvatarImage(#imageLiteral(resourceName: "avatar_man_small"))
        
        opponentPinIconView.isHidden = true
        opponentPinIconView.animationType = .shake(repeatCount: 1)
        opponentPinIconView.delay = 0.0
        opponentPinIconView.duration = 1.0
        opponentPinIconView.velocity = 2
        opponentPinIconView.force = 1
        
        productImageView.layer.cornerRadius = 18.0
        productImageView.layer.masksToBounds = false
        productImageView.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func updatePinIconPosition(withErrorPercent errorPercent: Double, forPlayer isForUser: Bool, andCompletion completion: ((_ finished: Bool) -> Void)?) {
        var newPosX = 0.0 as CGFloat
        
        if errorPercent != 0.0 {
            let gaugeHalfWidth = gaugeContainerView.frame.width / 2
            let multiplier = CGFloat(errorPercent / abs(errorPercent))
            
            if errorPercent >= 1.0 {
                newPosX = gaugeHalfWidth
                
            } else if errorPercent <= -1.0 {
                newPosX = -gaugeHalfWidth
                
            } else {
                let perfectSquareWidth = gaugeHalfWidth * 2.0 * 0.090
                let errorPercentReverse = 1.0 - errorPercent
                newPosX = multiplier * abs(CGFloat(log(abs(errorPercentReverse)))) * gaugeHalfWidth +  multiplier * perfectSquareWidth / 2
                
                if newPosX > gaugeHalfWidth || newPosX < -gaugeHalfWidth {
                    newPosX = multiplier * gaugeHalfWidth
                }
            }
        }
        
        var constraintToSet: NSLayoutConstraint
        
        if isForUser {
            userPinIconView.isHidden = false
            constraintToSet = centerXUserPinIconConstraint
            
        } else {
            opponentPinIconView.isHidden = false
            constraintToSet = centerXOpponentPinIconConstraint
        }
        
        if constraintToSet.constant == newPosX {
            if isForUser {
                userPinIconView.animate() {
                    completion?(true)
                }
                
            } else {
                opponentPinIconView.animate() {
                    completion?(true)
                }
            }
            
        } else {
            UIView.animate(withDuration: 1.0, animations: {
                constraintToSet.constant = newPosX
                self.layoutIfNeeded()
                
            }, completion: { (finished) in
                completion?(finished)
            })
        }
    }
}
