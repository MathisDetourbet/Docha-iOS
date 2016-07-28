//
//  PopupViewController.swift
//  Docha
//
//  Created by Mathis D on 26/07/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

public enum PopupType {
    case Loading
    case Infos
    case Error
    case Success
    case Reward
}

public enum PopupRewardType {
    case Badge
    case Dochos
    case LevelUP
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
        self.view.backgroundColor = UIColor.clearColor()
        self.popupView = PopupView.loadFromNibNamed("PopupView") as? PopupView
        
        if let _ = self.popupView {
            self.popupView?.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(self.popupView!)
            self.view.addConstraint(NSLayoutConstraint(item: popupView!, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 0.0))
            self.view.addConstraint(NSLayoutConstraint(item: popupView!, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
            self.view.addConstraint(NSLayoutConstraint(item: popupView!, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: 0.0))
            self.view.addConstraint(NSLayoutConstraint(item: popupView!, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
            
            self.popupView!.titleLabel.text = self.titlePopup
            self.popupView!.messageLabel.text = self.messagePopup
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func startShadowAnimation() {
        self.popupView!.shadowAnimation()
    }
}

class DonePopupViewController: PopupViewController {
    
    var doneButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.doneButton = UIButton(type: .Custom)
        self.doneButton?.setImage(UIImage(named: "btn_jaicompris"), forState: .Normal)
        self.doneButton?.addTarget(self, action: #selector(DonePopupViewController.doneButtonTouched), forControlEvents: .TouchUpInside)
        self.doneButton?.translatesAutoresizingMaskIntoConstraints = false
        
        self.popupView!.containerStackView.addArrangedSubview(self.doneButton!)
    }
    
    func doneButtonTouched() {
        self.popupView?.shadowView?.alpha = 0.0
        self.dismissViewControllerAnimated(true, completion: nil)
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
        self.popupView!.circleImageView.addConstraint(NSLayoutConstraint(item: loaderImageView!, attribute: .CenterX, relatedBy: .Equal, toItem: self.popupView!.circleImageView, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        self.popupView!.circleImageView.addConstraint(NSLayoutConstraint(item: loaderImageView!, attribute: .CenterY, relatedBy: .Equal, toItem: self.popupView!.circleImageView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        loaderImageView!.startAnimating()
    }
    
    override func dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)?) {
        super.dismissViewControllerAnimated(flag, completion: completion)
        self.loaderImageView?.stopAnimating()
    }
}

class RewardPopupViewController: DonePopupViewController {
    
    var popupRewardType: PopupRewardType?
    var shareButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.shareButton = UIButton(type: .Custom)
        self.shareButton?.setImage(UIImage(named: "btn_facebook"), forState: .Normal)
        self.shareButton?.addTarget(self, action: #selector(RewardPopupViewController.shareButtonTouched), forControlEvents: .TouchUpInside)
        self.shareButton?.translatesAutoresizingMaskIntoConstraints = false
        
        self.popupView!.containerStackView.insertArrangedSubview(self.shareButton!, atIndex: self.popupView!.containerStackView.arrangedSubviews.count)
        
        if let rewardType = self.popupRewardType {
            if rewardType == .Badge {
                
                
            } else if rewardType == .Dochos {
                
                
            } else if rewardType == .LevelUP {
                self.popupView!.circleImageView.image = UIImage(named: "img_levelup")
            }
        }
    }
    
    func shareButtonTouched() {
        
    }
}