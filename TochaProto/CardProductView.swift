//
//  CardProductView.swift
//  Docha
//
//  Created by Mathis D on 06/09/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class CardProductView: UIView {
    
    @IBOutlet weak var gaugeContainerView: UIView!
    @IBOutlet weak var userPinIconView: PinIconView!
    @IBOutlet weak var opponentPinIconView: PinIconView!
    
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productBrandLabel: UILabel!
    @IBOutlet weak var firstTagLabel: UILabel!
    @IBOutlet weak var secondTagLabel: UILabel!
    
    @IBOutlet weak var counterContainerView: CounterContainerView!
    
    @IBOutlet weak var widthFirstTagConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthSecondTagConstraint: NSLayoutConstraint!
    @IBOutlet weak var centerXUserPinIconConstraint: NSLayoutConstraint!
    @IBOutlet weak var centerXOpponentPinIconConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.firstTagLabel.minimumScaleFactor = 8
        self.firstTagLabel.adjustsFontSizeToFitWidth = true
        
        self.secondTagLabel.minimumScaleFactor = 8
        self.secondTagLabel.adjustsFontSizeToFitWidth = true
        
        self.userPinIconView.hidden = true
        self.opponentPinIconView.hidden = true
        
        self.userPinIconView.setAvatarImage(UIImage(named: "avatar_man_profil")!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func updatePinIconPositionWithErrorPercent(errorPercent: Double, completion: ((finished: Bool) -> Void)?) {
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
        
        self.userPinIconView.hidden = false
        
        UIView.animateWithDuration(1.0, animations: {
            self.centerXUserPinIconConstraint.constant = newPosX
            self.layoutIfNeeded()
            
            }, completion: { (finished) in
                completion?(finished: finished)
            })
    }
}