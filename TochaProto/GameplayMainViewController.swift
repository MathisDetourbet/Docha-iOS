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

class GameplayMainViewController: GameViewController, KeyboardViewDelegate, CounterContainerViewDelegate {
    
    var productsData: [Product]?
    var cardsViews: [CardProductView]?
    
    var currentProductData: Product?
    var currentPriceArray: [Int]?
    var currentCard: CardProductView?
    
    var userEstimation: [Int]?
    
    var messageLabel:UILabel?
    
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
        
        self.keyboardView.delegate = self
        
        self.currentCard?.addSubview(messageLabel!)
        
        initCardsView()
        initTimer(false)
        startTimer()
        startTheGame()
        
        messageLabel = UILabel(frame: CGRectMake(self.currentCard!.frame.midX - 150.0, self.currentCard!.frame.midY - 100.0, 200.0, 50.0))
        messageLabel!.font = UIFont(name: "Montserrat-ExtraBold", size: 25.0)
    }
    
    
//MARK: Card Product Management
    
    func initCardsView() {
        var cardsArray: [CardProductView] = []
        
        for product in self.productsData! {
            let cardProductView = CardProductView.loadFromNibNamed("CardProductView") as? CardProductView
            let priceArray = convertPriceToArrayOfInt(product.price)
            let centsString = priceArray.centsString
            
            cardProductView?.productImageView.image = product.image
            cardProductView?.productImageView.layer.cornerRadius = 18.0
            cardProductView?.productImageView.layer.masksToBounds = false
            cardProductView?.productImageView.clipsToBounds = true
            cardProductView?.productNameLabel.text = product.model.uppercaseString
            cardProductView?.productBrandLabel.text = product.brand.uppercaseString
            cardProductView?.firstTagLabel.text = "# \(product.caracteristiques[0])"
            cardProductView?.secondTagLabel.text = "# \(product.caracteristiques[1])"
            cardProductView?.counterContainerView.centsLabel.text = centsString
            cardProductView?.counterContainerView.numberOfCounterDisplayed = priceArray.priceArray.count
            cardProductView?.counterContainerView.delegate = self
            print("Real price : \(product.price)")
            
            cardsArray.append(cardProductView!)
        }
        
        self.cardsViews = cardsArray
    }
    
    func moveToNextCard(nextCard: CardProductView!, AndMovePreviousCard previousCard: CardProductView?, completion: ((finished: Bool) -> Void)?) {
        if previousCard == nil {
            nextCard?.translatesAutoresizingMaskIntoConstraints = false
            self.cardContainerView.addSubview(nextCard)
            
            self.cardCenterXConstraint = NSLayoutConstraint(item: nextCard, attribute: .CenterX, relatedBy: .LessThanOrEqual, toItem: cardContainerView, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
            self.cardContainerView.addConstraint(cardCenterXConstraint!)
            self.cardContainerView.addConstraint(NSLayoutConstraint(item: nextCard, attribute: .CenterY, relatedBy: .Equal, toItem: cardContainerView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
            self.cardContainerView.addConstraint(NSLayoutConstraint(item: nextCard, attribute: .Height, relatedBy: .Equal, toItem: cardContainerView, attribute: .Height, multiplier: 1.0, constant: 0.0))
            self.cardContainerView.addConstraint(NSLayoutConstraint(item: nextCard, attribute: .Width, relatedBy: .Equal, toItem: cardContainerView, attribute: .Width, multiplier: 1.0, constant: 0.0))
            
        } else {
            nextCard.translatesAutoresizingMaskIntoConstraints = false
            let currentFrame = self.currentCard?.frame
            nextCard.frame = CGRectMake(self.view.frame.size.width, currentFrame!.origin.y, currentFrame!.width, currentFrame!.height)
            self.cardContainerView.addSubview(nextCard)
            
            let centerXNextCard = NSLayoutConstraint(item: nextCard, attribute: .CenterX, relatedBy: .Equal, toItem: cardContainerView, attribute: .CenterX, multiplier: 1.0, constant: self.view.frame.width)
            self.cardContainerView.addConstraint(centerXNextCard)
            self.cardContainerView.addConstraint(NSLayoutConstraint(item: nextCard, attribute: .CenterY, relatedBy: .Equal, toItem: cardContainerView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
            self.cardContainerView.addConstraint(NSLayoutConstraint(item: nextCard, attribute: .Height, relatedBy: .Equal, toItem: cardContainerView, attribute: .Height, multiplier: 1.0, constant: 0.0))
            self.cardContainerView.addConstraint(NSLayoutConstraint(item: nextCard, attribute: .Width, relatedBy: .Equal, toItem: cardContainerView, attribute: .Width, multiplier: 1.0, constant: 0.0))
            
            UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10.0, options: .AllowUserInteraction, animations: {
                self.cardCenterXConstraint?.constant = -CGFloat(self.view.frame.width)
                centerXNextCard.constant = 0.0
                self.view.layoutIfNeeded()
                }, completion: { (_) in
                    
            })
            
            self.cardCenterXConstraint = centerXNextCard
            self.cursorCard += 1
        }
        
        // Initialize current product data
        self.currentCard = nextCard
        self.currentPriceArray = convertPriceToArrayOfInt(self.productsData?[cursorCard].price).priceArray
        self.userEstimation = Array(count: (self.currentPriceArray?.count)!, repeatedValue: -1)
        self.currentProductData = self.productsData?[cursorCard]
        self.keyboardView.reset()
        
        completion?(finished: true)
    }
    
    func startTheGame() {
        moveToNextCard(self.cardsViews?.first, AndMovePreviousCard: nil, completion: nil)
        updateTimelineWithResult(.Current, isForUser: true)
    }
    
    func gameFinished() {
        let debriefVC = self.storyboard?.instantiateViewControllerWithIdentifier("") as! GameplayDebriefViewController
        debriefVC.productsList = self.productsData
        self.navigationController?.pushViewController(debriefVC, animated: true)
    }
    
    func nextProductWithResult(result: TimelineState) {
        if self.cursorCard < self.cardsViews!.count-1 {
            // Display the next card
            let nextCard = self.cardsViews![self.cursorCard + 1]
            updateTimelineWithResult(result, isForUser: true)
            
            self.initTimer(true)
            self.moveToNextCard(nextCard, AndMovePreviousCard: self.currentCard, completion: { (_) in
                self.cursorCounter = 0
                self.keyboardView.enabledKeyboard(true)
                self.keyboardView.reset()
                self.currentCard?.counterContainerView.resetCountersViews()
                self.startTimer()
                self.updateTimelineWithResult(.Current, isForUser: true)
            })
            
        } else {
            // Game Finished !
            self.timeleft = 0.0
            stopTimer()
            gameFinished()
        }
    }
    
    
//MARK: Timer Methods
    
    func initTimer(animated: Bool) {
        self.timeleft = kTimePerProduct
        if animated {
            UIView.animateWithDuration(1.0, animations: { 
                self.circularProgressBarView.value = CGFloat(self.timeleft!)
                self.view.layoutIfNeeded()
            })
            
        } else {
            self.circularProgressBarView.value = CGFloat(self.timeleft!)
        }
        
        self.timer = NSTimer.new(every: 10.milliseconds, { (timer: NSTimer) in
            if Int(self.timeleft) == 0  {
                self.timesUp()
                timer.invalidate()
                
            } else {
                self.updateTimer()
            }
        })
        
        self.circularProgressBarView.fontColor = UIColor.darkBlueDochaColor()
        self.circularProgressBarView.progressColor = UIColor.darkBlueDochaColor()
        self.circularProgressBarView.progressStrokeColor = UIColor.darkBlueDochaColor()
    }
    
    func startTimer() {
        self.timer?.start()
    }
    
    func updateTimer() {
        self.timeleft = self.timeleft! - 0.01
        self.circularProgressBarView.value = CGFloat(self.timeleft!)
        
        if Int(self.timeleft!) == 5 {
            animateTimer()
        }
    }
    
    func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func timesUp() {
        self.stopTimer()
        updateTimelineWithResult(.Wrong, isForUser: true)
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
                self.userTimelineImageViewCollection[cursorCard].image = UIImage(named: timelineImageName)
            }
            
        } else {
            if let timelineImageName = timelineImageName {
                self.opponentTimelineImageViewCollection[cursorCard].image = UIImage(named: timelineImageName)
            }
        }
    }
    
    
//MARK: Counter Container View Delegate
    
    func infosButtonTouched() {
        PopupManager.sharedInstance.showInfosPopup("Informations prix", message: "Le prix de ce produit a été relevé le [DATE] sur le site internet [URL_RACINE].\n Images et copyright appartiennent à \((currentProductData?.brand)!)", viewController: self, completion: nil, doneActionCompletion: nil)
    }
    
    
//MARK: Keyboard Delegate
    
    func clickOnPadWithNumber(number: Int) {
        if cursorCounter == self.currentPriceArray?.count {
            return
        }
        
        self.currentCard?.counterContainerView.counterViewArray[cursorCounter].startCounterAnimationWithNumber(number: number, completion: nil)
        self.userEstimation![cursorCounter] = number
        cursorCounter += 1
        
        if cursorCounter == currentPriceArray?.count {
            self.keyboardView.enableValidButton(true)
        }
    }
    
    func validatePricing() {
        self.keyboardView.enabledKeyboard(false)
        
        animateUserPinIcon { (finished) in
            if finished {
                if self.userEstimation! == self.currentPriceArray! {
                    // Perfect price
                    self.updateTimelineWithResult(.Perfect, isForUser: true)
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
        self.currentCard?.counterContainerView.resetCountersViews()
        self.cursorCounter = 0
    }
    

//MARK: Gauge Methods
    
    func animateUserPinIcon(completion: ((finished: Bool) -> Void)?) {
        let errorPercent = calculateUserEstimationErrorPercent()
        self.currentCard?.updatePinIconPositionWithErrorPercent(errorPercent, completion: { (finished) in
            if errorPercent < 0 {
                self.messageLabel!.text = "Trop bas !"
                self.messageLabel?.textColor = UIColor.redDochaColor()
                
            } else if errorPercent > 0 {
                self.messageLabel!.text = "Trop haut"
                self.messageLabel?.textColor = UIColor.greenDochaColor()
                
            } else {
                self.messageLabel!.text = "Perfect price !"
            }
            
            completion?(finished: finished)
        })
    }
    
    func calculateUserEstimationErrorPercent() -> Double {
        let kErrorPercent = 0.36
        let userEstimation = Double(convertPriceArrayToInt(self.userEstimation!))
        let realPrice = Double(convertPriceArrayToInt(self.currentPriceArray!))
        
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
    
    
//MARK: Helpers Methods
    
    func convertPriceToArrayOfInt(price: Double!) -> (priceArray: [Int], centsString: String) {
        let string = String(price)
        let eurosAndCentsArray = string.characters.split{$0 == "."}.map(String.init)
        
        let eurosString = String(eurosAndCentsArray[0])
        let eurosArray = eurosString.characters.flatMap{Int(String($0))}
        
        var centsString = String(eurosAndCentsArray[1])
        if centsString.characters.count == 1 {
            centsString += "0"
        }
        
        return (eurosArray, centsString)
    }
    
    func convertPriceArrayToInt(psyPriceArray: [Int]) -> Int {
        var psyPriceInt = 0
        let reversePsyPriceArray = Array(psyPriceArray.reverse())
        for index in 0...reversePsyPriceArray.count-1 {
            psyPriceInt += reversePsyPriceArray[index] * Int(pow(Double(10), Double(index)))
        }
        
        return psyPriceInt
    }
}