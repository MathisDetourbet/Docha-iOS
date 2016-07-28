//
//  PreferencesViewController.swift
//  Docha
//
//  Created by Mathis D on 06/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import Amplitude_iOS
import PBWebViewController
import FBSDKShareKit

class PreferencesViewController: GameViewController, UITableViewDelegate, UITableViewDataSource, FBSDKSharingDelegate {

    let idNormalTableViewCell = "idNormalTableViewCell"
    let idSwitchTableViewCell = "idSwitchTableViewCell"
    let sections: [String] = ["COMPTE", "PARAMÈTRES", "AUTRES"]
    let cellContent: [[[String:String]]] = [[["title":"Modifier le profil","iconPath": "profil_icon"], ["title":"Changer le mot de passe","iconPath": "password_change_icon"], ["title":"Catégorie préférée","iconPath": "category_selection_icon"]],
                                            [["title":"Notifications","iconPath": "notifications_icon"], ["title":"Newsletter","iconPath": "newsletter_icon"], ["title":"Langue","iconPath": "language_icon"]],
                                            [["title":"À propos","iconPath": "rocket_icon"], ["title":"Que pensez-vous de Docha ?","iconPath": "mail_icon"]]]
    let categorieTranslator: [String: String] = ["lifestyle":"Lifestyle", "high-tech":"Hi-tech", "maison_deco": "Maison & décoration", "bijoux_montres": "Bijoux & montres", "electromenager": "Électroménager", "objets_connectes": "Objets connectés", "gastronomie_vin": "Gastronomie & vin", "beauty": "Beauté", "art": "Art", "sport": "Sport"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Amplitude
        Amplitude.instance().logEvent("Preferences tab opened")
        
        self.buildUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configGameNavigationBar()
        configTitleViewDocha()
        self.tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func buildUI() {
        self.view.backgroundColor = UIColor.lightGrayDochaColor()
        
        let footerView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 123))
        
        let inviteFacebookFriendsButton = UIButton(type: .Custom)
        inviteFacebookFriendsButton.translatesAutoresizingMaskIntoConstraints = false
        inviteFacebookFriendsButton.setImage(UIImage(named: "btn_fb_invit"), forState: .Normal)
        inviteFacebookFriendsButton.addTarget(self, action: #selector(PreferencesViewController.inviteFacebookFriendsButtonTouched), forControlEvents: .TouchUpInside)
        footerView.addSubview(inviteFacebookFriendsButton)
        
        footerView.addConstraint(NSLayoutConstraint(item: inviteFacebookFriendsButton, attribute: .CenterX, relatedBy: .Equal, toItem: footerView, attribute: .CenterX, multiplier: 1, constant: 0))
        footerView.addConstraint(NSLayoutConstraint(item: inviteFacebookFriendsButton, attribute: .Top, relatedBy: .Equal, toItem: footerView, attribute: .Top, multiplier: 1, constant: 15))
        
        let logoutButton = UIButton(type: .Custom)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.setImage(UIImage(named: "btn_logout"), forState: .Normal)
        logoutButton.addTarget(self, action: #selector(PreferencesViewController.logoutButtonTouched), forControlEvents: .TouchUpInside)
        footerView.addSubview(logoutButton)
        
        footerView.addConstraint(NSLayoutConstraint(item: logoutButton, attribute: .Top, relatedBy: .Equal, toItem: inviteFacebookFriendsButton, attribute: .Bottom, multiplier: 1, constant: 10))
        footerView.addConstraint(NSLayoutConstraint(item: logoutButton, attribute: .CenterX, relatedBy: .Equal, toItem: footerView, attribute: .CenterX, multiplier: 1, constant: 0))
        
        self.tableView.tableFooterView = footerView
        self.tableView.backgroundColor = UIColor.lightGrayDochaColor()
    }
    
    
//MARK: Table View Data Source Methods
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellContent[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == 1) && (indexPath.row < self.cellContent[indexPath.section][indexPath.row].count) {
            let cell = tableView.dequeueReusableCellWithIdentifier(self.idSwitchTableViewCell, forIndexPath: indexPath) as? PreferencesSwitchTableViewCell
            let cellTitle = self.cellContent[1][indexPath.row]["title"]
            cell?.titleLabel.text = cellTitle
            if cellTitle == "Langue" {
                cell?.selectionStyle = .None
            }
            cell?.iconImageView.image = UIImage(named: self.cellContent[indexPath.section][indexPath.row]["iconPath"]!)
            
            return cell!
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(self.idNormalTableViewCell, forIndexPath: indexPath) as? PreferencesNormalTableViewCell
            let title = self.cellContent[indexPath.section][indexPath.row]["title"]
            cell?.titleLabel.text = title
            if title! == "Catégorie préférée" {
                cell?.categoryFavoriteLabel.text = self.categorieTranslator[(UserSessionManager.sharedInstance.currentSession()?.categoryFavorite)!]
                cell?.accessoryType = .DisclosureIndicator
            } else {
                (cell?.categoryFavoriteLabel.text = "")
            }
            cell?.widthCategoryLabelConstraint.constant = (cell?.frame.width)! - ((cell?.titleLabel.frame.origin.x)! + (cell?.titleLabel.frame.width)! + 20.0 + 20.0)
            cell?.iconImageView.image = UIImage(named: self.cellContent[indexPath.section][indexPath.row]["iconPath"]!)
            
            return cell!
        }
    }
    
    
//MARK: Table View Delegate Methods
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            // Compte section
            switch indexPath.row {
            case 0:
                // Modifier le profil
                let changeProfilVC = self.storyboard?.instantiateViewControllerWithIdentifier("idPreferencesChangeProfilViewController") as! PreferencesChangeProfilViewController
                self.navigationController?.pushViewController(changeProfilVC, animated: true)
                break
            case 1:
                // Changer le mdp
                let changePasswordVC = self.storyboard?.instantiateViewControllerWithIdentifier("idPreferencesChangePasswordViewController") as! PreferencesChangePasswordViewController
                self.navigationController?.pushViewController(changePasswordVC, animated: true)
                break
            default:
                // Catégories préférées
                let categoriesVC = self.storyboard?.instantiateViewControllerWithIdentifier("idPreferencesCategoryViewController") as! PreferencesCategoriesViewController
                self.navigationController?.pushViewController(categoriesVC, animated: true)
                break
            }
            break
        case 1:
            // Paramètres section
            switch indexPath.row {
            case 2:
                // Langue
                self.tabBarController!.presentViewController(PopupManager.sharedInstance.showInfosPopup("Info", message: "Encore un peu de patience, cette fonctionnalité sera bientôt disponible. 😉"), animated: true) {
                    PopupManager.sharedInstance.modalAnimationFinished()
                }
            default:
                break
            }
            break
        default:
            // Autres section
            if indexPath.row == 0 {
                // A propos
                let aboutVC = self.storyboard?.instantiateViewControllerWithIdentifier("idPreferencesAboutViewController") as! PreferencesAboutViewController
                self.navigationController?.pushViewController(aboutVC, animated: true)
                
            } else if indexPath.row == 1 {
                // Feedbacks
                let url = NSURL(string: "https://morganegr.typeform.com/to/NbeMZ2")
                let feedbackWebVC = self.storyboard?.instantiateViewControllerWithIdentifier("idPreferencesFeedbackWebViewController") as! PreferencesFeedbackViewController
                feedbackWebVC.URL = url
                
                let activity = UIActivity()
                feedbackWebVC.applicationActivities = [activity]
                feedbackWebVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(feedbackWebVC, animated: true)
            }
            break
        }
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader = UIView(frame: CGRectMake(0.0, 0.0, tableView.frame.width, 28))
        viewHeader.backgroundColor = UIColor.lightGrayDochaColor()
        let sectionLabel = UILabel(frame: CGRectMake(5.0, 5.0, 100.0, 28.0))
        sectionLabel.textColor = UIColor.darkBlueDochaColor()
        sectionLabel.text = self.sections[section]
        sectionLabel.font = UIFont(name: "Montserrat-Semibold", size: 12)
        viewHeader.addSubview(sectionLabel)
        
        return viewHeader
    }
    
    func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        
    }
    
    func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!) {
        
    }
    
    func sharerDidCancel(sharer: FBSDKSharing!) {
        
    }
    
    
//MARK: @IBAction Methods
    
    func inviteFacebookFriendsButtonTouched() {
        // Amplitude
        Amplitude.instance().logEvent("ClickInviteFriends")
        
        // Facebook Sharing
        let content = FBSDKShareLinkContent()
        content.contentURL = NSURL(string: "http://www.docha.fr")
        let shareDialog = FBSDKShareDialog()
        shareDialog.fromViewController = self
        shareDialog.shareContent = content
        shareDialog.mode = .ShareSheet
        shareDialog.show()
    }
    
    func logoutButtonTouched() {
        // Amplitude
        Amplitude.instance().logEvent("LogOutUser")
        
        UserSessionManager.sharedInstance.logout()
        let connexionViewController = self.storyboard?.instantiateViewControllerWithIdentifier("idStarterNavController")
        NavSchemeManager.sharedInstance.changeRootViewController(connexionViewController!)
    }
}