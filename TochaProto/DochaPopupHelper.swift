//
//  DochaPopupHelper.swift
//  Docha
//
//  Created by Mathis D on 24/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import SCLAlertView
import NVActivityIndicatorView

public class DochaPopupHelper {
    
    class var sharedInstance: DochaPopupHelper {
        struct Singleton {
            static let instance = DochaPopupHelper()
        }
        return Singleton.instance
    }
    
    var alertController: UIAlertController?
    
    public enum DochaPopupHelperType {
        case Loading
        case Infos
        case Error
    }
    
    func showErrorPopup(title: String?="", message: String?) -> UIAlertController? {
        self.alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        self.alertController?.addAction(UIAlertAction(title: "D'accord", style: .Default, handler: { (_) in
            self.alertController?.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        return self.alertController
    }
    
    func showInfoPopup(title: String?="", message: String?) -> UIAlertController? {
        self.alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        self.alertController?.addAction(UIAlertAction(title: "D'accord", style: .Default, handler: { (_) in
            self.alertController?.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        return self.alertController
    }
    
    func showSuccessPopup(title: String?="", message: String?) -> UIAlertController? {
        self.alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        self.alertController?.addAction(UIAlertAction(title: "D'accord", style: .Default, handler: { (_) in
            self.alertController?.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        return self.alertController
    }
    
    func showLoadingPopup(title: String?="") -> UIAlertController? {
        self.alertController = UIAlertController(title: title, message: nil, preferredStyle: .Alert)
        self.alertController?.view.frame = CGRectMake(0.0, 0.0, 200, 200)
        let heightConstraint = NSLayoutConstraint(item: self.alertController!.view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 120)
        self.alertController!.view.addConstraint(heightConstraint)
        let widthConstraint = NSLayoutConstraint(item: self.alertController!.view, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 300)
        self.alertController!.view.addConstraint(widthConstraint)
        
        //create an activity indicator
        let rect = self.alertController?.view.frame
        let indicatorView = NVActivityIndicatorView(frame: CGRectMake((rect?.width)!/2 + 10.0, 60.0, 50.0, 50.0), type: NVActivityIndicatorType.BallClipRotate, color: UIColor.blueDochaColor(), padding: 0.0)
        self.alertController?.view.addSubview(indicatorView)
        
        indicatorView.startAnimation()
        
        return self.alertController
    }
    
    func dismissCurrentPopup() {
        self.alertController?.dismissViewControllerAnimated(false, completion: nil)
        self.alertController = nil
    }
}