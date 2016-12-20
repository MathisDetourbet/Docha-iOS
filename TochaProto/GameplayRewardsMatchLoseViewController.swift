//
//  GameplayRewardsMatchLoseViewController.swift
//  Docha
//
//  Created by Mathis D on 09/12/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import SnapKit

class GameplayRewardsMatchLoseViewController: GameViewController {
    
    var leftCounterImageView: UIImageView!
    var centerXLeftCounterConstraint: Constraint?
    
    var middleCounterImageView: UIImageView!
    var topMiddleCounterConstraint: Constraint?
    
    var rightCounterImageView: UIImageView!
    var centerXRightCounterConstraint: Constraint?
    
    var dochosImageView: UIImageView!
    var topDochosConstraint: Constraint?
    
    let kCounterAnimationDuration = 1.0
    let kDochosAnimationDuration = 0.3
    
    @IBOutlet weak var animationsContainerView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        prepareUI()
        startAnimation()
    }
    
    func prepareUI() {
        // Left counter
        leftCounterImageView = UIImageView(image: #imageLiteral(resourceName: "case_blue"))
        animationsContainerView.addSubview(leftCounterImageView)
        let leftCounterOffset = -(animationsContainerView.frame.width + leftCounterImageView.frame.width) / 2
        leftCounterImageView.snp.makeConstraints { (make) in
            self.centerXLeftCounterConstraint = make.centerX.equalToSuperview().offset(leftCounterOffset).constraint
            make.bottom.equalToSuperview()
            make.height.equalTo(leftCounterImageView.snp.width)
        }
        
        // Right counter
        rightCounterImageView = UIImageView(image: #imageLiteral(resourceName: "case_blue"))
        animationsContainerView.addSubview(rightCounterImageView)
        let rightCounterOffset = (animationsContainerView.frame.width + rightCounterImageView.frame.width) / 2
        rightCounterImageView.snp.makeConstraints { (make) in
            self.centerXRightCounterConstraint = make.centerX.equalToSuperview().offset(rightCounterOffset).constraint
            make.bottom.equalToSuperview()
            make.height.equalTo(rightCounterImageView.snp.width)
        }
        
        // Middle counter
        middleCounterImageView = UIImageView(image: #imageLiteral(resourceName: "case_blue"))
        animationsContainerView.addSubview(middleCounterImageView)
        middleCounterImageView.snp.makeConstraints { (make) in
            self.topMiddleCounterConstraint = make.top.equalToSuperview().offset(-middleCounterImageView.frame.height).constraint
            make.centerX.equalTo(self.animationsContainerView.snp.centerX)
            make.height.equalTo(middleCounterImageView.snp.width)
        }
        
        // Dochos
        dochosImageView = UIImageView(image: #imageLiteral(resourceName: "dochos_animation_1"))
        animationsContainerView.insertSubview(dochosImageView, belowSubview: leftCounterImageView)
        dochosImageView.snp.makeConstraints { (make) in
            self.topDochosConstraint = make.top.equalToSuperview().offset(-dochosImageView.frame.height).constraint
            make.centerX.equalTo(self.animationsContainerView.snp.centerX)
            make.height.equalTo(dochosImageView.snp.width)
        }
        
        var dochosImages: [UIImage] = []
        for i in 2...9 {
            let image = UIImage(named: "dochos_animation_\(i)")
            
            if let image = image {
                dochosImages.append(image)
            }
        }
        dochosImageView.animationImages = dochosImages
        dochosImageView.animationDuration = 0.1
        dochosImageView.animationRepeatCount = 1
        
        self.view.layoutIfNeeded()
    }
    
    
// MARK: - Animation Methods
    
    func startAnimation() {
        animateLeftCounter()
        animateRightCounter()
        animateMiddleCounter {
            self.animateDochos()
        }
    }
    
    func animateLeftCounter() {
        let margin = 10.0 as CGFloat
        let centerXConstant = -leftCounterImageView.frame.width - margin as ConstraintOffsetTarget
        centerXLeftCounterConstraint?.update(centerXConstant)
        
        UIView.animate(withDuration: kCounterAnimationDuration,
            animations: {
                self.view.layoutIfNeeded()
                
            }, completion: { (finished) in
                self.leftCounterImageView.image = #imageLiteral(resourceName: "case_red")
            }
        )
    }
    
    func animateRightCounter() {
        let margin = 10.0 as CGFloat
        let centerXConstant = rightCounterImageView.frame.width + margin as ConstraintOffsetTarget
        centerXRightCounterConstraint?.update(centerXConstant)
        
        UIView.animate(withDuration: kCounterAnimationDuration,
            animations: {
                self.view.layoutIfNeeded()
            
            }, completion: { (finished) in
                self.rightCounterImageView.image = #imageLiteral(resourceName: "case_red")
            }
        )
    }
    
    func animateMiddleCounter(_ completion: @escaping () -> Void) {
        let topConstant = animationsContainerView.frame.height - middleCounterImageView.frame.height as ConstraintOffsetTarget
        topMiddleCounterConstraint?.update(topConstant)
        
        UIView.animate(withDuration: kCounterAnimationDuration,
            animations: {
                self.view.layoutIfNeeded()
                        
            }, completion: { (finished) in
                self.middleCounterImageView.image = #imageLiteral(resourceName: "case_red")
                completion()
            }
        )
    }
    
    func animateDochos() {
        let firstTopConstraint = middleCounterImageView.frame.origin.y - dochosImageView.frame.height / 2 as ConstraintOffsetTarget
        let secondTopConstraint = (firstTopConstraint as! CGFloat) as ConstraintOffsetTarget
        topDochosConstraint?.update(firstTopConstraint)
        
        UIView.animate(withDuration: kDochosAnimationDuration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .allowUserInteraction,
            animations: {
                self.view.layoutIfNeeded()
            
            }, completion: { (_) in
                self.topDochosConstraint?.update(secondTopConstraint)
                self.dochosImageView.image = #imageLiteral(resourceName: "dochos_animation_9")
                self.dochosImageView.startAnimating()
                
                UIView.animate(withDuration: 0.01, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 5.0, options: .allowUserInteraction,
                    animations: {
                        self.view.layoutIfNeeded()
                                
                    }, completion: { (_) in
                        self.nextButton.isHidden = false
                        self.nextButton.animatedLikeBubbleWithDelay(0.0, duration: 0.5)
                    }
                )
            }
        )
    }
    
    
// MARK: - @IBActions
    
    @IBAction func nextButtonTouched(_ sender: UIButton) {
        let match = MatchManager.sharedInstance.currentMatch
        
        if let match = match {
            goToMatch(match, animated: true)
            
        } else {
            goToHome()
        }
    }
}
