//
//  GameplayMainViewController.swift
//  Docha
//
//  Created by Mathis D on 06/09/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import MBCircularProgressBar

enum TimelineState {
    case Perfect
    case Wrong
    case Current
    case Unplayed
}

enum MessageType {
    case perfect
    case less
    case more
}

class GameplayMainViewController: GameViewController, KeyboardViewDelegate, CounterContainerViewDelegate {
    
    var productsData: [Product]?
    var cardsViews: [CardProductView]?
    
    var currentProductData: Product?
    var currentPriceArray: [Int]?
    var currentCard: CardProductView?
    
    var userEstimation: [Int]?
    var userResultsArray: [TimelineState] = []
    var opponentResultArray: [TimelineState] = []
    
    var cursorCard: Int = 0
    var cursorCounter: Int = 0
    
    let kTimePerProduct: Double = 30.0
    var timer: NSTimer?
    var timeleft: Double!
    

//MARK: @IBOutlets
    
    // Top Container View
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var opponentAvatarImageView: UIImageView!
    @IBOutlet weak var circularProgressBarView: MBCircularProgressBarView!
    
    // Timeline
    @IBOutlet var userTimelineImageViewCollection: [UIImageView]!
    @IBOutlet var opponentTimelineImageViewCollection: [UIImageView]!
    
    // Card View
    @IBOutlet weak var cardContainerView: UIView!
    var cardCenterXConstraint: NSLayoutConstraint?
    
    // Keyboard View
    @IBOutlet weak var keyboardView: KeyboardView!
    
    
//MARK: Life View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardView.delegate = self
        
        initCardsView()
        initTimer(animated: false)
        startTimer()
        startTheRound()
    }
    
    func startTheRound() {
        moveToNextCard(cardsViews?.first, AndMovePreviousCard: nil, completion: nil)
        updateTimelineWithResult(.Current, isForUser: true)
    }
    
    func roundFinished() {
        let debriefVC = self.storyboard?.instantiateViewControllerWithIdentifier("idGameplayDebriefViewController") as! GameplayDebriefViewController
        debriefVC.productsList = productsData
        debriefVC.userResultsArray = userResultsArray
        self.navigationController?.pushViewController(debriefVC, animated: true)
    }
    
    
//MARK: Card Product Management
    
    func initCardsView() {
        var cardsArray: [CardProductView] = []
        
        for product in self.productsData! {
            let cardProductView = CardProductView.loadFromNibNamed("CardProductView") as? CardProductView
            let priceArray = ConverterHelper.convertPriceToArrayOfInt(product.price)
            let centsString = priceArray.centsString
            
            cardProductView?.productImageView.image = product.image
            cardProductView?.productNameLabel.text = product.model.uppercaseString
            cardProductView?.productBrandLabel.text = product.brand.uppercaseString
            cardProductView?.counterContainerView.centsLabel.text = centsString
            cardProductView?.counterContainerView.numberOfCounterDisplayed = priceArray.priceArray.count
            cardProductView?.counterContainerView.delegate = self
            print("Real price : \(product.price)")
            
            cardsArray.append(cardProductView!)
        }
        
        cardsViews = cardsArray
        currentCard?.productImageView.layer.borderColor = UIColor.redColor().CGColor
        currentCard?.productImageView.layer.borderWidth = 2.0
    }
    
    func moveToNextCard(nextCard: CardProductView!, AndMovePreviousCard previousCard: CardProductView?, completion: ((finished: Bool) -> Void)?) {
        if previousCard == nil {
            nextCard?.translatesAutoresizingMaskIntoConstraints = false
            cardContainerView.addSubview(nextCard)
            
            cardCenterXConstraint = NSLayoutConstraint(item: nextCard, attribute: .CenterX, relatedBy: .LessThanOrEqual, toItem: cardContainerView, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
            cardContainerView.addConstraint(cardCenterXConstraint!)
            cardContainerView.addConstraint(NSLayoutConstraint(item: nextCard, attribute: .CenterY, relatedBy: .Equal, toItem: cardContainerView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
            cardContainerView.addConstraint(NSLayoutConstraint(item: nextCard, attribute: .Height, relatedBy: .Equal, toItem: cardContainerView, attribute: .Height, multiplier: 1.0, constant: 0.0))
            cardContainerView.addConstraint(NSLayoutConstraint(item: nextCard, attribute: .Width, relatedBy: .Equal, toItem: cardContainerView, attribute: .Width, multiplier: 1.0, constant: 0.0))
            
        } else {
            nextCard.translatesAutoresizingMaskIntoConstraints = false
            let currentFrame = currentCard?.frame
            nextCard.frame = CGRectMake(self.view.frame.size.width, currentFrame!.origin.y, currentFrame!.width, currentFrame!.height)
            cardContainerView.addSubview(nextCard)
            
            let centerXNextCard = NSLayoutConstraint(item: nextCard, attribute: .CenterX, relatedBy: .Equal, toItem: cardContainerView, attribute: .CenterX, multiplier: 1.0, constant: self.view.frame.width)
            cardContainerView.addConstraint(centerXNextCard)
            cardContainerView.addConstraint(NSLayoutConstraint(item: nextCard, attribute: .CenterY, relatedBy: .Equal, toItem: cardContainerView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
            cardContainerView.addConstraint(NSLayoutConstraint(item: nextCard, attribute: .Height, relatedBy: .Equal, toItem: cardContainerView, attribute: .Height, multiplier: 1.0, constant: 0.0))
            cardContainerView.addConstraint(NSLayoutConstraint(item: nextCard, attribute: .Width, relatedBy: .Equal, toItem: cardContainerView, attribute: .Width, multiplier: 1.0, constant: 0.0))
            
            UIView.animateWithDuration(1.0,
                delay: 0.0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 10.0,
                options: .AllowUserInteraction,
                animations: {
                    self.cardCenterXConstraint?.constant = -CGFloat(self.view.frame.width)
                    centerXNextCard.constant = 0.0
                    self.view.layoutIfNeeded()
                }, completion: { (_) in
                    
            })
            
            cardCenterXConstraint = centerXNextCard
            cursorCard += 1
        }
        
        // Initialize current product data
        currentCard = nextCard
        currentPriceArray = ConverterHelper.convertPriceToArrayOfInt(self.productsData?[cursorCard].price).priceArray
        userEstimation = Array(count: (currentPriceArray?.count)!, repeatedValue: -1)
        currentProductData = productsData?[cursorCard]
        keyboardView.reset()
        
        completion?(finished: true)
    }
    
    func nextProductWithResult(result: TimelineState) {
        updateTimelineWithResult(result, isForUser: true)
        
        if cursorCard < cardsViews!.count-1 {
            // Display the next card
            let nextCard = cardsViews![cursorCard + 1]
            
            initTimer(animated: true)
            moveToNextCard(nextCard, AndMovePreviousCard: self.currentCard,
                completion: { (_) in
                    self.cursorCounter = 0
                    self.keyboardView.enabledKeyboard(true)
                    self.keyboardView.reset()
                    self.currentCard?.counterContainerView.resetCountersViews()
                    self.startTimer()
                    self.updateTimelineWithResult(.Current, isForUser: true)
            })
            
        } else {
            // Game Finished !
            timeleft = 0.0
            stopTimer()
            roundFinished()
        }
    }
    
    
//MARK: Timer Methods
    
    func initTimer(animated animated: Bool) {
        timeleft = kTimePerProduct
        if animated {
            UIView.animateWithDuration(1.0, animations: { 
                self.circularProgressBarView.value = CGFloat(self.timeleft!)
                self.view.layoutIfNeeded()
            })
            
        } else {
            self.circularProgressBarView.value = CGFloat(self.timeleft!)
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(GameplayMainViewController.updateTimer), userInfo: nil, repeats: true)
        
        circularProgressBarView.fontColor = UIColor.darkBlueDochaColor()
        circularProgressBarView.progressColor = UIColor.darkBlueDochaColor()
        circularProgressBarView.progressStrokeColor = UIColor.darkBlueDochaColor()
    }
    
    func startTimer() {
        timer?.start()
    }
    
    func updateTimer() {
        timeleft = timeleft! - 0.01
        circularProgressBarView.value = CGFloat(timeleft!)
        
        if Int(timeleft!) == 5 {
            animateTimer()
            
        } else if Int(timeleft!) == 0 {
            timesUp()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func timesUp() {
        stopTimer()
        nextProductWithResult(.Wrong)
    }
    
    func animateTimer() {
        self.circularProgressBarView.fontColor = UIColor.redDochaColor()
        self.circularProgressBarView.progressColor = UIColor.redDochaColor()
        self.circularProgressBarView.progressStrokeColor = UIColor.redDochaColor()
    }
    

//MARK: Timeline Methods
    
    func updateTimelineWithResult(result: TimelineState, isForUser: Bool) {
        var timelineImageName: String?
        
        switch result {
            case .Perfect:  timelineImageName = "timeline_perfect_found"; break
            case .Current:  timelineImageName = "timeline_encours"; break
            case .Wrong:    timelineImageName = "timeline_red_zone"; break
            case .Unplayed: timelineImageName = "timeline_unlock"; break
        }
        if isForUser {
            if let timelineImageName = timelineImageName {
                userTimelineImageViewCollection[cursorCard].image = UIImage(named: timelineImageName)
            }
            
            if result == .Perfect || result == .Wrong {
                userResultsArray.append(result)
            }
            
        } else {
            if let timelineImageName = timelineImageName {
                opponentTimelineImageViewCollection[cursorCard].image = UIImage(named: timelineImageName)
            }
            
            if result == .Perfect || result == .Wrong {
                opponentResultArray.append(result)
            }
        }
    }
    
    
//MARK: Counter Container View Delegate
    
    func infosButtonTouched() {
        PopupManager.sharedInstance.showInfosPopup("Informations prix", message: "Le prix de ce produit a été relevé le [DATE] sur le site internet [URL_RACINE].\n Images et copyright appartiennent à \((currentProductData?.brand)!)", viewController: self, completion: nil, doneActionCompletion: nil)
    }
    
    
//MARK: Keyboard Delegate
    
    func clickOnPadWithNumber(number: Int) {
        if cursorCounter == currentPriceArray?.count {
            return
        }
        
        currentCard?.counterContainerView.counterViewArray[cursorCounter].startCounterAnimationWithNumber(number: number, completion: nil)
        userEstimation![cursorCounter] = number
        cursorCounter += 1
        
        if cursorCounter == currentPriceArray?.count {
            keyboardView.enableValidButton(true)
        }
    }
    
    func validatePricing() {
        keyboardView.enabledKeyboard(false)
        
        animateUserPinIcon { (finished) in
            if finished {
                if self.userEstimation! == self.currentPriceArray! { // Perfect price
                    self.stopTimer()
                    self.nextProductWithResult(.Perfect)
                    
                } else {
                    self.cursorCounter = 0
                    self.keyboardView.enabledKeyboard(true)
                    self.keyboardView.reset()
                    self.currentCard?.counterContainerView.resetCountersViews()
                }
            }
        }
    }
    
    func eraseAllCounters() {
        currentCard?.counterContainerView.resetCountersViews()
        cursorCounter = 0
    }
    

//MARK: Displaying Message
    
    func displayMessage(messageType: MessageType, completion: ((finished: Bool) -> Void)?) {
        var messageName: String?
        switch messageType {
            case .perfect:  messageName = "perfect"; break
            case .less:     messageName = "less"; break
            case .more:     messageName = "more"; break
        }
        
        if let messageName = messageName {
            var messageImageView: UIImageView? = UIImageView(image: UIImage(named: "answer_\(messageName)"))
            messageImageView!.translatesAutoresizingMaskIntoConstraints = false
            currentCard?.addSubview(messageImageView!)
            
            currentCard?.addConstraint(NSLayoutConstraint(item: messageImageView!, attribute: .CenterX, relatedBy: .Equal, toItem: currentCard, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
            currentCard?.addConstraint(NSLayoutConstraint(item: messageImageView!, attribute: .CenterY, relatedBy: .Equal, toItem: currentCard, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
            
            UIView.animateWithDuration(1.0,
                animations: {
                    messageImageView!.alpha = 0.0
                },
                completion: { (finished) in
                    messageImageView!.removeFromSuperview()
                    messageImageView = nil
                    
                    completion?(finished: finished)
            })
        }
    }
    

//MARK: Gauge Methods
    
    func animateUserPinIcon(completion: ((finished: Bool) -> Void)?) {
        let errorPercent = calculateUserEstimationErrorPercent()
        currentCard?.updatePinIconPositionWithErrorPercent(errorPercent,
            completion: { (finished) in
                if errorPercent < 0 {
                    self.displayMessage(.more, completion: { (finished) in
                        completion?(finished: finished)
                    })
                    
                } else if errorPercent > 0 {
                    self.displayMessage(.less, completion: { (finished) in
                        completion?(finished: finished)
                    })
                    
                } else {
                    self.displayMessage(.perfect, completion: { (finished) in
                        completion?(finished: finished)
                    })
                }
        })
    }
    
    func calculateUserEstimationErrorPercent() -> Double {
        let kErrorPercent = 0.36
        let userEstimation = Double(ConverterHelper.convertPriceArrayToInt(self.userEstimation!))
        let realPrice = Double(ConverterHelper.convertPriceArrayToInt(currentPriceArray!))
        
        if userEstimation == realPrice {
            // Perfect price !
            return 0.0
            
        } else {
            let priceMax = realPrice + realPrice * kErrorPercent
            let priceMin = realPrice - realPrice * kErrorPercent
            
            if case priceMin...priceMax = userEstimation {
                let errorRange = abs(realPrice-userEstimation)
                let delta = priceMax - realPrice
                let errorPercent = errorRange / delta
                
                if userEstimation > realPrice {
                    return errorPercent
                } else {
                    return -errorPercent
                }
                
            } else {
                if userEstimation > priceMax {
                    return 100.0
                    
                } else {
                    return -100.0
                }
            }
        }
    }
}