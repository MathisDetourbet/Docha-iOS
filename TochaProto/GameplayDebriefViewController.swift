//
//  GameplayDebriefViewController.swift
//  Docha
//
//  Created by Mathis D on 12/09/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import FBSDKShareKit
import SnapKit
import Crashlytics

class GameplayDebriefViewController: GameViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, GameplayDebriefPageContentDelegate, CounterContainerViewDelegate, FBSDKSharingDelegate {
    
    var productsList: [Product]?
    var userResultsArray: [TimelineState] = [.wrong, .wrong, .wrong]
    var oldUser: User?
    var newUser: User?
    
    var pagesContentsViewControllerArray: [GameplayDebriefPageContentViewController] = []
    var pageViewController: UIPageViewController!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var containerPageViewController: UIView!
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var aspectRatioTopContainerConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var responseLabel: UILabel!
    
    
// MARK: - Life View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        oldUser = UserSessionManager.sharedInstance.getUserInfosAndAvatarImage().user
        
        buildUI()
        
        pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "idDebriefPageViewController") as! UIPageViewController
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        let pageContentVC = viewControllerAtIndex(0)
        pageViewController.setViewControllers([pageContentVC!], direction: .forward, animated: true, completion: nil)
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        containerPageViewController.addSubview(pageViewController!.view)
        
        containerPageViewController.addConstraint(NSLayoutConstraint(item: pageViewController.view, attribute: .leading, relatedBy: .equal, toItem: containerPageViewController, attribute: .leading, multiplier: 1.0, constant: 0.0))
        containerPageViewController.addConstraint(NSLayoutConstraint(item: pageViewController.view, attribute: .trailing, relatedBy: .equal, toItem: containerPageViewController, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        containerPageViewController.addConstraint(NSLayoutConstraint(item: pageViewController.view, attribute: .top, relatedBy: .equal, toItem: containerPageViewController, attribute: .top, multiplier: 1.0, constant: 0.0))
        containerPageViewController.addConstraint(NSLayoutConstraint(item: pageViewController.view, attribute: .bottom, relatedBy: .equal, toItem: containerPageViewController, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        
        pageViewController.didMove(toParentViewController: self)
        let priceArray = ConverterHelper.convertPriceToArrayOfInt(productsList!.first!.price).priceArray
        pageContentVC!.counterContainerView.updateCountersViewsWithPrice(priceArray)
        
        loadNewUserInfos()
        
        // Answers: number of rounds played in session
        answersNumberOfRoundPlayed += 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
// MARK: - Load & Display User Data
    
    func loadNewUserInfos() {
        UserSessionManager.sharedInstance.getUser(
            success: {
                self.newUser = UserSessionManager.sharedInstance.getUserInfosAndAvatarImage().user
                
            }) { (error) in
                self.newUser = nil
        }
    }
    
    func buildUI() {
        var idDebriefView = "DebriefTopContainerView"
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            idDebriefView = "DebriefTopContainerView4S"
            aspectRatioTopContainerConstraint.isActive = false
            self.view.addConstraint(NSLayoutConstraint(item: topContainerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 155))
            self.view.addConstraint(NSLayoutConstraint(item: topContainerView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: 0))
            
            responseLabel.isHidden = true
        }
        
        let debriefTopContainerView = DebriefTopContainerView.loadFromNibNamed(idDebriefView) as! DebriefTopContainerView
        debriefTopContainerView.translatesAutoresizingMaskIntoConstraints = false
        topContainerView.addSubview(debriefTopContainerView)
        
        debriefTopContainerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        let matchManager = MatchManager.sharedInstance
        let currentRound = matchManager.currentRound as? RoundFull
        
        if let currentRound = currentRound {
            
            // Timeline
            var timelineImage: UIImage?
            var index = 0
            
            var userScore = Int(currentRound.userScore ?? 0)
            let scoreMax = currentRound.products.count
            userScore = userScore > scoreMax ? scoreMax : userScore
            
            for index in 0..<userScore {
                userResultsArray[index] = .perfect
            }
            
            for result in userResultsArray {
                
                if result == .perfect {
                    timelineImage = #imageLiteral(resourceName: "perfect_big_icon")
                    
                } else if result == .wrong {
                    timelineImage = #imageLiteral(resourceName: "red_big_icon")
                }
                
                debriefTopContainerView.userTimelineImageViewCollection[index].image = timelineImage
                index += 1
            }
            
            for index in 0..<debriefTopContainerView.opponentTimelineImageViewCollection.count {
                if currentRound.status == .waiting {
                    debriefTopContainerView.opponentTimelineImageViewCollection[index].image = #imageLiteral(resourceName: "waiting_icon")
                    
                } else {
                    debriefTopContainerView.opponentTimelineImageViewCollection[index].image = #imageLiteral(resourceName: "red_big_icon")
                }
            }
            
            var opponentScore = Int(currentRound.opponentScore ?? 0)
            opponentScore = opponentScore > scoreMax ? scoreMax : opponentScore
            
            for index in 0..<opponentScore {
                debriefTopContainerView.opponentTimelineImageViewCollection[index].image = #imageLiteral(resourceName: "perfect_big_icon")
            }
            
            var userBorderColor: UIColor = UIColor.white
            var opponentBorderColor: UIColor = UIColor.white
            
            // Result sentence
            switch currentRound.status {
            case .waiting:
                debriefTopContainerView.resultRoundSentenceImageView.image = #imageLiteral(resourceName: "waiting_sentence")
                break
                
            case .won:
                debriefTopContainerView.resultRoundSentenceImageView.image = #imageLiteral(resourceName: "winner_sentence")
                userBorderColor = UIColor.greenDochaColor()
                opponentBorderColor = UIColor.redDochaColor()
                break
                
            case .lost:
                debriefTopContainerView.resultRoundSentenceImageView.image = #imageLiteral(resourceName: "looser_sentence")
                userBorderColor = UIColor.redDochaColor()
                opponentBorderColor = UIColor.greenDochaColor()
                break
                
            case .tie:
                debriefTopContainerView.resultRoundSentenceImageView.image = #imageLiteral(resourceName: "nul_sentence")
                break
            }
            
            // User infos
            let userPlayer = matchManager.userPlayer
            let opponentPlayer = matchManager.opponentPlayer
            
            if let userPlayer = userPlayer {
                debriefTopContainerView.userAvatarImageView.image = userPlayer.avatarImage
                debriefTopContainerView.userAvatarImageView.applyCircle(withBorderColor: userBorderColor)
                debriefTopContainerView.userNameLabel.text = userPlayer.pseudo
                
                if let level = userPlayer.level {
                    debriefTopContainerView.userLevelLabel.text = "Niveau \(level)"
                    
                } else {
                    debriefTopContainerView.userLevelLabel.text = "?"
                }
            }
            
            // Opponent infos
            if let opponentPlayer = opponentPlayer {
                debriefTopContainerView.opponentNameLabel.text = opponentPlayer.pseudo
                
                opponentPlayer.getAvatarImage(for: .medium,
                                              completionHandler: { (image) in
                                                debriefTopContainerView.opponentAvatarImageView.image = image
                                                debriefTopContainerView.opponentAvatarImageView.applyCircle(withBorderColor: opponentBorderColor)
                }
                )
                
                if let level = opponentPlayer.level {
                    debriefTopContainerView.opponentLevelLabel.text = "Niveau \(level)"
                    
                } else {
                    debriefTopContainerView.opponentLevelLabel.text = "?"
                }
            }
            
            userScore = Int(currentRound.userScore ?? 0)
            opponentScore = Int(currentRound.opponentScore ?? 0)
            
            if userScore > scoreMax {
                // You won
                if let userTime = currentRound.userTime {
                    let seconds = Int(userTime/1000)
                    let milliseconds = (Int(Int(userTime) - (seconds * 1000))) / 1000
                    debriefTopContainerView.userTimeLabel.text = "\(seconds)\"\(milliseconds)"
                    debriefTopContainerView.opponentTimeLabel.text = "Temps écoulé"
                }
            } else if opponentScore > scoreMax {
                // You loose
                if let opponentTime = currentRound.opponentTime {
                    let seconds = Int(opponentTime/1000)
                    let milliseconds = (Int(Int(opponentTime) - (seconds * 1000))) / 1000
                    debriefTopContainerView.opponentTimeLabel.text = "\(seconds)\"\(milliseconds)"
                    debriefTopContainerView.userTimeLabel.text = "Temps écoulé"
                }
                
            } else if userScore == opponentScore {
                // Tie
                if let userTime = currentRound.userTime {
                    let seconds = Int(userTime/1000)
                    let milliseconds = (Int(Int(userTime) - (seconds * 1000))) / 1000
                    debriefTopContainerView.userTimeLabel.text = "\(seconds)\"\(milliseconds)"
                    debriefTopContainerView.opponentTimeLabel.text = debriefTopContainerView.userTimeLabel.text
                }
                
            } else {
                debriefTopContainerView.userTimeLabel.text = nil
                debriefTopContainerView.opponentTimeLabel.text = nil
            }
        }
    }
    

//MARK: - Page View Controller Data Source
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! GameplayDebriefPageContentViewController).pageIndex!
        if(index == 0) {
            return nil
        }
        index -= 1
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! GameplayDebriefPageContentViewController).pageIndex!
        index += 1
        if(index == productsList!.count) {
            return nil
        }
        return viewControllerAtIndex(index)
    }
    
    
//MARK: - Page View Controller Delegate
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished {
            let viewController = pageViewController.viewControllers![0] as! GameplayDebriefPageContentViewController
            let currentIndex = viewController.pageIndex
            pageControl.currentPage = currentIndex!
            pageControl.updateCurrentPageDisplay()
            
            viewController.counterContainerView.updateCountersViewsWithPrice(ConverterHelper.convertPriceToArrayOfInt(self.productsList![currentIndex!].price).priceArray)
        }
    }
    
    func viewControllerAtIndex(_ index : Int) -> GameplayDebriefPageContentViewController? {
        if((productsList!.count == 0) || (index >= productsList!.count)) {
            return nil
        }
        
        if self.pagesContentsViewControllerArray.indices.contains(index) {
            return pagesContentsViewControllerArray[index]
            
        } else {
            let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "idGameplayDebriefPageContentViewController") as! GameplayDebriefPageContentViewController
            
            // force instantiate pageContentViewController IBOutlets
            _ = pageContentViewController.view
            
            let product = self.productsList![index]
            pageContentViewController.productImageView.image = product.image
            pageContentViewController.productNameLabel.text = product.model
            pageContentViewController.productBrandLabel.text = product.brand
            pageContentViewController.delegate = self
            pageContentViewController.pageIndex = index
            let centsString = ConverterHelper.convertPriceToArrayOfInt(product.price).centsString
            pageContentViewController.counterContainerView.centsLabel.text = centsString + " €"
            pageContentViewController.counterContainerView.numberOfCounterDisplayed = ConverterHelper.convertPriceToArrayOfInt(product.price).priceArray.count
            pageContentViewController.counterContainerView.delegate = self
            pageContentViewController.counterContainerView.layoutSubviews()
            pageContentViewController.counterContainerView.initCountersViews()
            
            if UserSessionManager.sharedInstance.isFacebookUser() == false {
                pageContentViewController.sharingButton.isHidden = false
            }
            
            pagesContentsViewControllerArray.insert(pageContentViewController, at: index)
            
            return pageContentViewController
        }
    }
    
    
//MARK: - Gameplay Debrief Page Content Delegate
    
    func moreDetailsButtonTouched() {
        if let pageUrlString = productsList?[pageControl.currentPage].pageUrl {
            
            let url = URL(string: pageUrlString)
            let webViewController = storyboard?.instantiateViewController(withIdentifier: "idCustomWebViewController") as! CustomWebViewController
            webViewController.url = url
            webViewController.titleNavBar = "Fiche produit"
            webViewController.configNavigationBarWithTitle("Fiche produit")
            
            let activity = UIActivity()
            webViewController.applicationActivities = [activity]
            webViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(webViewController, animated: true)
            
        } else {
            PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorOccured)
        }
        
        // Answers: number of clicks
        Answers.logCustomEvent(withName: "More infos clicked", customAttributes: nil)
    }
    
    func shareButtonTouched() {
        // Facebook Sharing
        let product = productsList?[pageControl.currentPage]
        let quote = "Je viens de découvrir ce produit sur Docha ! : \(product?.model ?? "")"
        
        let content = FBSDKShareLinkContent()
        content.contentURL = URL(string: product?.pageUrl ?? kAppStoreDochaURL)
        content.quote = quote
        
        let shareDialog = FBSDKShareDialog()
        shareDialog.fromViewController = self
        shareDialog.shareContent = content
        shareDialog.mode = .shareSheet
        shareDialog.show()
    }
    

//MARK: FBSDKSharingDelegate
    
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable: Any]!) {
        PopupManager.sharedInstance.showSuccessPopup(message: Constants.PopupMessage.SuccessMessage.kSuccessFBSharing)
    }
    
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorFBFriendsInvite +  " " + Constants.PopupMessage.ErrorMessage.kErrorOccured)
    }
    
    func sharerDidCancel(_ sharer: FBSDKSharing!) {
        
    }
    
    
//MARK: - @IBActions Methods
    
    @IBAction func nextButtonTouched(_ sender: UIButton) {
        let currentRound = MatchManager.sharedInstance.currentRound as? RoundFull
        let currentMatch = MatchManager.sharedInstance.currentMatch
        var matchResult: MatchResult?
        
        if let currentMatch = currentMatch {
            if currentMatch.status.isMatchFinished() {
                matchResult = MatchResult(with: currentMatch.status)
            }
        }
        
        if let currentRound = currentRound {
            if let oldUser = self.oldUser, let newUser = self.newUser {
                if currentRound.status == .won {
                    let dochosWon = newUser.dochos - oldUser.dochos
                    
                    let rewardsDochosVC = self.storyboard?.instantiateViewController(withIdentifier: "idGameplayRewardsDochosViewController") as! GameplayRewardsDochosViewController
                    rewardsDochosVC.dochosWon = dochosWon
                    rewardsDochosVC.newLevel = oldUser.levelMaxUnlocked! < newUser.levelMaxUnlocked! ? newUser.levelMaxUnlocked : nil
                    rewardsDochosVC.matchResult = matchResult
                    self.navigationController?.pushViewController(rewardsDochosVC, animated: true)
                    
                    return
                    
                } else if oldUser.levelMaxUnlocked! < newUser.levelMaxUnlocked! {
                    let rewardsLevelUpVC = self.storyboard?.instantiateViewController(withIdentifier: "idGameplayRewardsLevelUpViewController") as! GameplayRewardsLevelUpViewController
                    rewardsLevelUpVC.newUserLevel = newUser.levelMaxUnlocked!
                    rewardsLevelUpVC.matchResult = matchResult
                    self.navigationController?.pushViewController(rewardsLevelUpVC, animated: true)
                    
                    return
                }
            }
        }
        
        let match = MatchManager.sharedInstance.currentMatch
        if let match = match {
            goToMatch(match, animated: true)
            
        } else {
            goToHome()
        }
    }
    
    
//MARK: - CounterContainerView Delegate Methods
    
    func infosButtonTouched() {
        let product = productsList?[pageControl.currentPage]
        
        if let product = product {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let dateString = dateFormatter.string(from: product.lastUpdatedDate)
            PopupManager.sharedInstance.showInfosPopup("Informations prix", message: "Le prix de ce produit a été relevé le \(dateString).\n Images et copyright appartiennent à \((product.brand))", viewController: self, completion: nil, doneActionCompletion: nil)
        }
    }
}
