//
//  GameplayMainViewController.swift
//  Docha
//
//  Created by Mathis D on 06/09/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import MBCircularProgressBar
import Kingfisher

enum TimelineState {
    case perfect
    case wrong
    case current
    case unplayed
}

enum MessageType: String {
    case perfect = "perfect"
    case less = "less"
    case more = "more"
    case go = "go"
    case timeIsUp = "timeup"
    case great = "great"
    case justInTime = "justintime"
}

class GameplayMainViewController: GameViewController, KeyboardViewDelegate, CounterContainerViewDelegate {
    
    var userPlayer: Player?
    var opponentPlayer: Player?
    var round: RoundFull!
    
    var cardsViews: [CardProductView]?
    
    var currentProductData: Product?
    var currentPriceArray: [Int]?
    var currentCard: CardProductView?
    
    var userEstimation: [Int]?
    var opponentResultArray: [TimelineState] = []
    
    var cursorCard: Int = 0
    var cursorCounter: Int = 0
    
    let kTimePerRound: Double = 60.0
    var timer: Timer?
    var timeleft: Double!
    
    var userPropositions: [Proposition] = []
    var opponentPropositions: [Proposition]?
    var sortedOpponentPropositions: [Int: [Int: Double]]?
    var propositionTimer: Timer?
    var currentMillisecondsTime: Int = 0
    

//MARK: @IBOutlets
    
    // Top Container View
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userPseudoLabel: UILabel!
    @IBOutlet weak var opponentAvatarImageView: UIImageView!
    @IBOutlet weak var opponentPseudoLabel: UILabel!
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
        
        loadPlayersInfos()
        initCardsView()
        prepareOpponentPropositions()
        initTimer(animated: false)
        startTheRound()
    }
    
    func startTheRound() {
        moveToNextCard(cardsViews?.first, AndMovePreviousCard: nil, completion: nil)
        updateTimeline(withResult: .current, isForUser: true)
        updateTimeline(withResult: .current, isForUser: false)
    }
    
    func roundFinished() {
        
        var propositionsJSON: [[String: Any]] = []
        for proposition in userPropositions {
            let propositionJSON = proposition.generateJSONObject()
            propositionsJSON.append(propositionJSON)
        }
        
        let roundData = [RoundDataKey.kUserTime: Int(kTimePerRound - timeleft)*1000, RoundDataKey.kPropositions: propositionsJSON] as [String : Any]
        let matchID = MatchManager.sharedInstance.currentMatch?.id
        MatchManager.sharedInstance.putRound(withData: roundData, ForMatchID: matchID, andRoundID: round!.id,
            success: { (roundFull) in
                
                let debriefVC = self.storyboard?.instantiateViewController(withIdentifier: "idGameplayDebriefViewController") as! GameplayDebriefViewController
                debriefVC.productsList = self.round?.products
                self.navigationController?.pushViewController(debriefVC, animated: true)
            }
        ) { (error) in
            let debriefVC = self.storyboard?.instantiateViewController(withIdentifier: "idGameplayDebriefViewController") as! GameplayDebriefViewController
            debriefVC.productsList = self.round?.products
            self.navigationController?.pushViewController(debriefVC, animated: true)
        }
    }
    
    func loadPlayersInfos() {
        let userInfos = UserSessionManager.sharedInstance.getUserInfosAndAvatarImage()
        
        if let pseudo = userInfos.user?.pseudo, let userAvatarImage = userInfos.avatarImage {
            userPseudoLabel.text = pseudo
            userAvatarImageView.image = userAvatarImage
            userAvatarImageView.applyCircle(withBorderColor: UIColor.white)
        }
        
        userPlayer = MatchManager.sharedInstance.userPlayer
        opponentPlayer = MatchManager.sharedInstance.opponentPlayer
        
        if let opponentPlayer = opponentPlayer {
            opponentPseudoLabel.text = opponentPlayer.pseudo
            
            opponentPlayer.getAvatarImage(for: .medium,
                completionHandler: { (image) in
                    self.opponentAvatarImageView.image = image
                    self.opponentAvatarImageView.applyCircle(withBorderColor: UIColor.white)
                }
            )
        }
    }
    
    func prepareOpponentPropositions() {
        opponentPropositions = round.propositions
        if let opponentPropositions = self.opponentPropositions {
            if opponentPropositions.isEmpty == false {
                
                // Set all product IDs in an Array
                var productsIDs: [Int] = []
                for proposition in opponentPropositions {
                    if productsIDs.contains(proposition.productID) == false {
                        productsIDs.append(proposition.productID)
                    }
                }
                
                // For each product ID set a dictionary [timestamp: price]
                sortedOpponentPropositions = [:]
                for productID in productsIDs {
                    sortedOpponentPropositions![productID] = sortPropositions(propositions: opponentPropositions, forProductID: productID)
                }
            }
        }
    }
    
    func sortPropositions(propositions: [Proposition], forProductID productID: Int) -> [Int: Double] {
        var result: [Int: Double] = [:]
        
        for proposition in propositions {
            if proposition.productID == productID {
                result[proposition.timeStamp] = proposition.price
            }
        }
        
        return result
    }
    
    
//MARK: Card Product Management
    
    func initCardsView() {
        var cardsArray: [CardProductView] = []
        
        for product in self.round!.products {
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
            
            userPlayer?.getAvatarImage(for: .small,
                completionHandler: { (image) in
                    cardProductView?.userPinIconView.setAvatarImage(image)
                }
            )
            
            opponentPlayer?.getAvatarImage(for: .small,
                completionHandler: { (image) in
                    cardProductView?.opponentPinIconView.setAvatarImage(image)
                    cardProductView?.opponentPinIconView.alpha = 0.7
                }
            )
            
            cardProductView?.frame = CGRect(x: self.view.frame.size.width, y: cardContainerView.frame.origin.y, width: cardContainerView.frame.width, height: cardContainerView.frame.height)
            
            cardContainerView.addSubview(cardProductView!)
            
            cardsArray.append(cardProductView!)
        }
        
        if cardsArray.isEmpty {
            PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorOccured,
                doneActionCompletion: {
                    
                    self.goToHome()
                    return
                }
            )
            
        } else {
            cardsViews = cardsArray
        }
    }
    
    
    func nextProduct(withResult result: TimelineState) {
        updateTimeline(withResult: result, isForUser: true)
        
        if cursorCard < cardsViews!.count-1 {
            // Display the next card
            let nextCard = cardsViews![cursorCard + 1]
            
            moveToNextCard(nextCard, AndMovePreviousCard: currentCard,
                completion: { (_) in
                    self.cursorCounter = 0
                    self.keyboardView.enabledKeyboard(true)
                    self.keyboardView.reset()
                    self.updateTimeline(withResult: .current, isForUser: true)
                }
            )
            
        } else {
            // Game Finished !
            stopTimer()
            roundFinished()
        }
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
            
            // Initialize/Update current product data
            currentCard = nextCard
            currentPriceArray = ConverterHelper.convertPriceToArrayOfInt(round.products[cursorCard].price).priceArray
            userEstimation = Array(repeating: -1, count: (currentPriceArray?.count)!)
            currentProductData = round.products[cursorCard]
            
            completion?(true)
            
        } else {
            nextCard.translatesAutoresizingMaskIntoConstraints = false
            nextCard.frame = cardContainerView.frame
            
            let centerXNextCard = NSLayoutConstraint(item: nextCard, attribute: .centerX, relatedBy: .lessThanOrEqual, toItem: cardContainerView, attribute: .centerX, multiplier: 1.0, constant: self.view.frame.width+1.0)
            cardContainerView.addConstraint(centerXNextCard)
            cardContainerView.addConstraint(NSLayoutConstraint(item: nextCard, attribute: .centerY, relatedBy: .equal, toItem: cardContainerView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
            cardContainerView.addConstraint(NSLayoutConstraint(item: nextCard, attribute: .height, relatedBy: .equal, toItem: cardContainerView, attribute: .height, multiplier: 1.0, constant: 0.0))
            cardContainerView.addConstraint(NSLayoutConstraint(item: nextCard, attribute: .width, relatedBy: .equal, toItem: cardContainerView, attribute: .width, multiplier: 1.0, constant: 0.0))
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 1.0,
                delay: 0.6,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 10.0,
                options: .allowUserInteraction,
                animations: {
                    self.cardCenterXConstraint?.constant = -CGFloat(self.view.frame.width) - 50.0
                    centerXNextCard.constant = 0.0
                    self.view.layoutIfNeeded()
                    
                }, completion: { (_) in
                    self.currentMillisecondsTime = 0
                    
                    self.cardCenterXConstraint = centerXNextCard
                    self.cursorCard += 1
                    
                    // Initialize/Update current product data
                    self.currentCard = nextCard
                    self.currentPriceArray = ConverterHelper.convertPriceToArrayOfInt(self.round.products[self.cursorCard].price).priceArray
                    self.userEstimation = Array(repeating: -1, count: (self.currentPriceArray?.count)!)
                    self.currentProductData = self.round.products[self.cursorCard]
                    
                    completion?(true)
                }
            )
        }
    }
    
    
//MARK: Timer Methods
    
    func initTimer(animated: Bool) {
        timeleft = kTimePerRound
        
        if animated {
            UIView.animate(withDuration: 1.0,
                animations: {
                    self.circularProgressBarView.value = CGFloat(self.timeleft!)
                    self.view.layoutIfNeeded()
                }
            )
            
        } else {
            circularProgressBarView.value = CGFloat(timeleft!)
        }
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(GameplayMainViewController.updateTimer), userInfo: nil, repeats: true)
        
        propositionTimer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(GameplayMainViewController.updatePropositionTimer), userInfo: nil, repeats: true)
        
        circularProgressBarView.maxValue = CGFloat(kTimePerRound)
        circularProgressBarView.fontColor = UIColor.darkBlueDochaColor()
        circularProgressBarView.progressColor = UIColor.darkBlueDochaColor()
        circularProgressBarView.progressStrokeColor = UIColor.darkBlueDochaColor()
    }
    
    func updateTimer() {
        timeleft = timeleft! - 0.01
        circularProgressBarView.value = CGFloat(abs(timeleft!))
        
        if Int(timeleft!) == 10 {
            animateTimer()
            
        } else if timeleft! <= 0.0 {
            timeIsUp()
        }
    }
    
    func updatePropositionTimer() {
        currentMillisecondsTime += 1
        
        if let sortedOpponentPropositions = self.sortedOpponentPropositions {
            if let sortedProposition = sortedOpponentPropositions[currentProductData!.id] {
                
                if sortedProposition.keys.contains(currentMillisecondsTime)
                {
                    let opponentEstimation = sortedOpponentPropositions[currentProductData!.id]![currentMillisecondsTime]
                    animateUserPinIcon(withEstimation: opponentEstimation, forPlayer: false, andCompletion: nil)
                    
                    if opponentEstimation == currentProductData?.price {
                        updateTimeline(withResult: .perfect, isForUser: false)
                    }
                }
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        propositionTimer?.invalidate()
        propositionTimer = nil
    }
    
    func timeIsUp() {
        keyboardView.enabledKeyboard(false)
        stopTimer()
        roundFinished()
    }
    
    func animateTimer() {
        circularProgressBarView.fontColor = UIColor.redDochaColor()
        circularProgressBarView.progressColor = UIColor.redDochaColor()
        circularProgressBarView.progressStrokeColor = UIColor.redDochaColor()
    }
    

//MARK: Timeline Methods
    
    func updateTimeline(withResult result: TimelineState, isForUser: Bool) {
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
        PopupManager.sharedInstance.showInfosPopup("Informations prix", message: "Le prix de ce produit a été relevé le [DATE].\n Images et copyright appartiennent à \((currentProductData?.brand)!)", viewController: self, completion: nil, doneActionCompletion: nil)
    }
    
    
//MARK: Keyboard Delegate
    
    func clickOnPad(withNumber number: Int) {
        if cursorCounter == currentPriceArray?.count {
            return
        }
        
        currentCard?.counterContainerView.counterViewArray[cursorCounter].startCounterAnimationWithNumber(number: number, completion: nil)
        userEstimation![cursorCounter] = number
        cursorCounter += 1
        
        if cursorCounter == currentPriceArray?.count {
            //keyboardView.enableValidButton(true)
            validatePricing()
        }
    }
    
    func validatePricing() {
        keyboardView.enabledKeyboard(false)
        addProposition()
        
        animateUserPinIcon(withEstimation: nil, forPlayer: true) { (finished) in
            
            if finished {
                if self.userEstimation! == self.currentPriceArray! {
                    self.nextProduct(withResult: .perfect)
                    
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
    
    func addProposition() {
        let productID = currentProductData!.id
        let price = Double(ConverterHelper.convertPriceArrayToInt(userEstimation!)) + (Double(currentCard!.counterContainerView.centsLabel.text!)! / 100)
        
        let proposition = Proposition(productID: productID, price: price, timeStamp: currentMillisecondsTime)
        userPropositions.append(proposition)
    }
    

//MARK: Displaying Message
    
    func displayMessage(_ messageType: MessageType!, completion: ((_ finished: Bool) -> Void)?) {
        var messageImageView: UIImageView? = UIImageView(image: UIImage(named: "answer_\(messageType.rawValue)"))
        messageImageView?.contentMode = .scaleAspectFit
        messageImageView?.frame = CGRect(x: currentCard!.frame.midX-75.0, y: currentCard!.frame.midY-25.0, width: 150.0, height: 50.0)
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
    

//MARK: Gauge Methods
    
    func animateUserPinIcon(withEstimation estimation: Double? = nil, forPlayer isForUser: Bool, andCompletion completion: ((_ finished: Bool) -> Void)?) {
        let errorPercent = calculateUserEstimationErrorPercent(withEstimation: estimation)
        
        if isForUser {
            currentCard?.updatePinIconPosition(withErrorPercent: errorPercent, forPlayer: isForUser,
                andCompletion: { (finished) in
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
            
        } else {
            currentCard?.updatePinIconPosition(withErrorPercent: errorPercent, forPlayer: isForUser,
                andCompletion: { (finished) in
                    completion?(true)
                }
            )
        }
    }
    
    func calculateUserEstimationErrorPercent(withEstimation estimation: Double? = nil) -> Double {
        let kErrorPercent = 0.36
        let userEstimation: Double
        
        if let estimation = estimation {
            userEstimation = estimation
            
        } else {
            userEstimation = Double(ConverterHelper.convertPriceArrayToInt(self.userEstimation!))
        }
        
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
