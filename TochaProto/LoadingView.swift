//
//  LoadingView.swift
//  Docha
//
//  Created by Mathis D on 21/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

enum LoadingType {
    case Inscription
    case Gameplay
}

class LoadingView: UIView {
    
    var loadingType: LoadingType?
    var indicatorView: NVActivityIndicatorView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadingType = .Gameplay
    }
    
    convenience init(frame: CGRect, loadingType: LoadingType) {
        self.init(frame: frame)
        
        self.loadingType = loadingType
        let rect = CGRectMake((self.frame.width / 2) - 50, (self.frame.height / 2) - 50, 70.0, 70.0)
        self.indicatorView = NVActivityIndicatorView(frame: rect, type: NVActivityIndicatorType.BallPulseSync, color: UIColor.whiteColor(), padding: 0.0)
        self.addSubview(indicatorView!)
        self.backgroundColor = UIColor.darkBlueDochaColor()
        self.alpha = 0.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startLoading() {
        UIView.animateWithDuration(0.2, animations: {
            self.alpha = 0.7
            
        }) { (finished) in
            self.indicatorView?.startAnimation()
        }
    }
    
    func resumeLoading() {
        self.indicatorView?.stopAnimation()
    }
    
    func dismissView() {
        UIView.animateWithDuration(0.2, animations: {
            self.alpha = 0.0
            
            }, completion: { (finished) in
                self.removeFromSuperview()
                self.indicatorView?.stopAnimation()
        })
    }
}