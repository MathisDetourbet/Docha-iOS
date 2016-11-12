//
//  StarterPageViewController.swift
//  DochaProto
//
//  Created by Mathis D on 22/05/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

class StarterPageViewController: RootViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    let kPageViewCount = 3
    let colors = [UIColor(red: 76, green: 162, blue: 255, alpha: 1), UIColor(red: 255, green: 112, blue: 101, alpha: 1), UIColor(red: 251, green: 196, blue: 73, alpha: 1)]
    
    var pageViewController: UIPageViewController!
    var stopDisplayAnimation: Bool = false
    var timer: Timer?
    var currentPageContentVC: StarterPageContentViewController?
    
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
        pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "idStarterPageViewController") as! UIPageViewController
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        let pageContentViewController = viewControllerAtIndex(0) as? StarterPageContentViewController
        pageViewController.setViewControllers([pageContentViewController!], direction: .forward, animated: true, completion: nil)
        addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController.didMove(toParentViewController: self)
        
        self.view.bringSubview(toFront: pageControl)
        self.view.bringSubview(toFront: iPhoneImageView)
        self.view.bringSubview(toFront: connexionButton)
        self.view.bringSubview(toFront: registerButton)
        
        connexionButton.animatedLikeBubbleWithDelay(0.5, duration: 0.5)
        registerButton.animatedLikeBubbleWithDelay(0.5, duration: 0.5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 48.0, green: 73.0, blue: 100.0, alpha: 1.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let currentPageContentVC = pageViewController.viewControllers![0] as! StarterPageContentViewController
        currentPageContentVC.buildUI()
        startTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopTimer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        constraintTopToSuperview.constant = 0.70 * self.view.frame.height
        if case 0...(pageViewController.viewControllers!.count - 1) = pageControl.currentPage {
            let currentViewController = self.pageViewController.viewControllers?[pageControl.currentPage] as! StarterPageContentViewController
            constraintiPhoneTopToView.constant = currentViewController.backgroundImageView.frame.height - self.iPhoneImageView.frame.height
        }
    }
    
    
//MARK: Timer Methods
    
    func startTimer() {
        if timer != nil {
            return
        }
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(StarterPageViewController.updateTimer), userInfo: nil, repeats: true)
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
            let firstPageContentViewController = viewControllerAtIndex(pageControl.currentPage) as? StarterPageContentViewController
            pageViewController.setViewControllers([firstPageContentViewController!], direction: .reverse, animated: true,
            completion: {(_) in
                firstPageContentViewController?.buildUI()
                self.pageControl.updateCurrentPageDisplay()
            })
            
        } else {
            pageControl.currentPage += 1
            let nextPageContentViewController = viewControllerAtIndex(pageControl.currentPage) as? StarterPageContentViewController
            pageViewController.setViewControllers([nextPageContentViewController!], direction: .forward, animated: true, completion: { (_) in
                nextPageContentViewController?.buildUI()
                self.pageControl.updateCurrentPageDisplay()
            })
        }
    }
    
    
//MARK: Page View Controller Data Source
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        resetTimer()
        
        var index = (viewController as! StarterPageContentViewController).pageIndex!
        if index == 0 {
            return nil
        }
        index -= 1
        
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        resetTimer()
        
        var index = (viewController as! StarterPageContentViewController).pageIndex!
        index += 1
        if(index == kPageViewCount) {
            return nil
        }
        return viewControllerAtIndex(index)
    }
    
    
//MARK: Page View Controller Delegate
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        let viewController = self.pageViewController.viewControllers![0] as! StarterPageContentViewController
        viewController.buildUI()
        
        if finished {
            let currentIndex = viewController.pageIndex
            pageControl.currentPage = currentIndex!
            pageControl.updateCurrentPageDisplay()
        }
    }
    
    func viewControllerAtIndex(_ index : Int) -> UIViewController? {
        if((kPageViewCount == 0) || (index >= kPageViewCount)) {
            return nil
        }
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "idStarterPage\(index+1)ContentViewController") as! StarterPageContentViewController
        
        // force instantiate pageContentViewController IBOutlets
        _ = pageContentViewController.view
        pageContentViewController.pageIndex = index
        
        return pageContentViewController
    }
}
