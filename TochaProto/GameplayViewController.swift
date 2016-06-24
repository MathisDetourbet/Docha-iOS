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

enum EstimationResult {
    case Perfect
    case Amazing
    case Great
    case Oups
}

class GameplayViewController: RootViewController, KeyboardViewDelegate {
    
    var productsList: [Product]?
    var currentProduct: Product?
    var currentPriceInArray: ([Int], String)?
    var currentNumberOfCounter: Int? {
        didSet {
            if currentNumberOfCounter == 2 {
                counterContainerView.hideCounterView()
            }
        }
    }
    
    var cursorProduct: Int = 0 {
        didSet {
            currentProduct = productsList![cursorProduct]
        }
    }
    var cursorCounter: Int = 0
    
    let kCooldownForPreview: Double! = 3.0
    let kCooldownForMain: Double! = 5.0
    let kCooldownForAfter: Double! = 3.0
    var currentTotalCooldown: Double? {
        didSet {
            self.currentMillisecondTime = currentTotalCooldown
        }
    }
    var currentMillisecondTime: Double? {
        didSet {
            if self.gameplayMode == .Preview {
                self.previewCircularProgress.value = CGFloat(Double(self.currentMillisecondTime! * 100.0) / self.currentTotalCooldown!)
            } else if gameplayMode == .Main || gameplayMode == .After {
                self.mainCircularProgress.value = CGFloat(Double(self.currentMillisecondTime! * 100.0) / self.currentTotalCooldown!)
            }
        }
    }
    var timer: NSTimer?
    var timerFinished: Bool = true
    
    var gameplayMode: GameplayMode! = .Preview {
        didSet {
            self.startGameplayMode(gameplayMode)
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
    @IBOutlet weak var bottomFeaturesLabelsContainer: UIView!
    @IBOutlet var featuresLabelsCollection: [UILabel]!
    
    @IBOutlet weak var keyboardCounterContainerView: UIView!
    @IBOutlet weak var keyboardContainerView: KeyboardView!
    @IBOutlet weak var counterContainerView: CounterContainerView!
    @IBOutlet weak var afterView: AfterView!
    @IBOutlet weak var timelineView: TimelineView!
    
    
    //MARK: @IBOutlets Constraints
    
    // Product ImageView Constraints
    @IBOutlet weak var topProductImageViewConstraint: NSLayoutConstraint!
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
        
        if !isProductListLoaded() {
            print("Error : products are not loaded... productsList.count = \(self.productsList?.count))")
            goToHome()
            return
        }
        
        self.keyboardContainerView.delegate = self
        configureView()
        cursorProduct = 0
        startGameplayMode(self.gameplayMode)
    }
    
    func configureView() {
        self.hidesBottomBarWhenPushed = true
        self.heightFeaturesContainerConstraint.constant = self.view.frame.height - (self.topInfosContainerView.frame.height + self.productImageView.frame.height)
        self.widthInfosContainerConstraint.constant = self.view.frame.width - (self.view.frame.width - self.previewCircularProgress.frame.origin.x)
        self.view.layoutIfNeeded()
    }
    
    func isProductListLoaded() -> Bool {
        if self.productsList?.count == 5 {
            return true
        } else {
            return false
        }
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
        hideKeyboardCounterContainerView(true)
        
        // On enchaine avec un nouveau produit -> on efface la vue after
        if cursorProduct > 0 {
            self.counterContainerView.resetCountersViews()
            self.timelineView.nextStepWithCounterViewAfterTypeArray(self.afterView.counterViewTypeArray)
            self.afterView.alpha = 0.0
            self.topInfosContainerView.alpha = 0.0
            self.bottomFeaturesContainer.alpha = 0.0
            
            self.previewCircularProgress.hidden = false
            
            self.topInfosContainerConstraint.constant = 0.0
            self.widthInfosContainerConstraint.constant = self.view.frame.width - (self.view.frame.width - self.previewCircularProgress.frame.origin.x)
            
            self.topProductImageViewConstraint.constant = self.topInfosContainerView.frame.height
            self.heightProductImageViewConstraint.constant = 285.0
            self.view.layoutIfNeeded()
            
            self.leadingFeaturesContainerConstraint.constant = 0.0
            self.heightFeaturesContainerConstraint.constant = self.view.frame.height - (self.topInfosContainerView.frame.height + self.productImageView.frame.height)
            self.view.layoutIfNeeded()
            
            self.topFeaturesContainerConstraint.constant = self.topInfosContainerView.frame.height + self.productImageView.frame.height
            self.topFeaturesSubContainerConstraint.constant = (self.bottomFeaturesContainer.frame.height - self.bottomFeaturesLabelsContainer.frame.height) / 2
            
            UIView.animateWithDuration(0.5, animations: { 
                self.topInfosContainerView.alpha = 1.0
                self.bottomFeaturesContainer.alpha = 1.0
                self.initTimer()
                self.startTimer()
            })

            self.view.layoutIfNeeded()
            
        } else {
            initTimer()
            startTimer()
            timelineView.initTimeline()
            previewCircularProgress.hidden = false
        }
        
        productNameLabel.text = currentProduct?.model
        productBrandLabel.text = currentProduct?.brand
        productImageView.image = currentProduct?.image
        if currentProduct?.caracteristiques.count > 0 {
            for index in 0...(currentProduct?.caracteristiques.count)!-1 {
                if index >= 3 {
                    continue
                }
                self.featuresLabelsCollection[index].text = currentProduct?.caracteristiques[index]
            }
        }
        currentPriceInArray = convertPriceToArrayOfInt((currentProduct?.price)!)
        counterContainerView.centsLabel.text = currentPriceInArray?.1
    }
    
    func startMainMode() {
        self.cursorCounter = 0
        counterContainerView.initCountersViews()
        
        self.previewCircularProgress.hidden = true
        hideKeyboardCounterContainerView(false)
        
        self.topInfosContainerView.alpha = 0.0
        self.bottomFeaturesContainer.alpha = 0.0
        
        self.topProductImageViewConstraint.constant = 0.0
        self.heightProductImageViewConstraint.constant = 0.229 * self.view.frame.height
        self.view.layoutIfNeeded()
        
        self.topInfosContainerConstraint.constant = self.productImageView.frame.height
        self.widthInfosContainerConstraint.constant = self.view.frame.width / 2
        
        self.leadingFeaturesContainerConstraint.constant = self.view.frame.width / 2
        self.topFeaturesContainerConstraint.constant = self.productImageView.frame.height
        self.heightFeaturesContainerConstraint.constant = self.view.frame.height - (self.keyboardContainerView.frame.height + self.productImageView.frame.height)
        self.topFeaturesSubContainerConstraint.constant = 8.0
        
        UIView.animateWithDuration(0.5) { 
            self.topInfosContainerView.alpha = 1.0
            self.bottomFeaturesContainer.alpha = 1.0
        }
        
        self.view.layoutIfNeeded()
    }
    
    func startAfterMode() {
        UIView.animateWithDuration(0.5) { 
            self.afterView.alpha = 1.0
        }
        initTimer()
        startTimer()
    }
    
    func startDebriefMode() {
        let debriefVC = self.storyboard?.instantiateViewControllerWithIdentifier("idDebriefViewController") as! GameplayDebriefViewController
        debriefVC.productsPlayed = self.productsList
        debriefVC.timelineView = self.timelineView
        self.navigationController?.pushViewController(debriefVC, animated: true)
    }
    
    func hideKeyboardCounterContainerView(hide: Bool) {
        self.keyboardCounterContainerView.hidden = hide
        
        if hide {
            self.topKeyboardCounterConstraint.constant = self.view.frame.height
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
                    if finished {
                        self.initTimer()
                        self.startTimer()
                    }
            })
        }
    }
    
    
    //MARK: Timer Methods
    
    func startTimer() {
        self.timerFinished = false
        self.timer?.start()
    }
    
    func stopTimer() {
        self.timerFinished = true
        self.timer?.invalidate()
        //self.timer = nil
    }
    
    func initTimer() {
        if gameplayMode == .Preview {
            currentTotalCooldown = kCooldownForPreview
            previewCircularProgress.initProgressBar()
            
        } else if gameplayMode == .Main {
            currentTotalCooldown = kCooldownForMain
            mainCircularProgress.initProgressBar()
            
        } else if gameplayMode == .After {
            currentTotalCooldown = kCooldownForAfter
            mainCircularProgress.initProgressBar()
        }
        
        currentMillisecondTime = currentTotalCooldown
        timer = NSTimer.new(every: 0.01, { (timer: NSTimer) in
            if self.timerFinished {
                timer.invalidate()
            }
            self.updateTimer()
        })
    }
    
    func updateTimer() {
        currentMillisecondTime = currentMillisecondTime! - 0.01
        
        if currentMillisecondTime <= 0.0 {
            stopTimer()
            
            if gameplayMode == .Preview {
                gameplayMode = .Main
                
            } else if gameplayMode == .Main {
                validatePricing()
                
            } else if (gameplayMode == .After) && (cursorProduct == productsList!.count-1) {
                gameplayMode = .Debrief
                
            } else if gameplayMode == .After {
                self.cursorProduct += 1
                gameplayMode = .Preview
            }
        }
    }
    
    
    //MARK: Keyboard Action Methods
    
    func clickOnPadWithNumber(number: Int) {
        if cursorCounter == counterContainerView.numberOfCounterDisplayed {
            return
        }
        
        let cursor = self.counterContainerView.numberOfCounterDisplayed == 2 ? self.cursorCounter+1 : self.cursorCounter
        print("cursor counterview to animate : \(cursor)")
        
        self.counterContainerView.counterViewArray[cursor].startCounterAnimationWithNumber(number: number)
        { (finished) in
            
            if self.cursorCounter <= self.counterContainerView.numberOfCounterDisplayed {
                self.counterContainerView.numbersArray![self.cursorCounter] = number
                self.cursorCounter += 1
            }
        }
    }
    
    func validatePricing() {
        self.stopTimer()
        
        var counterViewTypeArray: [CounterViewAfterType] = []
        let counterNumberArray = self.counterContainerView.numbersArray!
        
        if counterNumberArray == currentPriceInArray!.0 {
            // Perfect price !
            for _ in 0...counterNumberArray.count-1 {
                counterViewTypeArray.append(CounterViewAfterType.Perfect)
            }
            
            afterView.displayEstimationResults(counterViewTypeArray)
            counterContainerView.revealCounterViewAfterWithArrayType(counterViewTypeArray)
            self.afterView.estimationResult = .Perfect
            self.gameplayMode == .After
            self.afterView.counterViewTypeArray = counterViewTypeArray
            
            return
        }
        
        for index in 0...counterNumberArray.count-1 {
            
            if counterNumberArray[index] == currentPriceInArray!.0[index] {
                counterViewTypeArray.append(CounterViewAfterType.Green)
                
            } else {
                counterViewTypeArray.append(CounterViewAfterType.Red)
            }
        }
        afterView.displayEstimationResults(counterViewTypeArray)
        counterContainerView.revealCounterViewAfterWithArrayType(counterViewTypeArray)
        self.afterView.counterViewTypeArray = counterViewTypeArray
        gameplayMode = .After
    }
    
    func eraseAllCounters() {
        self.counterContainerView.resetCountersViews()
        cursorCounter = 0
    }
    
    
    //MARK: Helpers Methods
    
    func convertPriceToArrayOfInt(price: Double!) -> ([Int], String) {
        let string = String(price)
        let eurosAndCentsArray = string.characters.split{$0 == "."}.map(String.init)
        
        let eurosString = String(eurosAndCentsArray[0])
        let eurosArray = eurosString.characters.flatMap{Int(String($0))}
        
        var centsString = String(eurosAndCentsArray[1])
        if centsString.characters.count == 1 {
            centsString += "0"
        }
        
        if price >= 10 {
            if price >= 100 && price < 1000 {
                currentNumberOfCounter = 3
                self.counterContainerView.numberOfCounterDisplayed = currentNumberOfCounter!
            } else {
                currentNumberOfCounter = 2
                self.counterContainerView.numberOfCounterDisplayed = currentNumberOfCounter!
            }
        }
        
        return (eurosArray, centsString)
    }
}