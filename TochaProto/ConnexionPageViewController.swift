//
//  ConnexionPageViewController.swift
//  DochaProto
//
//  Created by Mathis D on 13/03/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class ConnexionPageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    let pageTitles = ["Bienvenue !", "Joue avec tes produits préférés", "Gagnes des cadeaux et des réductions"]
    let subTitles = ["Devines des privart gagnes des cadeaux.", "Des milliers de produits sont à découvrir seul ou entre amis.", "Le seul jeu mobile qui te récompense et te fait ganger des cadeaux."]
    let images = ["phone.png", "mainphoto.png", "phone.png"]
    let colors = [UIColor(red: 76, green: 162, blue: 255, alpha: 1), UIColor(red: 255, green: 112, blue: 101, alpha: 1), UIColor(red: 251, green: 196, blue: 73, alpha: 1)]
    
    var pageViewController: UIPageViewController!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
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
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! ConnexionPageContentViewController).pageIndex!
        if(index == 0) {
            return nil
        }
        index -= 1
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! ConnexionPageContentViewController).pageIndex!
        index += 1
        if(index == self.images.count) {
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished {
            let viewController = self.pageViewController.viewControllers![0] as! ConnexionPageContentViewController
            let currentIndex = viewController.pageIndex
            self.pageControl.currentPage = currentIndex!
            self.pageControl.updateCurrentPageDisplay()
        }
    }
    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
        if((self.pageTitles.count == 0) || (index >= self.pageTitles.count)) {
            return nil
        }
        let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("idConnexionPage\(index+1)ContentViewController") as! ConnexionPageContentViewController
        
        // force instantiate pageContentViewController IBOutlets
        _ = pageContentViewController.view
        pageContentViewController.pageIndex = index
        
        if index == self.pageTitles.count-1 {
            // Set vertical effect
            let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
            verticalMotionEffect.minimumRelativeValue = -50
            verticalMotionEffect.maximumRelativeValue = 50
            
            // Set horizontal effect
            let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
            horizontalMotionEffect.minimumRelativeValue = -50
            horizontalMotionEffect.maximumRelativeValue = 50
            
            // Create group to combine both
            let group = UIMotionEffectGroup()
            group.motionEffects = [horizontalMotionEffect, verticalMotionEffect]
            
            // Add both effects to your view
            for giftImageView in pageContentViewController.allGiftImageViewCollection! {
                giftImageView.addMotionEffect(group)
            }
        }
    
        return pageContentViewController
    }
}
