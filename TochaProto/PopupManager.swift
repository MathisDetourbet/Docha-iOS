//
//  PopupManager.swift
//  Docha
//
//  Created by Mathis D on 26/07/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

class PopupManager {
    
    class var sharedInstance: PopupManager {
        struct Singleton {
            static let instance = PopupManager()
        }
        return Singleton.instance
    }
    
    let idPopupViewController = "idPopupViewController"
    var popupViewController: PopupViewController?
    var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var backgroundView: UIView?
    var popupWaitingArray: [[String: AnyObject?]]?
    var isDisplayingPopup: Bool = false
    
    func showSuccessPopup(title: String? = "Succès", message: String?, completion: (() -> Void)?) {
        if self.isDisplayingPopup == true {
            if self.popupWaitingArray == nil {
                self.popupWaitingArray = []
            }
            self.popupWaitingArray?.append(["popupType": PopupType.Success.rawValue, "title": title, "message": message])
            return
        }
        self.isDisplayingPopup = true
        self.popupViewController = SuccessPopupViewController()
        self.popupViewController?.modalPresentationStyle = .OverCurrentContext
        self.popupViewController?.titlePopup = title
        self.popupViewController?.messagePopup = message
        
        if let rootController = UIApplication.rootViewControllerForPopup() {
            addBackgroundViewForCurrentViewController(rootController)
            rootController.presentViewController(self.popupViewController!, animated: true, completion: {
                completion?()
            })
        }
    }
    
    func showErrorPopup(title: String? = "Oups !", message: String?, completion: (() -> Void)?) {
        if self.isDisplayingPopup == true {
            if self.popupWaitingArray == nil {
                self.popupWaitingArray = []
            }
            self.popupWaitingArray?.append(["popupType": PopupType.Error.rawValue, "title": title, "message": message])
            return
        }
        self.isDisplayingPopup = true
        self.popupViewController = ErrorPopupViewController()
        self.popupViewController?.modalPresentationStyle = .OverCurrentContext
        self.popupViewController?.titlePopup = title
        self.popupViewController?.messagePopup = message
        
        if let rootController = UIApplication.rootViewControllerForPopup() {
            addBackgroundViewForCurrentViewController(rootController)
            rootController.presentViewController(self.popupViewController!, animated: true, completion: {
                completion?()
            })
        }
    }
    
    func showInfosPopup(title: String? = "Information", message: String?, completion: (() -> Void)?) {
        if self.isDisplayingPopup == true {
            if self.popupWaitingArray == nil {
                self.popupWaitingArray = []
            }
            self.popupWaitingArray?.append(["popupType": PopupType.Infos.rawValue, "title": title, "message": message])
            return
        }
        self.isDisplayingPopup = true
        self.popupViewController = InfosPopupViewController()
        self.popupViewController?.hidesBottomBarWhenPushed = true
        self.popupViewController?.modalPresentationStyle = .OverCurrentContext
        self.popupViewController?.titlePopup = title
        self.popupViewController?.messagePopup = message
        
        if let rootController = UIApplication.rootViewControllerForPopup() {
            addBackgroundViewForCurrentViewController(rootController)
            rootController.presentViewController(self.popupViewController!, animated: true, completion: {
                completion?()
            })
        }
    }
    
    func showLoadingPopup(title: String? = "Chargement en cours...", message: String?, completion: (() -> Void)?) {
        if self.isDisplayingPopup == true {
            if self.popupWaitingArray == nil {
                self.popupWaitingArray = []
            }
            self.popupWaitingArray?.append(["popupType": PopupType.Loading.rawValue, "title": title, "message": message])
            return
        }
        self.isDisplayingPopup = true
        self.popupViewController = LoadingPopViewController()
        self.popupViewController?.modalPresentationStyle = .OverCurrentContext
        self.popupViewController?.titlePopup = title
        self.popupViewController?.messagePopup = message
        
        if let rootController = UIApplication.rootViewControllerForPopup() {
            addBackgroundViewForCurrentViewController(rootController)
            rootController.presentViewController(self.popupViewController!, animated: true, completion: {
                completion?()
            })
        }
    }
    
    func showRewardPopup(title: String? = "Bravo !", message: String?, completion: (() -> Void)?) {
        if self.isDisplayingPopup == true {
            if self.popupWaitingArray == nil {
                self.popupWaitingArray = []
            }
            let popupType = PopupType.Reward.rawValue as Int
            self.popupWaitingArray?.append(["popupType": popupType, "title": title, "message": message])
            return
        }
        self.isDisplayingPopup = true
        self.popupViewController = RewardPopupViewController()
        self.popupViewController?.modalPresentationStyle = .OverCurrentContext
        self.popupViewController?.titlePopup = title
        self.popupViewController?.messagePopup = message
        
        if let rootController = UIApplication.rootViewControllerForPopup() {
            addBackgroundViewForCurrentViewController(rootController)
            rootController.presentViewController(self.popupViewController!, animated: true, completion: {
                completion?()
            })
        }
    }
    
    func launchNextWaitingPopup() {
        if self.popupWaitingArray?.isEmpty == true {
            return
        }
        let nextPopupType = PopupType(rawValue:((self.popupWaitingArray?.last!["popupType"])!?.integerValue)!)! as PopupType
        let title = self.popupWaitingArray?.last!["title"] as? String
        let message = self.popupWaitingArray?.last!["message"] as? String
        switch nextPopupType {
        case .Loading:
            self.showLoadingPopup(title, message: message, completion: nil)
            break
        case .Error:
            self.showErrorPopup(title, message: message, completion: nil)
            break
        case .Infos:
            self.showInfosPopup(title, message: message, completion: nil)
            break
        case .Reward:
            self.showRewardPopup(title, message: message, completion: nil)
            break
        default:
            // Success
            self.showSuccessPopup(title, message: message, completion: nil)
            break
        }
        
        self.popupWaitingArray?.removeLast()
    }
    
    func addBackgroundViewForCurrentViewController(viewController: UIViewController) {
        self.backgroundView = UIView(frame: viewController.view.frame)
        self.backgroundView!.backgroundColor = UIColor.blackColor()
        self.backgroundView!.alpha = 0.0
        self.backgroundView?.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(self.backgroundView!)
        viewController.view.addConstraint(NSLayoutConstraint(item: self.backgroundView!, attribute: .Top, relatedBy: .Equal, toItem: viewController.view, attribute: .Top, multiplier: 1.0, constant: 0.0))
        viewController.view.addConstraint(NSLayoutConstraint(item: self.backgroundView!, attribute: .Bottom, relatedBy: .Equal, toItem: viewController.view, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
        viewController.view.addConstraint(NSLayoutConstraint(item: self.backgroundView!, attribute: .Leading, relatedBy: .Equal, toItem: viewController.view, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        viewController.view.addConstraint(NSLayoutConstraint(item: self.backgroundView!, attribute: .Trailing, relatedBy: .Equal, toItem: viewController.view, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        
        UIView.animateWithDuration(0.3) {
            self.backgroundView!.alpha = 0.5
        }
    }
    
    func dismissBackgroundView() {
        var backgroundViewCopy = self.backgroundView
        UIView.animateWithDuration(0.3, animations: {
            backgroundViewCopy!.alpha = 0.0
        }) { (_) in
            backgroundViewCopy!.removeFromSuperview()
            backgroundViewCopy = nil
        }
    }
    
    func dismissPopup(animated: Bool, completion: (() -> Void)?) {
        self.dismissBackgroundView()
        self.popupViewController?.dismissViewControllerAnimated(true, completion: completion)
        
        self.isDisplayingPopup = false
        if self.popupWaitingArray != nil || self.popupWaitingArray?.isEmpty == false {
            PopupManager.sharedInstance.launchNextWaitingPopup()
            
        } else {
            dispatch_async(dispatch_get_main_queue()) {
                self.backgroundView?.removeFromSuperview()
            }
        }
    }
}
