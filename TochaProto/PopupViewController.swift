//
//  PopupViewController.swift
//  Docha
//
//  Created by Mathis D on 26/07/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

public enum PopupType: Int {
    case loading
    case infos
    case error
    case success
    case reward
}

public enum PopupRewardType {
    case badge
    case dochos
    case levelUP
}

class PopupViewController: UIViewController {
    var titlePopup: String? {
        didSet {
            self.popupView?.titleLabel.text = titlePopup
        }
    }
    var messagePopup: String? {
        didSet {
            self.popupView?.messageLabel.text = messagePopup
        }
    }
    
    var popupView: PopupView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        self.popupView = PopupView.loadFromNibNamed("PopupView") as? PopupView
        
        if let _ = self.popupView {
            self.popupView?.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(self.popupView!)
            self.view.addConstraint(NSLayoutConstraint(item: popupView!, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0.0))
            self.view.addConstraint(NSLayoutConstraint(item: popupView!, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0.0))
            self.view.addConstraint(NSLayoutConstraint(item: popupView!, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0.0))
            self.view.addConstraint(NSLayoutConstraint(item: popupView!, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0.0))
            
            self.popupView!.titleLabel.text = self.titlePopup
            self.popupView!.messageLabel.text = self.messagePopup
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}

class DonePopupViewController: PopupViewController {
    
    var doneButton: UIButton?
    var doneActionCompletion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.doneButton = UIButton(type: .custom)
        self.doneButton?.setImage(UIImage(named: "btn_jaicompris"), for: UIControlState())
        self.doneButton?.addTarget(self, action: #selector(DonePopupViewController.doneButtonTouched), for: .touchUpInside)
        self.doneButton?.translatesAutoresizingMaskIntoConstraints = false
        
        self.popupView!.containerStackView.addArrangedSubview(self.doneButton!)
    }
    
    func doneButtonTouched() {
        PopupManager.sharedInstance.dismissPopup(true, completion: nil)
        self.doneActionCompletion?()
    }
}

class SuccessPopupViewController: DonePopupViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popupView!.circleImageView.image = UIImage(named: "icon_popup_success")
        self.popupView!.backgroundImageView.image = UIImage(named: "popup_small")
    }
}


class ErrorPopupViewController: DonePopupViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popupView!.circleImageView.image = UIImage(named: "icon_popup_error")
        self.popupView!.backgroundImageView.image = UIImage(named: "popup_small")
    }
}

class InfosPopupViewController: DonePopupViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popupView!.backgroundImageView.image = UIImage(named: "popup_small")
        self.popupView!.circleImageView.image = UIImage(named: "icon_popup_info")
    }
}

class LoadingPopViewController: PopupViewController {
    
    var loaderImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.popupView!.backgroundImageView.image = UIImage(named: "popup_small")
        self.popupView!.circleImageView.image = UIImage(named: "rond_popup_redDocha")
        
        var imagesArray: [UIImage] = []
        for index in 1...35 {
            imagesArray.append(UIImage(named: String("loader_\(index)"))!)
        }
        loaderImageView = UIImageView()
        loaderImageView!.animationImages = imagesArray
        loaderImageView!.animationDuration = 1.5
        loaderImageView!.translatesAutoresizingMaskIntoConstraints = false
        self.popupView!.circleImageView.addSubview(loaderImageView!)
        self.popupView!.circleImageView.addConstraint(NSLayoutConstraint(item: loaderImageView!, attribute: .centerX, relatedBy: .equal, toItem: self.popupView!.circleImageView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        self.popupView!.circleImageView.addConstraint(NSLayoutConstraint(item: loaderImageView!, attribute: .centerY, relatedBy: .equal, toItem: self.popupView!.circleImageView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        loaderImageView!.startAnimating()
    }
}

class RewardPopupViewController: DonePopupViewController {
    
    var popupRewardType: PopupRewardType?
    var shareButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.shareButton = UIButton(type: .custom)
        self.shareButton?.setImage(UIImage(named: "btn_facebook"), for: UIControlState())
        self.shareButton?.addTarget(self, action: #selector(RewardPopupViewController.shareButtonTouched), for: .touchUpInside)
        self.shareButton?.translatesAutoresizingMaskIntoConstraints = false
        
        self.popupView!.containerStackView.insertArrangedSubview(self.shareButton!, at: self.popupView!.containerStackView.arrangedSubviews.count)
        
        if let rewardType = self.popupRewardType {
            if rewardType == .badge {
                
                
            } else if rewardType == .dochos {
                
                
            } else if rewardType == .levelUP {
                self.popupView!.circleImageView.image = UIImage(named: "img_levelup")
            }
        }
    }
    
    func shareButtonTouched() {
        
    }
}
