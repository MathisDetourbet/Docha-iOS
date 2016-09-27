//
//  GameplayDebriefViewController.swift
//  Docha
//
//  Created by Mathis D on 12/09/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import PBWebViewController

enum ResultRoundSentence: String {
    case winner = "winner_sentence"
    case looser = "looser_sentence"
    case nul = "nul_sentence"
}

class GameplayDebriefViewController: GameViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, GameplayDebriefPageContentDelegate, CounterContainerViewDelegate {
    
    var productsList: [Product]?
    var userResultsArray: [TimelineState]?
    
    var pagesContentsViewControllerArray: [GameplayDebriefPageContentViewController] = []
    var pageViewController: UIPageViewController!
    
    var webViewController: PBWebViewController?
    
    @IBOutlet weak var resultRoundSentenceImageView: UIImageView!
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userLevelLabel: UILabel!
    @IBOutlet var userTimelineImageViewCollection: [UIImageView]!
    
    @IBOutlet weak var opponentAvatarImageView: UIImageView!
    @IBOutlet weak var opponentNameLabel: UILabel!
    @IBOutlet weak var opponentLevelLabel: UILabel!
    @IBOutlet var opponentTimelineImageViewCollection: [UIImageView]!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var containerPageViewController: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildUI()
        
        pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("idDebriefPageViewController") as! UIPageViewController
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        let pageContentVC = self.viewControllerAtIndex(0)
        pageContentVC!.counterContainerView.updateCountersViewsWithPrice(ConverterHelper.convertPriceToArrayOfInt(self.productsList!.first!.price).priceArray)
        pageViewController.setViewControllers([pageContentVC!], direction: .Forward, animated: true, completion: nil)
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        containerPageViewController.addSubview(pageViewController!.view)
        
        containerPageViewController.addConstraint(NSLayoutConstraint(item: pageViewController.view, attribute: .Leading, relatedBy: .Equal, toItem: containerPageViewController, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        containerPageViewController.addConstraint(NSLayoutConstraint(item: pageViewController.view, attribute: .Trailing, relatedBy: .Equal, toItem: containerPageViewController, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        containerPageViewController.addConstraint(NSLayoutConstraint(item: pageViewController.view, attribute: .Top, relatedBy: .Equal, toItem: containerPageViewController, attribute: .Top, multiplier: 1.0, constant: 0.0))
        containerPageViewController.addConstraint(NSLayoutConstraint(item: pageViewController.view, attribute: .Bottom, relatedBy: .Equal, toItem: containerPageViewController, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
        
        pageViewController.didMoveToParentViewController(self)
    }
    
    func buildUI() {
        let userSession = UserSessionManager.sharedInstance.currentSession()
        
        if let userSession = userSession {
            if let avatar = userSession.avatar {
                userAvatarImageView.image = UIImage(named: avatar)
                
            } else {
                
            }
            userNameLabel.text = userSession.pseudo
            userLevelLabel.text = "Niveau \(userSession.levelMaxUnlocked)"
        }
        
        var timelineImageName: String?
        var index = 0
        for result in userResultsArray! {
            
            if result == .Perfect {
                timelineImageName = "perfect_big_icon"
                
            } else if result == .Wrong {
                timelineImageName = "red_big_icon"
            }
            
            userTimelineImageViewCollection[index].image = UIImage(named: timelineImageName!)
            index += 1
        }
    }
    

//MARK: Page View Controller Data Source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! GameplayDebriefPageContentViewController).pageIndex!
        if(index == 0) {
            return nil
        }
        index -= 1
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! GameplayDebriefPageContentViewController).pageIndex!
        index += 1
        if(index == productsList!.count) {
            return nil
        }
        return viewControllerAtIndex(index)
    }
    
    
//MARK: Page View Controller Delegate
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished {
            let viewController = pageViewController.viewControllers![0] as! GameplayDebriefPageContentViewController
            let currentIndex = viewController.pageIndex
            pageControl.currentPage = currentIndex!
            pageControl.updateCurrentPageDisplay()
            
            viewController.counterContainerView.updateCountersViewsWithPrice(ConverterHelper.convertPriceToArrayOfInt(self.productsList![currentIndex!].price).priceArray)
        }
    }
    
    func viewControllerAtIndex(index : Int) -> GameplayDebriefPageContentViewController? {
        if((productsList!.count == 0) || (index >= productsList!.count)) {
            return nil
        }
        
        if self.pagesContentsViewControllerArray.indices.contains(index) {
            return pagesContentsViewControllerArray[index]
            
        } else {
            let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("idGameplayDebriefPageContentViewController") as! GameplayDebriefPageContentViewController
            
            // force instantiate pageContentViewController IBOutlets
            _ = pageContentViewController.view
            
            let product = self.productsList![index]
            pageContentViewController.productImageView.image = product.image
            pageContentViewController.productNameLabel.text = product.model
            pageContentViewController.productBrandLabel.text = product.brand
            pageContentViewController.delegate = self
            pageContentViewController.pageIndex = index
            pageContentViewController.counterContainerView.numberOfCounterDisplayed = ConverterHelper.convertPriceToArrayOfInt(product.price).priceArray.count
            pageContentViewController.counterContainerView.delegate = self
            
            self.pagesContentsViewControllerArray.insert(pageContentViewController, atIndex: index)
            
            return pageContentViewController
        }
    }
    
    
//MARK: Gameplay Debrief Page Content Delegate
    
    func moreDetailsButtonTouched(productIndex: Int) {
        webViewController = PBWebViewController()
        let url = NSURL(string: productsList![productIndex].pageURL)
        webViewController!.URL = url
        
        let activity = UIActivity()
        webViewController?.applicationActivities = [activity]
        self.navigationController?.pushViewController(webViewController!, animated: true)
    }
    
    func shareButtonTouched() {
        
    }
    
    
//MARK: @IBActions Methods
    
    @IBAction func nextButtonTouched(sender: UIButton) {
        
    }
    
    
//MARK: CounterContainerView Delegate Methods
    
    func infosButtonTouched() {
        let currentProductData = self.productsList![pageControl.currentPage]
        PopupManager.sharedInstance.showInfosPopup("Informations prix", message: "Le prix de ce produit a été relevé le [DATE] sur le site internet [URL_RACINE].\n Images et copyright appartiennent à \((currentProductData.brand))", viewController: self, completion: nil, doneActionCompletion: nil)
    }
}