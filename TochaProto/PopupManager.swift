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
    
    func showSuccessPopup(title: String?="Succès", message: String?) -> SuccessPopupViewController {
        self.popupViewController = SuccessPopupViewController()
        self.popupViewController?.modalPresentationStyle = .OverCurrentContext
        self.popupViewController?.titlePopup = title
        self.popupViewController?.messagePopup = message
        
        return self.popupViewController as! SuccessPopupViewController
    }
    
    
    func showErrorPopup(title: String?="Oups !", message: String?) -> ErrorPopupViewController {
        self.popupViewController = ErrorPopupViewController()
        self.popupViewController?.modalPresentationStyle = .OverCurrentContext
        self.popupViewController?.titlePopup = title
        self.popupViewController?.messagePopup = message
        
        return self.popupViewController as! ErrorPopupViewController
    }
    
    func showInfosPopup(title: String?="Information", message: String?) -> InfosPopupViewController {
        self.popupViewController = InfosPopupViewController()
        self.popupViewController?.hidesBottomBarWhenPushed = true
        self.popupViewController?.modalPresentationStyle = .OverCurrentContext
        self.popupViewController?.titlePopup = title
        self.popupViewController?.messagePopup = message
        
        return self.popupViewController as! InfosPopupViewController
    }
    
    
    func showLoadingPopup(title: String?="Chargement en cours...", message: String?) -> LoadingPopViewController {
        self.popupViewController = LoadingPopViewController()
        self.popupViewController?.modalPresentationStyle = .OverCurrentContext
        self.popupViewController?.titlePopup = title
        self.popupViewController?.messagePopup = message
        
        return self.popupViewController as! LoadingPopViewController
    }
    
    func showRewardPopup(title: String?="Bravo !", message: String?) -> RewardPopupViewController {
        self.popupViewController = RewardPopupViewController()
        self.popupViewController?.modalPresentationStyle = .OverCurrentContext
        self.popupViewController?.titlePopup = title
        self.popupViewController?.messagePopup = message
        
        return self.popupViewController as! RewardPopupViewController
    }
    
    func modalAnimationFinished() {
        self.popupViewController?.startShadowAnimation()
    }
}
