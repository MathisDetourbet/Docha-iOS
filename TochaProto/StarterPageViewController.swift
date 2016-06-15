//
//  StarterPageViewController.swift
//  DochaProto
//
//  Created by Mathis D on 22/05/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

extension UIView {
    func animatedLikeBubbleWithDelay(delay: NSTimeInterval, duration: NSTimeInterval) {
        self.transform = CGAffineTransformMakeScale(0.0, 0.0)
        UIView.animateWithDuration(duration,
                                   delay: delay,
                                   usingSpringWithDamping: 0.6,
                                   initialSpringVelocity: 3.0,
                                   options: .AllowUserInteraction,
                                   animations:
            {
                self.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
}

class StarterPageViewController: RootViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    let pageTitles = ["Bienvenue !", "Joue avec tes produits préférés", "Gagnes des cadeaux et des réductions"]
    let subTitles = ["Devines des privart gagnes des cadeaux.", "Des milliers de produits sont à découvrir seul ou entre amis.", "Le seul jeu mobile qui te récompense et te fait ganger des cadeaux."]
    let images = ["phone.png", "mainphoto.png", "phone.png"]
    let colors = [UIColor(red: 76, green: 162, blue: 255, alpha: 1), UIColor(red: 255, green: 112, blue: 101, alpha: 1), UIColor(red: 251, green: 196, blue: 73, alpha: 1)]
    
    var pageViewController: UIPageViewController!
    //var startTouchLocation: CGPoint?
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var connexionButton: UIButton!
    @IBOutlet weak var iPhoneImageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var constraintTopToSuperview: NSLayoutConstraint!
    @IBOutlet weak var constraintiPhoneTopToView: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("idPageViewController") as! UIPageViewController
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        let pageContentViewController = self.viewControllerAtIndex(0)
        pageViewController.setViewControllers([pageContentViewController!], direction: .Forward, animated: true, completion: nil)
        pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height - 90)
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
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! StarterPageContentViewController).pageIndex!
        if(index == 0) {
            return nil
        }
        index -= 1
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! StarterPageContentViewController).pageIndex!
        index += 1
        if(index == self.images.count) {
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished {
            let viewController = self.pageViewController.viewControllers![0] as! StarterPageContentViewController
            let currentIndex = viewController.pageIndex
            self.pageControl.currentPage = currentIndex!
            self.pageControl.updateCurrentPageDisplay()
        }
    }
    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
        if((self.pageTitles.count == 0) || (index >= self.pageTitles.count)) {
            return nil
        }
        let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("idStarterPage\(index+1)ContentViewController") as! StarterPageContentViewController
        
        // force instantiate pageContentViewController IBOutlets
        _ = pageContentViewController.view
        pageContentViewController.pageIndex = index
        
//        if index == self.pageTitles.count-1 {
//            // Set vertical effect
//            let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
//            verticalMotionEffect.minimumRelativeValue = -50
//            verticalMotionEffect.maximumRelativeValue = 50
//            
//            // Set horizontal effect
//            let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
//            horizontalMotionEffect.minimumRelativeValue = -50
//            horizontalMotionEffect.maximumRelativeValue = 50
//            
//            // Create group to combine both
//            let group = UIMotionEffectGroup()
//            group.motionEffects = [horizontalMotionEffect, verticalMotionEffect]
//            
//            // Add both effects to your view
//            for giftImageView in pageContentViewController.allGiftImageViewCollection! {
//                giftImageView.addMotionEffect(group)
//            }
//        }
        
        return pageContentViewController
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.constraintTopToSuperview.constant = 0.55 * self.view.frame.height
        if case 0...(self.pageViewController.viewControllers?.count)!-1 = pageControl.currentPage {
            let currentViewController = self.pageViewController.viewControllers?[pageControl.currentPage] as! StarterPageContentViewController
            self.constraintiPhoneTopToView.constant = currentViewController.backgroundImageView.frame.height - self.iPhoneImageView.frame.height
        }
    }
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        for touch in touches {
//            self.startTouchLocation = touch.locationInView(view)
//        }
//    }
//    
//    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        var location = CGPointMake(0, 0)
//        for touch in touches {
//            location = touch.locationInView(view)
//        }
//        
//        
//    }
}
