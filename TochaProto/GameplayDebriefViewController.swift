//
//  GameplayDebriefViewController.swift
//  Docha
//
//  Created by Mathis D on 12/09/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

class GameplayDebriefViewController: GameViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, GameplayDebriefPageContentDelegate, CounterContainerViewDelegate {
    
    var productsList: [Product]?
    var userResultsArray: [TimelineState] = [.wrong, .wrong, .wrong]
    var oldUser: User?
    var newUser: User?
    
    var pagesContentsViewControllerArray: [GameplayDebriefPageContentViewController] = []
    var pageViewController: UIPageViewController!
    
    @IBOutlet weak var resultRoundSentenceImageView: UIImageView!
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userLevelLabel: UILabel!
    @IBOutlet weak var userTimeLabel: UILabel!
    @IBOutlet var userTimelineImageViewCollection: [UIImageView]!
    
    @IBOutlet weak var opponentAvatarImageView: UIImageView!
    @IBOutlet weak var opponentNameLabel: UILabel!
    @IBOutlet weak var opponentLevelLabel: UILabel!
    @IBOutlet weak var opponentTimeLabel: UILabel!
    @IBOutlet var opponentTimelineImageViewCollection: [UIImageView]!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var containerPageViewController: UIView!
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func loadNewUserInfos() {
        UserSessionManager.sharedInstance.getUser(
            success: {
                self.newUser = UserSessionManager.sharedInstance.getUserInfosAndAvatarImage().user
                
            }) { (error) in
                self.newUser = nil
        }
    }
    
    func buildUI() {
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
                
                userTimelineImageViewCollection[index].image = timelineImage
                index += 1
            }
            
            for index in 0..<opponentTimelineImageViewCollection.count {
                if currentRound.status == .waiting {
                    opponentTimelineImageViewCollection[index].image = #imageLiteral(resourceName: "waiting_icon")
                    
                } else {
                    opponentTimelineImageViewCollection[index].image = #imageLiteral(resourceName: "red_big_icon")
                }
            }
            
            var opponentScore = Int(currentRound.opponentScore ?? 0)
            opponentScore = opponentScore > scoreMax ? scoreMax : opponentScore
            
            for index in 0..<opponentScore {
                opponentTimelineImageViewCollection[index].image = #imageLiteral(resourceName: "perfect_big_icon")
            }
            
            var userBorderColor: UIColor = UIColor.white
            var opponentBorderColor: UIColor = UIColor.white
            
            // Result sentence
            switch currentRound.status {
            case .waiting:
                resultRoundSentenceImageView.image = #imageLiteral(resourceName: "waiting_sentence")
                break
                
            case .won:
                resultRoundSentenceImageView.image = #imageLiteral(resourceName: "winner_sentence")
                userBorderColor = UIColor.greenDochaColor()
                opponentBorderColor = UIColor.redDochaColor()
                break
                
            case .lost:
                resultRoundSentenceImageView.image = #imageLiteral(resourceName: "looser_sentence")
                userBorderColor = UIColor.redDochaColor()
                opponentBorderColor = UIColor.greenDochaColor()
                break
                
            case .tie:
                resultRoundSentenceImageView.image = #imageLiteral(resourceName: "nul_sentence")
                break
            }
            
            // User infos
            let userPlayer = matchManager.userPlayer
            let opponentPlayer = matchManager.opponentPlayer
            
            if let userPlayer = userPlayer {
                userAvatarImageView.image = userPlayer.avatarImage
                userAvatarImageView.applyCircle(withBorderColor: userBorderColor)
                userNameLabel.text = userPlayer.pseudo
                
                if let level = userPlayer.level {
                    userLevelLabel.text = "Niveau \(level)"
                    
                } else {
                    userLevelLabel.text = "?"
                }
            }
            
            // Opponent infos
            if let opponentPlayer = opponentPlayer {
                opponentNameLabel.text = opponentPlayer.pseudo
                
                opponentPlayer.getAvatarImage(for: .large,
                    completionHandler: { (image) in
                        self.opponentAvatarImageView.image = image
                        self.opponentAvatarImageView.applyCircle(withBorderColor: opponentBorderColor)
                    }
                )
                
                if let level = opponentPlayer.level {
                    opponentLevelLabel.text = "Niveau \(level)"
                    
                } else {
                    opponentLevelLabel.text = "?"
                }
            }
            
            userScore = Int(currentRound.userScore ?? 0)
            opponentScore = Int(currentRound.opponentScore ?? 0)
            
            if userScore > scoreMax {
                if let userTime = currentRound.userTime {
                    let seconds = Int(userTime/1000)
                    let milliseconds = (Int(Int(userTime) - (seconds * 1000))) / 1000
                    userTimeLabel.text = "\(seconds)\"\(milliseconds)"
                    opponentTimeLabel.text = "Temps écoulé"
                }
            } else if opponentScore > scoreMax {
                if let opponentTime = currentRound.opponentTime {
                    let seconds = Int(opponentTime/1000)
                    let milliseconds = (Int(Int(opponentTime) - (seconds * 1000))) / 1000
                    opponentTimeLabel.text = "\(seconds)\"\(milliseconds)"
                    userTimeLabel.text = "Temps écoulé"
                }
                
            } else {
                userTimeLabel.text = nil
                opponentTimeLabel.text = nil
            }
        }
    }
    

//MARK: Page View Controller Data Source
    
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
    
    
//MARK: Page View Controller Delegate
    
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
            pageContentViewController.counterContainerView.centsLabel.text = centsString
            pageContentViewController.counterContainerView.numberOfCounterDisplayed = ConverterHelper.convertPriceToArrayOfInt(product.price).priceArray.count
            pageContentViewController.counterContainerView.delegate = self
            pageContentViewController.counterContainerView.layoutSubviews()
            pageContentViewController.counterContainerView.initCountersViews()
            
            pagesContentsViewControllerArray.insert(pageContentViewController, at: index)
            
            return pageContentViewController
        }
    }
    
    
//MARK: Gameplay Debrief Page Content Delegate
    
    func moreDetailsButtonTouched(_ productIndex: Int) {
        if let pageUrlString = productsList?[productIndex].pageUrl {
            
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
    }
    
    func shareButtonTouched() {
        
    }
    
    
//MARK: @IBActions Methods
    
    @IBAction func nextButtonTouched(_ sender: UIButton) {
        let currentRound = MatchManager.sharedInstance.currentRound as? RoundFull
        
        if let currentRound = currentRound {
            if let oldUser = self.oldUser, let newUser = self.newUser {
                if currentRound.status == .won {
                    //let levelUp = oldUser.levelMaxUnlocked! < newUser.levelMaxUnlocked! ? true : false
                    let dochosWon = newUser.dochos - oldUser.dochos
                    
                    let rewardsDochosVC = self.storyboard?.instantiateViewController(withIdentifier: "idGameplayRewardsDochosViewController") as! GameplayRewardsDochosViewController
                    rewardsDochosVC.dochosWon = dochosWon
                    rewardsDochosVC.newLevel = oldUser.levelMaxUnlocked! < newUser.levelMaxUnlocked! ? newUser.levelMaxUnlocked : nil
                    self.navigationController?.pushViewController(rewardsDochosVC, animated: true)
                    
                    return
                    
                } else if oldUser.levelMaxUnlocked! < newUser.levelMaxUnlocked! {
                    let rewardsLevelUpVC = self.storyboard?.instantiateViewController(withIdentifier: "idGameplayRewardsLevelUpViewController") as! GameplayRewardsLevelUpViewController
                    rewardsLevelUpVC.newUserLevel = newUser.levelMaxUnlocked!
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
    
    
//MARK: CounterContainerView Delegate Methods
    
    func infosButtonTouched() {
        let currentProductData = self.productsList![pageControl.currentPage]
        PopupManager.sharedInstance.showInfosPopup("Informations prix", message: "Le prix de ce produit a été relevé le [DATE].\n Images et copyright appartiennent à \((currentProductData.brand))", viewController: self, completion: nil, doneActionCompletion: nil)
    }
}
