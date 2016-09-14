//
//  GameplayDebriefViewController.swift
//  Docha
//
//  Created by Mathis D on 12/09/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class GameplayDebriefViewController: GameViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, GameplayDebriefPageContentDelegate {
    
    var productsList: [Product]?
    
    var pageViewController: UIPageViewController!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var containerPageViewController: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("idDebriefPageViewController") as! UIPageViewController
        self.pageViewController.delegate = self
        self.pageViewController.dataSource = self
        
        let pageContentVC = self.viewControllerAtIndex(0)
        pageViewController.setViewControllers([pageContentVC!], direction: .Forward, animated: true, completion: nil)
        self.addChildViewController(pageViewController)
    }
    

//MARK: Page View Controller Data Source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! GameplayDebriefPageContentViewController).pageIndex!
        if(index == 0) {
            return nil
        }
        index -= 1
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! StarterPageContentViewController).pageIndex!
        index += 1
        if(index == self.productsList!.count) {
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
    
    
//MARK: Page View Controller Delegate
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished {
            let viewController = self.pageViewController.viewControllers![0] as! GameplayDebriefPageContentViewController
            let currentIndex = viewController.pageIndex
            self.pageControl.currentPage = currentIndex!
            self.pageControl.updateCurrentPageDisplay()
        }
    }
    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
        if((self.productsList!.count == 0) || (index >= self.productsList!.count)) {
            return nil
        }
        let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("idGameplayDebriefPageContentViewController") as! GameplayDebriefPageContentViewController
        
        let product = self.productsList![index]
        pageContentViewController.productImageView.image = product.image
        pageContentViewController.productNameLabel.text = product.model
        pageContentViewController.productBrandLabel.text = product.brand
        pageContentViewController.delegate = self
        pageContentViewController.pageIndex = index
        
        // force instantiate pageContentViewController IBOutlets
        _ = pageContentViewController.view
        
        return pageContentViewController
    }
    
    
//MARK: Gameplay Debrief Page Content Delegate
    
    func moreDetailsButtonTouched() {
        
    }
    
    func shareButtonTouched() {
        
    }
}