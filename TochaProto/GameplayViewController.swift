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

class GameplayViewController: RootViewController {
    
    var productsList: [Product]?
    
    let kCooldownForPreview: Double = 4.0
    let kCooldownForMain: Double = 7.0
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
    
    var gameplayMode: GameplayMode = .Preview {
        didSet {
            self.startGameplayMode(gameplayMode)
            if gameplayMode == .Preview {
                self.currentTotalCooldown = kCooldownForPreview
                startPreviewMode()
            } else if gameplayMode == .Main {
                self.currentTotalCooldown = kCooldownForMain
                startMainMode()
            }
        }
    }
    
    @IBOutlet weak var previewCircularProgress: MBCircularProgressBarView!
    @IBOutlet weak var mainCircularProgress: MBCircularProgressBarView!
    @IBOutlet weak var productBrandLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var firstFeatureLabel: UILabel!
    @IBOutlet weak var secondFeatureLabel: UILabel!
    @IBOutlet weak var thirdFeatureLabel: UILabel!
    
    
    @IBOutlet weak var keyboardCounterContainerView: UIView!
    @IBOutlet weak var keyboardContainerView: KeyboardView!
    @IBOutlet weak var counterContainerView: CounterContainerView!
    
    @IBOutlet weak var topKeyboardCounterConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        initTimer()
        startTimer()
        startGameplayMode(self.gameplayMode)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configureView() {
        self.hidesBottomBarWhenPushed = true
    }
    
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
        self.previewCircularProgress.hidden = false
        hideKeyboardCounterContainerView(true)
    }
    
    func startMainMode() {
        self.previewCircularProgress.hidden = true
        hideKeyboardCounterContainerView(false)
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
            UIView.animateWithDuration(1.0, animations: { 
                self.topKeyboardCounterConstraint.constant = self.view.frame.size.height - self.keyboardCounterContainerView.frame.size.height
                self.view.layoutSubviews()
                
                }, completion: { (finished: Bool) in
                    self.initTimer()
                    self.startTimer()
            })
        }
    }
    
    
    //MARK: Timer Methods
    
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
    
    func startTimer() {
        self.timer?.start()
    }
    
    func updateTimer() {
        self.currentMillisecondTime = self.currentMillisecondTime! - 0.01
        
        if self.currentMillisecondTime <= 0.0 {
            self.timer?.invalidate()
            
            if self.currentTotalCooldown == kCooldownForPreview {
                self.gameplayMode = .Main
            } else if self.currentTotalCooldown == kCooldownForMain {
                self.gameplayMode = .After
            }
        }
    }
}