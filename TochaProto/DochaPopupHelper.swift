//
//  DochaPopupHelper.swift
//  Docha
//
//  Created by Mathis D on 24/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import SCLAlertView

public class DochaPopupHelper {
    
    class var sharedInstance: DochaPopupHelper {
        struct Singleton {
            static let instance = DochaPopupHelper()
        }
        return Singleton.instance
    }
    
    var alertViewResponder: SCLAlertViewResponder?
    
    public enum DochaPopupHelperType {
        case Loading
        case Infos
        case Error
    }
    
    func showLoadingPopup() {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "Montserrat-ExtraBold", size: 20)!,
            kTextFont: UIFont(name: "Montserrat-SemiBold", size: 14)!,
            kButtonFont: UIFont(name: "Montserrat-SemiBold", size: 14)!,
            showCloseButton: false
        )
        
        // Initialize SCLAlertView using custom Appearance
        let alert = SCLAlertView(appearance: appearance)
        
        // Creat the subview
        let subview = UIView(frame: CGRectMake(0,0,216,70))
        
        // Add the subview to the alert's UI property
        alert.customSubview = subview
        self.alertViewResponder = alert.showWait("Connexion...", subTitle: "Veuillez patientez quelques instants")
    }
    
    func showInfosPopup() {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "Montserrat-ExtraBold", size: 20)!,
            kTextFont: UIFont(name: "Montserrat-SemiBold", size: 14)!,
            kButtonFont: UIFont(name: "Montserrat-SemiBold", size: 14)!,
            showCloseButton: true
        )
        
        // Initialize SCLAlertView using custom Appearance
        let alert = SCLAlertView(appearance: appearance)
        
        // Creat the subview
        let subview = UIView(frame: CGRectMake(0,0,216,70))
        
        // Add the subview to the alert's UI property
        alert.customSubview = subview
        self.alertViewResponder = alert.showInfo("", subTitle: "")
    }
    
    func showErrorPopupWithTitle(title: String, subTitle: String) {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "Montserrat-ExtraBold", size: 20)!,
            kTextFont: UIFont(name: "Montserrat-SemiBold", size: 14)!,
            kButtonFont: UIFont(name: "Montserrat-SemiBold", size: 14)!,
            showCloseButton: true
        )
        
        // Initialize SCLAlertView using custom Appearance
        let alert = SCLAlertView(appearance: appearance)
        
        // Creat the subview
        let subview = UIView(frame: CGRectMake(0,0,216,70))
        
        // Add the subview to the alert's UI property
        alert.customSubview = subview
        self.alertViewResponder = alert.showError(title, subTitle: subTitle)
    }
    
    func dismissAlertView() {
        self.alertViewResponder?.close()
    }
}