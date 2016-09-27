//
//  PopupManager.swift
//  Docha
//
//  Created by Mathis D on 26/07/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
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
    
    func showSuccessPopup(_ title: String? = "Succès", message: String?, viewController: UIViewController? = nil, completion: (() -> Void)? = nil, doneActionCompletion: (() -> Void)? = nil) {
        if self.isDisplayingPopup == true {
            if self.popupWaitingArray == nil {
                self.popupWaitingArray = []
            }
            self.popupWaitingArray?.append(["popupType": PopupType.success.rawValue as Optional<AnyObject>, "title": title as Optional<AnyObject>, "message": message as Optional<AnyObject>])
            return
        }
        self.isDisplayingPopup = true
        let currentPopupViewController = SuccessPopupViewController()
        currentPopupViewController.modalPresentationStyle = .overCurrentContext
        currentPopupViewController.titlePopup = title
        currentPopupViewController.messagePopup = message
        currentPopupViewController.doneActionCompletion = doneActionCompletion
        self.popupViewController = currentPopupViewController
        
        if let rootController = UIApplication.rootViewControllerForPopup() {
            if let vc = viewController {
                addBackgroundViewForCurrentViewController(vc)
                vc.present(self.popupViewController!, animated: true, completion: {
                    completion?()
                })
            } else {
                addBackgroundViewForCurrentViewController(rootController)
                rootController.present(self.popupViewController!, animated: true, completion: {
                    completion?()
                })
            }
        }
    }
    
    func showErrorPopup(_ title: String? = "Oups !", message: String?, viewController: UIViewController? = nil, completion: (() -> Void)? = nil, doneActionCompletion: (() -> Void)? = nil) {
        if self.isDisplayingPopup == true {
            if self.popupWaitingArray == nil {
                self.popupWaitingArray = []
            }
            self.popupWaitingArray?.append(["popupType": PopupType.error.rawValue as Optional<AnyObject>, "title": title as Optional<AnyObject>, "message": message as Optional<AnyObject>])
            return
        }
        self.isDisplayingPopup = true
        let currentPopupViewController = ErrorPopupViewController()
        currentPopupViewController.modalPresentationStyle = .overCurrentContext
        currentPopupViewController.titlePopup = title
        currentPopupViewController.messagePopup = message
        currentPopupViewController.doneActionCompletion = doneActionCompletion
        self.popupViewController = currentPopupViewController
        
        if let rootController = UIApplication.rootViewControllerForPopup() {
            if let vc = viewController {
                addBackgroundViewForCurrentViewController(vc)
                vc.present(self.popupViewController!, animated: true, completion: {
                    completion?()
                })
            } else {
                addBackgroundViewForCurrentViewController(rootController)
                rootController.present(self.popupViewController!, animated: true, completion: {
                    completion?()
                })
            }
        }
    }
    
    func showInfosPopup(_ title: String? = "Information", message: String?, viewController: UIViewController? = nil, completion: (() -> Void)?, doneActionCompletion: (() -> Void)? = nil) {
        if self.isDisplayingPopup == true {
            if self.popupWaitingArray == nil {
                self.popupWaitingArray = []
            }
            
            self.popupWaitingArray?.append(["popupType": PopupType.infos.rawValue as Optional<AnyObject>, "title": title as Optional<AnyObject>, "message": message as Optional<AnyObject>])
            return
        }
        self.isDisplayingPopup = true
        let currentPopupViewController = InfosPopupViewController()
        currentPopupViewController.modalPresentationStyle = .overCurrentContext
        currentPopupViewController.titlePopup = title
        currentPopupViewController.messagePopup = message
        currentPopupViewController.doneActionCompletion = doneActionCompletion
        self.popupViewController = currentPopupViewController
        
        if let rootController = UIApplication.rootViewControllerForPopup() {
            if let vc = viewController {
                addBackgroundViewForCurrentViewController(vc)
                vc.present(self.popupViewController!, animated: true, completion: {
                    completion?()
                })
            } else {
                addBackgroundViewForCurrentViewController(rootController)
                rootController.present(self.popupViewController!, animated: true, completion: {
                    completion?()
                })
            }
        }
    }
    
    func showLoadingPopup(_ title: String? = "Chargement en cours...", message: String?, viewController: UIViewController? = nil, completion: (() -> Void)?) {
        if self.isDisplayingPopup == true {
            if self.popupWaitingArray == nil {
                self.popupWaitingArray = []
            }
            self.popupWaitingArray?.append(["popupType": PopupType.loading.rawValue as Optional<AnyObject>, "title": title as Optional<AnyObject>, "message": message as Optional<AnyObject>])
            return
        }
        self.isDisplayingPopup = true
        let currentPopupViewController = LoadingPopViewController()
        currentPopupViewController.modalPresentationStyle = .overCurrentContext
        currentPopupViewController.titlePopup = title
        currentPopupViewController.messagePopup = message
        self.popupViewController = currentPopupViewController
        
        if let rootController = UIApplication.rootViewControllerForPopup() {
            if let vc = viewController {
                addBackgroundViewForCurrentViewController(vc)
                vc.present(self.popupViewController!, animated: true, completion: {
                    completion?()
                })
            } else {
                addBackgroundViewForCurrentViewController(rootController)
                rootController.present(self.popupViewController!, animated: true, completion: {
                    completion?()
                })
            }
        }
    }
    
    func showRewardPopup(_ title: String? = "Bravo !", message: String?, completion: (() -> Void)?, doneActionCompletion: (() -> Void)? = nil) {
        if self.isDisplayingPopup == true {
            if self.popupWaitingArray == nil {
                self.popupWaitingArray = []
            }
            let popupType = PopupType.reward.rawValue as Int
            self.popupWaitingArray?.append(["popupType": popupType as Optional<AnyObject>, "title": title as Optional<AnyObject>, "message": message as Optional<AnyObject>])
            return
        }
        self.isDisplayingPopup = true
        let currentPopupViewController = RewardPopupViewController()
        currentPopupViewController.modalPresentationStyle = .overCurrentContext
        currentPopupViewController.titlePopup = title
        currentPopupViewController.messagePopup = message
        currentPopupViewController.doneActionCompletion = doneActionCompletion
        self.popupViewController = currentPopupViewController
        
        if let rootController = UIApplication.rootViewControllerForPopup() {
            addBackgroundViewForCurrentViewController(rootController)
            rootController.present(self.popupViewController!, animated: true, completion: {
                completion?()
            })
        }
    }
    
    func launchNextWaitingPopup() {
        if self.popupWaitingArray?.isEmpty == true {
            return
        }
        let nextPopupType = PopupType(rawValue:((self.popupWaitingArray?.last!["popupType"])!?.intValue)!)! as PopupType
        let title = self.popupWaitingArray?.last!["title"] as? String
        let message = self.popupWaitingArray?.last!["message"] as? String
        
        switch nextPopupType {
        case .loading:
            self.showLoadingPopup(title, message: message, completion: nil)
            break
        case .error:
            self.showErrorPopup(title, message: message, completion: nil)
            break
        case .infos:
            self.showInfosPopup(title, message: message, completion: nil)
            break
        case .reward:
            self.showRewardPopup(title, message: message, completion: nil)
            break
        default:
            // Success
            self.showSuccessPopup(title, message: message, completion: nil)
            break
        }
        
        self.popupWaitingArray?.removeLast()
    }
    
    func addBackgroundViewForCurrentViewController(_ viewController: UIViewController) {
        self.backgroundView = UIView(frame: viewController.view.frame)
        self.backgroundView!.backgroundColor = UIColor.black
        self.backgroundView!.alpha = 0.0
        self.backgroundView?.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(self.backgroundView!)
        viewController.view.addConstraint(NSLayoutConstraint(item: self.backgroundView!, attribute: .top, relatedBy: .equal, toItem: viewController.view, attribute: .top, multiplier: 1.0, constant: 0.0))
        viewController.view.addConstraint(NSLayoutConstraint(item: self.backgroundView!, attribute: .bottom, relatedBy: .equal, toItem: viewController.view, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        viewController.view.addConstraint(NSLayoutConstraint(item: self.backgroundView!, attribute: .leading, relatedBy: .equal, toItem: viewController.view, attribute: .leading, multiplier: 1.0, constant: 0.0))
        viewController.view.addConstraint(NSLayoutConstraint(item: self.backgroundView!, attribute: .trailing, relatedBy: .equal, toItem: viewController.view, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView!.alpha = 0.5
        }) 
    }
    
    func dismissBackgroundView() {
        var backgroundViewCopy = self.backgroundView
        UIView.animate(withDuration: 0.3, animations: {
            backgroundViewCopy!.alpha = 0.0
        }, completion: { (_) in
            backgroundViewCopy!.removeFromSuperview()
            backgroundViewCopy = nil
        }) 
    }
    
    func dismissPopup(_ animated: Bool, completion: (() -> Void)?) {
        self.dismissBackgroundView()
        self.popupViewController?.dismiss(animated: true, completion: completion)
        
        self.isDisplayingPopup = false
        if self.popupWaitingArray != nil || self.popupWaitingArray?.isEmpty == false {
            PopupManager.sharedInstance.launchNextWaitingPopup()
            
        } else {
            DispatchQueue.main.async {
                self.backgroundView?.removeFromSuperview()
            }
        }
    }
}
