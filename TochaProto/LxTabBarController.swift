//
//  LxTabBarController.swift
//  LxTabBarControllerDemo
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


enum LxTabBarControllerInteractionStopReason {

    case finished, cancelled, failed
}

let LxTabBarControllerDidSelectViewControllerNotification = "LxTabBarControllerDidSelectViewControllerNotification"

private enum LxTabBarControllerSwitchType {

    case unknown, last, next
}

let TRANSITION_DURATION = 0.2
private var _switchType = LxTabBarControllerSwitchType.unknown

class Transition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TRANSITION_DURATION
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        transitionContext.containerView.insertSubview(toViewController.view, aboveSubview: fromViewController.view)
        
        switch _switchType {
            
        case .last:
            toViewController.view.frame.origin.x = -toViewController.view.frame.size.width
        case .next:
            toViewController.view.frame.origin.x = toViewController.view.frame.size.width
        case .unknown:
            break
        }
        
        UIView.animate(withDuration: TRANSITION_DURATION, animations: { () -> Void in
            
            switch _switchType {
                
            case .last:
                fromViewController.view.frame.origin.x = fromViewController.view.frame.size.width
            case .next:
                fromViewController.view.frame.origin.x = -fromViewController.view.frame.size.width
            case .unknown:
                break
            }
            toViewController.view.frame = transitionContext.containerView.bounds
            
        }, completion: { (finished) -> Void in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }) 
    }
}

class LxTabBarController: UITabBarController,UITabBarControllerDelegate,UIGestureRecognizerDelegate {
   
    var panToSwitchGestureRecognizerEnabled: Bool {
    
        get {
            return _panToSwitchGestureRecognizer.isEnabled
        }
        set {
            _panToSwitchGestureRecognizer.isEnabled = newValue
        }
    }
    
    var recognizeOtherGestureSimultaneously = false
    var isTranslating = false
    var panGestureRecognizerBeginBlock = { () -> Void in }
    var panGestureRecognizerStopBlock = { (stopReason: LxTabBarControllerInteractionStopReason) -> Void in }
    
    let _panToSwitchGestureRecognizer = UIPanGestureRecognizer()
    var _interactiveTransition: UIPercentDrivenInteractiveTransition?
    
    convenience init () {
        self.init(nibName: nil, bundle: nil)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        setup()
    }
    
    func setup() {
    
        self.delegate = self
        
        _panToSwitchGestureRecognizer.addTarget(self, action: #selector(LxTabBarController.panGestureRecognizerTriggerd(_:)))
        _panToSwitchGestureRecognizer.delegate = self
        _panToSwitchGestureRecognizer.cancelsTouchesInView = false
        _panToSwitchGestureRecognizer.maximumNumberOfTouches = 1
        view.addGestureRecognizer(_panToSwitchGestureRecognizer)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
     
        return animationController is Transition ? _interactiveTransition : nil
    }
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return Transition()
    }
    
    func panGestureRecognizerTriggerd(_ pan: UIPanGestureRecognizer) {
    
        var progress = pan.translation(in: pan.view!).x / pan.view!.bounds.size.width
        
        if progress > 0 {
            _switchType = .last
        }
        else if progress < 0 {
            _switchType = .next
        }
        else {
            _switchType = .unknown
        }
        
        progress = abs(progress)
        progress = max(0, progress)
        progress = min(1, progress)
        
        switch pan.state {
            
        case .began:
            isTranslating = true
            _interactiveTransition = UIPercentDrivenInteractiveTransition()
            switch _switchType {
                
            case .last:
                selectedIndex = max(0, selectedIndex - 1)
                selectedViewController = viewControllers![selectedIndex]
                panGestureRecognizerBeginBlock()
            case .next:
                selectedIndex = min(viewControllers!.count, selectedIndex + 1)
                selectedViewController = viewControllers![selectedIndex]
                panGestureRecognizerBeginBlock()
            case .unknown:
                break
            }
        case .changed:
            _interactiveTransition?.update(CGFloat(progress))
        case .failed:
            isTranslating = false
            panGestureRecognizerStopBlock(.failed)
        default:
            
            if abs(progress) > 0.5 {
                
                _interactiveTransition?.finish()
                panGestureRecognizerStopBlock(.finished)
            }
            else {
                _interactiveTransition?.cancel()
                panGestureRecognizerStopBlock(.cancelled)
            }
            
            _interactiveTransition = nil
            isTranslating = false
        }
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer == _panToSwitchGestureRecognizer {
            
            return !isTranslating
        }
        else {
            return true
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer == _panToSwitchGestureRecognizer || otherGestureRecognizer == _panToSwitchGestureRecognizer {
        
            return recognizeOtherGestureSimultaneously
        }
        else {
            return false
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let viewControllerIndex = (tabBarController.viewControllers as [UIViewController]!).index(of: viewController)
        
        if viewControllerIndex > selectedIndex {
            _switchType = .next
        }
        else if viewControllerIndex < selectedIndex {
            _switchType = .last
        }
        else {
            _switchType = .unknown
        }
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: LxTabBarControllerDidSelectViewControllerNotification), object: nil)
    }
}
