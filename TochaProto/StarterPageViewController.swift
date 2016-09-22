//
//  StarterPageViewController.swift
//  DochaProto
//
//  Created by Mathis D on 22/05/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class StarterPageViewController: RootViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    let kPageViewCount = 3
    let colors = [UIColor(red: 76, green: 162, blue: 255, alpha: 1), UIColor(red: 255, green: 112, blue: 101, alpha: 1), UIColor(red: 251, green: 196, blue: 73, alpha: 1)]
    
    var pageViewController: UIPageViewController!
    var stopDisplayAnimation: Bool = false
    var timer: NSTimer?
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var connexionButton: UIButton!
    @IBOutlet weak var iPhoneImageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var constraintTopToSuperview: NSLayoutConstraint!
    @IBOutlet weak var constraintiPhoneTopToView: NSLayoutConstraint!
    
    
//MARK: Life View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildUI()
        startTimer()
    }
    
    func buildUI() {
        pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("idStarterPageViewController") as! UIPageViewController
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        let pageContentViewController = self.viewControllerAtIndex(0) as? StarterPageContentViewController
        pageViewController.setViewControllers([pageContentViewController!], direction: .Forward, animated: true, completion: nil)
        pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, (self.view.frame.size.height - (registerButton.frame.size.height+10)))
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
        self.view.bringSubviewToFront(self.pageControl)
        self.view.bringSubviewToFront(self.iPhoneImageView)
        
        self.connexionButton.animatedLikeBubbleWithDelay(0.5, duration: 0.5)
        self.registerButton.animatedLikeBubbleWithDelay(0.5, duration: 0.5)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 48.0, green: 73.0, blue: 100.0, alpha: 1.0)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let currentPageContentVC = pageViewController.viewControllers![0] as! StarterPageContentViewController
        currentPageContentVC.buildUI()
        startTimer()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        stopTimer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.constraintTopToSuperview.constant = 0.70 * self.view.frame.height
        if case 0...(self.pageViewController.viewControllers!.count - 1) = pageControl.currentPage {
            let currentViewController = self.pageViewController.viewControllers?[pageControl.currentPage] as! StarterPageContentViewController
            constraintiPhoneTopToView.constant = currentViewController.backgroundImageView.frame.height - self.iPhoneImageView.frame.height
        }
    }
    
    
//MARK: Timer Methods
    
    func startTimer() {
        if timer != nil {
            return
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(StarterPageViewController.updateTimer), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func resetTimer() {
        stopTimer()
        startTimer()
    }
    
    func updateTimer() {
        if pageControl.currentPage == (kPageViewCount-1) {
            pageControl.currentPage = 0
            let firstPageContentViewController = self.viewControllerAtIndex(pageControl.currentPage) as? StarterPageContentViewController
            pageViewController.setViewControllers([firstPageContentViewController!], direction: .Reverse, animated: true,
            completion: {(_) in
                firstPageContentViewController?.buildUI()
                self.pageControl.updateCurrentPageDisplay()
            })
            
        } else {
            pageControl.currentPage += 1
            let nextPageContentViewController = self.viewControllerAtIndex(pageControl.currentPage) as? StarterPageContentViewController
            pageViewController.setViewControllers([nextPageContentViewController!], direction: .Forward, animated: true, completion: { (_) in
                nextPageContentViewController?.buildUI()
                self.pageControl.updateCurrentPageDisplay()
            })
        }
    }
    
    
//MARK: Page View Controller Data Source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        resetTimer()
        
        var index = (viewController as! StarterPageContentViewController).pageIndex!
        if(index == 0) {
            return nil
        }
        index -= 1
        
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        resetTimer()
        
        var index = (viewController as! StarterPageContentViewController).pageIndex!
        index += 1
        if(index == kPageViewCount) {
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
    
    
//MARK: Page View Controller Delegate
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        let viewController = self.pageViewController.viewControllers![0] as! StarterPageContentViewController
        viewController.buildUI()
        
        if finished {
            let currentIndex = viewController.pageIndex
            self.pageControl.currentPage = currentIndex!
            self.pageControl.updateCurrentPageDisplay()
        }
    }
    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
        if((kPageViewCount == 0) || (index >= kPageViewCount)) {
            return nil
        }
        let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("idStarterPage\(index+1)ContentViewController") as! StarterPageContentViewController
        
        // force instantiate pageContentViewController IBOutlets
        _ = pageContentViewController.view
        pageContentViewController.pageIndex = index
        
        return pageContentViewController
    }
}
