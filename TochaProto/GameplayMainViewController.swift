//
//  GameplayMainViewController.swift
//  Docha
//
//  Created by Mathis D on 06/09/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import MBCircularProgressBar

enum TimelineState {
    case perfect
    case wrong
    case current
    case unplayed
}

enum MessageType {
    case perfect
    case less
    case more
    case go
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
    var timer: Timer?
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
        startTheRound()
    }
    
    func startTheRound() {
        moveToNextCard(cardsViews?.first, AndMovePreviousCard: nil,
            completion: { (_) in
                self.displayMessage(MessageType.go, completion: nil)
            }
        )
        updateTimelineWithResult(.current, isForUser: true)
    }
    
    func roundFinished() {
        let debriefVC = self.storyboard?.instantiateViewController(withIdentifier: "idGameplayDebriefViewController") as! GameplayDebriefViewController
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
            cardProductView?.productNameLabel.text = product.model.uppercased()
            cardProductView?.productBrandLabel.text = product.brand.uppercased()
            cardProductView?.counterContainerView.centsLabel.text = centsString
            cardProductView?.counterContainerView.numberOfCounterDisplayed = priceArray.priceArray.count
            cardProductView?.counterContainerView.delegate = self
            print("Real price : \(product.price)")
            
            cardsArray.append(cardProductView!)
        }
        
        cardsViews = cardsArray
    }
    
    func moveToNextCard(_ nextCard: CardProductView!, AndMovePreviousCard previousCard: CardProductView?, completion: ((_ finished: Bool) -> Void)?) {
        if previousCard == nil {
            nextCard?.translatesAutoresizingMaskIntoConstraints = false
            nextCard.frame = cardContainerView.frame
            cardContainerView.addSubview(nextCard)
            
            cardCenterXConstraint = NSLayoutConstraint(item: nextCard, attribute: .centerX, relatedBy: .lessThanOrEqual, toItem: cardContainerView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
            cardContainerView.addConstraint(cardCenterXConstraint!)
            cardContainerView.addConstraint(NSLayoutConstraint(item: nextCard, attribute: .centerY, relatedBy: .equal, toItem: cardContainerView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
            cardContainerView.addConstraint(NSLayoutConstraint(item: nextCard, attribute: .height, relatedBy: .equal, toItem: cardContainerView, attribute: .height, multiplier: 1.0, constant: 0.0))
            cardContainerView.addConstraint(NSLayoutConstraint(item: nextCard, attribute: .width, relatedBy: .equal, toItem: cardContainerView, attribute: .width, multiplier: 1.0, constant: 0.0))
            completion?(true)
            
        } else {
            nextCard.translatesAutoresizingMaskIntoConstraints = false
            let currentFrame = currentCard?.frame
            nextCard.frame = CGRect(x: self.view.frame.size.width, y: currentFrame!.origin.y, width: currentFrame!.width, height: currentFrame!.height)
            cardContainerView.addSubview(nextCard)
            
            let centerXNextCard = NSLayoutConstraint(item: nextCard, attribute: .centerX, relatedBy: .equal, toItem: cardContainerView, attribute: .centerX, multiplier: 1.0, constant: self.view.frame.width)
            cardContainerView.addConstraint(centerXNextCard)
            cardContainerView.addConstraint(NSLayoutConstraint(item: nextCard, attribute: .centerY, relatedBy: .equal, toItem: cardContainerView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
            cardContainerView.addConstraint(NSLayoutConstraint(item: nextCard, attribute: .height, relatedBy: .equal, toItem: cardContainerView, attribute: .height, multiplier: 1.0, constant: 0.0))
            cardContainerView.addConstraint(NSLayoutConstraint(item: nextCard, attribute: .width, relatedBy: .equal, toItem: cardContainerView, attribute: .width, multiplier: 1.0, constant: 0.0))
            
            UIView.animate(withDuration: 1.0,
                delay: 0.0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 10.0,
                options: .allowUserInteraction,
                animations: {
                    
                    self.cardCenterXConstraint?.constant = -CGFloat(self.view.frame.width)
                    centerXNextCard.constant = 0.0
                    self.view.layoutIfNeeded()
                    
                }, completion: { (finished) in
                    if finished {
                        completion?(true)
                        
                    } else {
                        completion?(false)
                    }
            })
            
            cardCenterXConstraint = centerXNextCard
            cursorCard += 1
        }
        
        // Initialize/Update current product data
        currentCard = nextCard
        currentPriceArray = ConverterHelper.convertPriceToArrayOfInt(self.productsData?[cursorCard].price).priceArray
        userEstimation = Array(repeating: -1, count: (currentPriceArray?.count)!)
        currentProductData = productsData?[cursorCard]
        keyboardView.reset()
        
        completion?(true)
    }
    
    func nextProductWithResult(_ result: TimelineState) {
        updateTimelineWithResult(result, isForUser: true)
        
        if cursorCard < cardsViews!.count-1 {
            // Display the next card
            let nextCard = cardsViews![cursorCard + 1]
            
            moveToNextCard(nextCard, AndMovePreviousCard: self.currentCard,
                completion: { (_) in
                    self.cursorCounter = 0
                    self.keyboardView.enabledKeyboard(true)
                    self.keyboardView.reset()
                    self.currentCard?.counterContainerView.resetCountersViews()
                    self.updateTimelineWithResult(.current, isForUser: true)
                    self.initTimer(animated: true)
                }
            )
            
        } else {
            // Game Finished !
            timeleft = 0.0
            stopTimer()
            roundFinished()
        }
    }
    
    
//MARK: Timer Methods
    
    func initTimer(animated: Bool) {
        timeleft = kTimePerProduct
        
        if animated {
            UIView.animate(withDuration: 1.0,
                animations: {
                    self.circularProgressBarView.value = CGFloat(self.timeleft!)
                    self.view.layoutIfNeeded()
                }
            )
            
        } else {
            circularProgressBarView.value = CGFloat(self.timeleft!)
        }
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(GameplayMainViewController.updateTimer), userInfo: nil, repeats: true)
        
        circularProgressBarView.fontColor = UIColor.darkBlueDochaColor()
        circularProgressBarView.progressColor = UIColor.darkBlueDochaColor()
        circularProgressBarView.progressStrokeColor = UIColor.darkBlueDochaColor()
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
        nextProductWithResult(.wrong)
    }
    
    func animateTimer() {
        circularProgressBarView.fontColor = UIColor.redDochaColor()
        circularProgressBarView.progressColor = UIColor.redDochaColor()
        circularProgressBarView.progressStrokeColor = UIColor.redDochaColor()
    }
    

//MARK: Timeline Methods
    
    func updateTimelineWithResult(_ result: TimelineState, isForUser: Bool) {
        var timelineImageName: String?
        
        switch result {
            case .perfect:  timelineImageName = "timeline_perfect_found"; break
            case .current:  timelineImageName = "timeline_encours"; break
            case .wrong:    timelineImageName = "timeline_red_zone"; break
            case .unplayed: timelineImageName = "timeline_unlock"; break
        }
        if isForUser {
            if let timelineImageName = timelineImageName {
                userTimelineImageViewCollection[cursorCard].image = UIImage(named: timelineImageName)
            }
            
            if result == .perfect || result == .wrong {
                userResultsArray.append(result)
            }
            
        } else {
            if let timelineImageName = timelineImageName {
                opponentTimelineImageViewCollection[cursorCard].image = UIImage(named: timelineImageName)
            }
            
            if result == .perfect || result == .wrong {
                opponentResultArray.append(result)
            }
        }
    }
    
    
//MARK: Counter Container View Delegate
    
    func infosButtonTouched() {
        PopupManager.sharedInstance.showInfosPopup("Informations prix", message: "Le prix de ce produit a été relevé le [DATE] sur le site internet [URL_RACINE].\n Images et copyright appartiennent à \((currentProductData?.brand)!)", viewController: self, completion: nil, doneActionCompletion: nil)
    }
    
    
//MARK: Keyboard Delegate
    
    func clickOnPadWithNumber(_ number: Int) {
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
                    self.nextProductWithResult(.perfect)
                    
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
    
    func displayMessage(_ messageType: MessageType, completion: ((_ finished: Bool) -> Void)?) {
        var messageName: String?
        switch messageType {
            case .perfect:  messageName = "perfect"; break
            case .less:     messageName = "less"; break
            case .more:     messageName = "more"; break
            case .go:       messageName = "go"; break
        }
        
        if let messageName = messageName {
            var messageImageView: UIImageView? = UIImageView(image: UIImage(named: "answer_\(messageName)"))
            messageImageView!.translatesAutoresizingMaskIntoConstraints = false
            currentCard?.addSubview(messageImageView!)
            
            currentCard?.addConstraint(NSLayoutConstraint(item: messageImageView!, attribute: .centerX, relatedBy: .equal, toItem: currentCard, attribute: .centerX, multiplier: 1.0, constant: 0.0))
            currentCard?.addConstraint(NSLayoutConstraint(item: messageImageView!, attribute: .centerY, relatedBy: .equal, toItem: currentCard, attribute: .centerY, multiplier: 1.0, constant: 0.0))
            
            UIView.animate(withDuration: 1.0,
                animations: {
                    messageImageView!.alpha = 0.0
                    self.view.layoutIfNeeded()
                },
                completion: { (finished) in
                    messageImageView!.removeFromSuperview()
                    messageImageView = nil
                    
                    completion?(finished)
                }
            )
        }
    }
    

//MARK: Gauge Methods
    
    func animateUserPinIcon(_ completion: ((_ finished: Bool) -> Void)?) {
        let errorPercent = calculateUserEstimationErrorPercent()
        currentCard?.updatePinIconPositionWithErrorPercent(errorPercent,
            completion: { (finished) in
                
                if errorPercent < 0 {
                    self.displayMessage(.more,
                        completion: { (finished) in
                            
                            completion?(finished)
                        }
                    )
                    
                } else if errorPercent > 0 {
                    self.displayMessage(.less,
                        completion: { (finished) in
                            
                            completion?(finished)
                        }
                    )
                    
                } else {
                    self.displayMessage(.perfect,
                        completion: { (finished) in
                            
                            completion?(finished)
                        }
                    )
                }
            }
        )
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
