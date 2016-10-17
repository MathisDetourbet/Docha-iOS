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
        opponentPinIconView.isHidden = true
        
        userPinIconView.setAvatarImage(UIImage(named: "avatar_man_small")!)
        
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
            let gaugeFrame = self.gaugeContainerView.frame
            
            if errorPercent >= 100.0 {
                newPosX = gaugeFrame.origin.x + gaugeFrame.width / 2
                
            } else if errorPercent <= -100.0 {
                newPosX = gaugeFrame.origin.x - gaugeFrame.width / 2
                
            } else {
                let errorPercentFloat = CGFloat(errorPercent)
                newPosX = (gaugeFrame.width / 2) * errorPercentFloat + ((errorPercentFloat / abs(errorPercentFloat)) * (gaugeFrame.width * 0.107))
            }
        }
        
        var constraintToSet: NSLayoutConstraint
        
        if isForUser {
            self.userPinIconView.isHidden = false
            constraintToSet = centerXUserPinIconConstraint
            
        } else {
            self.opponentPinIconView.isHidden = false
            constraintToSet = centerXOpponentPinIconConstraint
            
        }
        
        UIView.animate(withDuration: 1.0, animations: {
            constraintToSet.constant = newPosX
            self.layoutIfNeeded()
            
            }, completion: { (finished) in
                completion?(finished)
            }
        )
    }
}
