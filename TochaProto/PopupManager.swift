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
    var popupWaitingArray: [[String: Any?]]?
    var isDisplayingPopup: Bool = false
    
    func showSuccessPopup(_ title: String? = "Succès", message: String?, viewController: UIViewController? = nil, completion: (() -> Void)? = nil, doneActionCompletion: (() -> Void)? = nil) {
        if isDisplayingPopup == true {
            if popupWaitingArray == nil {
                popupWaitingArray = []
            }
            addWaitingPopup(with: .success, andTitle: title, andMessage: message)
            return
        }
        isDisplayingPopup = true
        let currentPopupViewController = SuccessPopupViewController()
        currentPopupViewController.modalPresentationStyle = .overCurrentContext
        currentPopupViewController.titlePopup = title
        currentPopupViewController.messagePopup = message
        currentPopupViewController.doneActionCompletion = doneActionCompletion
        popupViewController = currentPopupViewController
        
        if let rootController = UIApplication.rootViewControllerForPopup() {
            if let vc = viewController {
                addBackgroundViewForCurrentViewController(vc)
                vc.present(popupViewController!, animated: true,
                    completion: {
                        completion?()
                    }
                )
                
            } else {
                addBackgroundViewForCurrentViewController(rootController)
                rootController.present(popupViewController!, animated: true,
                    completion: {
                        completion?()
                    }
                )
            }
        }
    }
    
    func showErrorPopup(_ title: String? = "Oups !", message: String?, viewController: UIViewController? = nil, completion: (() -> Void)? = nil, doneActionCompletion: (() -> Void)? = nil) {
        if isDisplayingPopup == true {
            if popupWaitingArray == nil {
                popupWaitingArray = []
            }
            addWaitingPopup(with: .error, andTitle: title, andMessage: message)
            return
        }
        isDisplayingPopup = true
        let currentPopupViewController = ErrorPopupViewController()
        currentPopupViewController.modalPresentationStyle = .overCurrentContext
        currentPopupViewController.titlePopup = title
        currentPopupViewController.messagePopup = message
        currentPopupViewController.doneActionCompletion = doneActionCompletion
        popupViewController = currentPopupViewController
        
        if let rootController = UIApplication.rootViewControllerForPopup() {
            if let vc = viewController {
                addBackgroundViewForCurrentViewController(vc)
                vc.present(popupViewController!, animated: true,
                    completion: {
                        completion?()
                    }
                )
                
            } else {
                addBackgroundViewForCurrentViewController(rootController)
                rootController.present(popupViewController!, animated: true,
                    completion: {
                        completion?()
                    }
                )
            }
        }
    }
    
    func showInfosPopup(_ title: String? = "Information", message: String?, viewController: UIViewController? = nil, completion: (() -> Void)? = nil, doneActionCompletion: (() -> Void)? = nil) {
        if isDisplayingPopup == true {
            if popupWaitingArray == nil {
                popupWaitingArray = []
            }
            addWaitingPopup(with: .infos, andTitle: title, andMessage: message)
            return
        }
        isDisplayingPopup = true
        let currentPopupViewController = InfosPopupViewController()
        currentPopupViewController.modalPresentationStyle = .overCurrentContext
        currentPopupViewController.titlePopup = title
        currentPopupViewController.messagePopup = message
        currentPopupViewController.doneActionCompletion = doneActionCompletion
        popupViewController = currentPopupViewController
        
        if let rootController = UIApplication.rootViewControllerForPopup() {
            if let vc = viewController {
                addBackgroundViewForCurrentViewController(vc)
                vc.present(popupViewController!, animated: true,
                    completion: {
                        completion?()
                    }
                )
                
            } else {
                addBackgroundViewForCurrentViewController(rootController)
                rootController.present(popupViewController!, animated: true,
                    completion: {
                        completion?()
                    }
                )
            }
        }
    }
    
    func showLoadingPopup(_ title: String? = "Chargement en cours...", message: String?, viewController: UIViewController? = nil, completion: (() -> Void)?) {
        if isDisplayingPopup == true {
            if popupWaitingArray == nil {
                popupWaitingArray = []
            }
            addWaitingPopup(with: .loading, andTitle: title, andMessage: message)
            return
        }
        isDisplayingPopup = true
        let currentPopupViewController = LoadingPopViewController()
        currentPopupViewController.modalPresentationStyle = .overCurrentContext
        currentPopupViewController.titlePopup = title
        currentPopupViewController.messagePopup = message
        popupViewController = currentPopupViewController
        
        if let rootController = UIApplication.rootViewControllerForPopup() {
            if let vc = viewController {
                addBackgroundViewForCurrentViewController(vc)
                vc.present(popupViewController!, animated: true,
                    completion: {
                        completion?()
                    }
                )
                
            } else {
                addBackgroundViewForCurrentViewController(rootController)
                rootController.present(popupViewController!, animated: true,
                    completion: {
                        completion?()
                    }
                )
            }
        }
    }
    
    func showRewardPopup(_ title: String? = "Bravo !", message: String?, completion: (() -> Void)?, doneActionCompletion: (() -> Void)? = nil) {
        if isDisplayingPopup == true {
            if popupWaitingArray == nil {
                popupWaitingArray = []
            }
            
            addWaitingPopup(with: .reward, andTitle: title, andMessage: message)
            return
        }
        isDisplayingPopup = true
        let currentPopupViewController = RewardPopupViewController()
        currentPopupViewController.modalPresentationStyle = .overCurrentContext
        currentPopupViewController.titlePopup = title
        currentPopupViewController.messagePopup = message
        currentPopupViewController.doneActionCompletion = doneActionCompletion
        popupViewController = currentPopupViewController
        
        if let rootController = UIApplication.rootViewControllerForPopup() {
            addBackgroundViewForCurrentViewController(rootController)
            rootController.present(popupViewController!, animated: true,
                completion: {
                    completion?()
                }
            )
        }
    }
    
    private func addWaitingPopup(with popupType: PopupType, andTitle title: String?, andMessage message: String?) {
        popupWaitingArray?.append(["popupType": popupType.rawValue as Optional<AnyObject>, "title": title as Optional<AnyObject>, "message": message as Optional<AnyObject>])
    }
    
    func launchNextWaitingPopup() {
        if popupWaitingArray?.isEmpty == true {
            return
        }
        let nextPopupType = PopupType(rawValue:(((popupWaitingArray?.last!["popupType"])! as AnyObject).intValue)!)! as PopupType
        let title = popupWaitingArray?.last!["title"] as? String
        let message = popupWaitingArray?.last!["message"] as? String
        
        switch nextPopupType {
        case .loading:
            showLoadingPopup(title, message: message, completion: nil)
            break
        case .error:
            showErrorPopup(title, message: message, completion: nil)
            break
        case .infos:
            showInfosPopup(title, message: message, completion: nil)
            break
        case .reward:
            showRewardPopup(title, message: message, completion: nil)
            break
        default:
            // Success
            showSuccessPopup(title, message: message, completion: nil)
            break
        }
        
        popupWaitingArray?.removeLast()
    }
    
    func addBackgroundViewForCurrentViewController(_ viewController: UIViewController) {
        backgroundView = UIView(frame: viewController.view.frame)
        backgroundView!.backgroundColor = UIColor.black
        backgroundView!.alpha = 0.0
        backgroundView?.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(backgroundView!)
        
        viewController.view.addConstraint(NSLayoutConstraint(item: backgroundView!, attribute: .top, relatedBy: .equal, toItem: viewController.view, attribute: .top, multiplier: 1.0, constant: 0.0))
        viewController.view.addConstraint(NSLayoutConstraint(item: backgroundView!, attribute: .bottom, relatedBy: .equal, toItem: viewController.view, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        viewController.view.addConstraint(NSLayoutConstraint(item: backgroundView!, attribute: .leading, relatedBy: .equal, toItem: viewController.view, attribute: .leading, multiplier: 1.0, constant: 0.0))
        viewController.view.addConstraint(NSLayoutConstraint(item: backgroundView!, attribute: .trailing, relatedBy: .equal, toItem: viewController.view, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView!.alpha = 0.5
        }) 
    }
    
    func dismissBackgroundView() {
        var backgroundViewCopy = self.backgroundView
        
        UIView.animate(withDuration: 0.3,
            animations: {
                backgroundViewCopy!.alpha = 0.0
                
        },  completion: { (_) in
                backgroundViewCopy!.removeFromSuperview()
                backgroundViewCopy = nil
            }
        )
    }
    
    func dismissPopup(_ animated: Bool, completion: (() -> Void)?) {
        if isDisplayingPopup {
            dismissBackgroundView()
            popupViewController?.dismiss(animated: true, completion: nil)
            isDisplayingPopup = false
            
            if popupWaitingArray != nil || popupWaitingArray?.isEmpty == false {
                PopupManager.sharedInstance.launchNextWaitingPopup()
                
            } else {
                DispatchQueue.main.async {
                    self.backgroundView?.removeFromSuperview()
                }
            }
        }
        
        if let completion = completion {
            completion()
        }
    }
    
    func isDisplayingNetworkPopup() -> Bool {
        if isDisplayingPopup {
            if popupViewController is LoadingPopViewController {
                return true
            }
        }
        
        return false
    }
}
