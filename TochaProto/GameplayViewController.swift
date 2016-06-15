//
//  GameplayViewController.swift
//  Docha
//
//  Created by Mathis D on 10/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import MBCircularProgressBar
import SwiftyTimer

//MARK: Circular Progress Bar Methods
extension MBCircularProgressBarView {
    func initProgressBar() {
        self.maxValue = 100
        self.value = 100
    }
}

enum GameplayMode {
    case Preview
    case Main
    case After
    case Debrief
}

class GameplayViewController: RootViewController, KeyboardViewDelegate {
    
    var productsList: [Product]?
    
    var cursorCounter: Int?
    
    let kCooldownForPreview: Double! = 2.0
    let kCooldownForMain: Double! = 7.0
    var currentTotalCooldown: Double? {
        didSet {
            self.currentMillisecondTime = currentTotalCooldown
        }
    }
    var currentMillisecondTime: Double? {
        didSet {
            if self.gameplayMode == .Preview {
                self.previewCircularProgress.value = CGFloat(Double(self.currentMillisecondTime! * 100.0) / self.currentTotalCooldown!)
            } else if self.gameplayMode == .Main {
                self.mainCircularProgress.value = CGFloat(Double(self.currentMillisecondTime! * 100.0) / self.currentTotalCooldown!)
            }
        }
    }
    var timer: NSTimer?
    
    var gameplayMode: GameplayMode! = .Preview {
        didSet {
            self.startGameplayMode(gameplayMode)
            if gameplayMode == .Preview {
                startPreviewMode()
            } else if gameplayMode == .Main {
                startMainMode()
            }
        }
    }
    
    // MARK: @IBOutlets
    @IBOutlet weak var previewCircularProgress: MBCircularProgressBarView!
    @IBOutlet weak var mainCircularProgress: MBCircularProgressBarView!
    @IBOutlet weak var productBrandLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var topInfosContainerView: UIView!
    @IBOutlet weak var bottomFeaturesContainer: UIView!
    @IBOutlet weak var firstFeatureLabel: UILabel!
    @IBOutlet weak var secondFeatureLabel: UILabel!
    @IBOutlet weak var thirdFeatureLabel: UILabel!
    
    
    @IBOutlet weak var keyboardCounterContainerView: UIView!
    @IBOutlet weak var keyboardContainerView: KeyboardView!
    @IBOutlet weak var counterContainerView: CounterContainerView!
    
    // Product ImageView Constraints
    @IBOutlet weak var topProductImageViewConstraint: NSLayoutConstraint!
    var aspectProductImageViewConstraint: NSLayoutConstraint?
    @IBOutlet weak var heightProductImageViewConstraint: NSLayoutConstraint!
    
    // Top Container Constraints (productName + brandName)
    @IBOutlet weak var topInfosContainerConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthInfosContainerConstraint: NSLayoutConstraint!
    
    // Features Container Constraint
    @IBOutlet weak var topFeaturesContainerConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingFeaturesContainerConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightFeaturesContainerConstraint: NSLayoutConstraint!
    @IBOutlet weak var topFeaturesSubContainerConstraint: NSLayoutConstraint!
    
    // Keyboard Constraint
    @IBOutlet weak var topKeyboardCounterConstraint: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        startGameplayMode(self.gameplayMode)
        self.keyboardContainerView.delegate = self
    }
    
    func configureView() {
        self.hidesBottomBarWhenPushed = true
        //self.heightProductImageViewConstraint.constant = 0.891 * self.view.frame.height
        self.heightFeaturesContainerConstraint.constant = self.view.frame.height - (self.topInfosContainerView.frame.height + self.productImageView.frame.height)
        self.view.layoutIfNeeded()
    }
    
    //MARK: Gameplay Life Cycle Methods
    
    func startGameplayMode(mode: GameplayMode) {
        switch mode {
        case .Preview:
            startPreviewMode()
            break
        case .Main:
            startMainMode()
            break
        case .After:
            startAfterMode()
            break
        default:
            startDebriefMode()
            break
        }
    }
    
    func startPreviewMode() {
        initTimer()
        startTimer()
        self.previewCircularProgress.hidden = false
        hideKeyboardCounterContainerView(true)
    }
    
    func startMainMode() {
        self.cursorCounter = 0
        self.counterContainerView.initCountersViews()
        
        self.previewCircularProgress.hidden = true
        hideKeyboardCounterContainerView(false)
        
        self.topInfosContainerView.hidden = true
        self.bottomFeaturesContainer.hidden = true
        
        // Moving ImageView
        self.topProductImageViewConstraint.constant = 0.0
        self.heightProductImageViewConstraint.constant = 0.229 * self.view.frame.height
        
        // Configure infos product contraints
        // Top Infos
        self.topInfosContainerConstraint.constant = self.productImageView.frame.height
        
        // Features bottom container
        self.leadingFeaturesContainerConstraint.constant = self.view.frame.width / 2
        self.topFeaturesContainerConstraint.constant = self.productImageView.frame.height
        self.heightFeaturesContainerConstraint.constant = self.view.frame.height - (self.keyboardContainerView.frame.height + self.productImageView.frame.height)
        self.topFeaturesSubContainerConstraint.constant = 8.0
        
        self.topInfosContainerView.hidden = false
        self.bottomFeaturesContainer.hidden = false
        self.topInfosContainerView.animatedLikeBubbleWithDelay(0.0, duration: 0.5)
        self.bottomFeaturesContainer.animatedLikeBubbleWithDelay(0.2, duration: 0.5)
        
        self.view.layoutIfNeeded()
        
        
        // Top Infos Container
//        self.widthTopContainerConstraint.constant = self.view.frame.width / 1.882
//        self.LeadingTopContainerConstraint.constant = self.view.frame.width - (self.view.frame.width / 1.882)
//        
//        // Product ImageView
//        self.topProductImageViewConstraint.constant = 0.0
//        self.aspectProductImageViewContraint = NSLayoutConstraint(item: self.productImageView, attribute: .Width, relatedBy: .Equal, toItem: self.productImageView, attribute: .Height, multiplier: 1, constant: 0)
//        self.trailingProductImageViewConstraint.constant = self.widthTopContainerConstraint.constant
//        
//        // Features Container
//        self.leadingInfosContainerConstraint.constant = self.view.frame.width - self.view.frame.width / 1.882
//        self.topInfosContainerConstraint.constant = 0.0
        //self.bottomFeaturesContainerConstraint.constant = self.keyboardContainerView.frame.size.height + 300
        //self.bottomFeaturesContainerConstraint = NSLayoutConstraint(item: self.bottomFeaturesContainer, attribute: .Bottom, relatedBy: .Equal, toItem: self.keyboardContainerView, attribute: .Top, multiplier: 1.0, constant: 0.0)
    }
    
    func startAfterMode() {
        
    }
    
    func startDebriefMode() {
        
    }
    
    func hideKeyboardCounterContainerView(hide: Bool) {
        self.keyboardCounterContainerView.hidden = hide
        
        if hide {
            self.topKeyboardCounterConstraint.constant = self.view.frame.size.height
            self.view.layoutSubviews()
        } else {
            UIView.animateWithDuration(1.0,
                                       delay: 0.0,
                                       usingSpringWithDamping: 0.6,
                                       initialSpringVelocity: 3.0,
                                       options: .AllowUserInteraction,
                                       animations: {
                self.topKeyboardCounterConstraint.constant = self.view.frame.size.height - self.keyboardCounterContainerView.frame.size.height
                self.view.layoutSubviews()
                                        
                }, completion: { (finished: Bool) in
                    self.initTimer()
                    self.startTimer()
            })
        }
    }
    
    
    //MARK: Timer Methods
    
    func startTimer() {
        self.timer?.start()
    }
    
    func initTimer() {
        if self.gameplayMode == .Preview {
            self.currentTotalCooldown = kCooldownForPreview
            self.previewCircularProgress.initProgressBar()
        } else if self.gameplayMode == .Main {
            self.currentTotalCooldown = kCooldownForMain
            self.mainCircularProgress.initProgressBar()
        }
        self.currentMillisecondTime = self.currentTotalCooldown
        self.timer = NSTimer.new(every: 0.01, { (timer: NSTimer) in
            self.updateTimer()
        })
    }
    
    func updateTimer() {
        self.currentMillisecondTime = self.currentMillisecondTime! - 0.01
        
        if self.currentMillisecondTime <= 0.0 {
            self.timer?.invalidate()
            
            if self.gameplayMode == .Preview {
                self.gameplayMode = .Main
            } else if self.gameplayMode == .Main {
                self.gameplayMode = .After
            }
        }
    }
    
    func clickOnPadWithNumber(number: Int) {
        self.counterContainerView.counterViewArray[cursorCounter!].startCounterAnimation(WithNumber: number) { (finished) in
            self.cursorCounter! += 1
            self.counterContainerView.numbersArray![self.cursorCounter!] = number
        }
    }
    
    func validatePricing() {
        
    }
    
    func eraseAllCounters() {
        self.counterContainerView.resetCountersViews()
    }
}