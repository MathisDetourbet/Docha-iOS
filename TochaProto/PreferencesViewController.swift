//
//  PreferencesViewController.swift
//  Docha
//
//  Created by Mathis D on 06/06/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import Amplitude_iOS
import PBWebViewController
import FBSDKShareKit

class PreferencesViewController: GameViewController, UITableViewDelegate, UITableViewDataSource {

    var isPasswordChangeCellHidden = false
    let idNormalTableViewCell = "idNormalTableViewCell"
    let idSwitchTableViewCell = "idSwitchTableViewCell"
    let sections: [String] = ["COMPTE", "INFORMATIONS"]
    var cellContent: [[[String:String]]] = [[["title" : "Modifier le profil", "iconPath" : "profil_icon"],
                                            ["title" : "Changer le mot de passe", "iconPath" : "password_change_icon"],
                                            ["title" : "Catégories préférées", "iconPath" : "category_selection_icon"]],
                                            [["title" :"Notifications", "iconPath" : "notifications_icon"],
                                            ["title" : "À propos", "iconPath" : "rocket_icon"],
                                            ["title" : "Tutoriel", "iconPath" : "play_icon"],
                                            ["title" :"Donne nous ton avis !","iconPath": "mail_icon"]]]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Amplitude
        Amplitude.instance().logEvent("Preferences tab opened")
        let currentSession = UserSessionManager.sharedInstance.currentSession()
        
        if let currentSession = currentSession {
            if currentSession.isKind(of: UserSessionFacebook.self) {
                cellContent[0].remove(at: 1)
                isPasswordChangeCellHidden = true
            }
        }
        
        self.buildUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configNavigationBarWithTitle("Préférences")
        self.tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func buildUI() {
        self.view.backgroundColor = UIColor.lightGrayDochaColor()
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 123))
        
        let inviteFacebookFriendsButton = UIButton(type: .custom)
        inviteFacebookFriendsButton.translatesAutoresizingMaskIntoConstraints = false
        inviteFacebookFriendsButton.setImage(UIImage(named: "btn_fb_invit"), for: UIControlState())
        inviteFacebookFriendsButton.addTarget(self, action: #selector(PreferencesViewController.inviteFacebookFriendsButtonTouched), for: .touchUpInside)
        footerView.addSubview(inviteFacebookFriendsButton)
        
        footerView.addConstraint(NSLayoutConstraint(item: inviteFacebookFriendsButton, attribute: .centerX, relatedBy: .equal, toItem: footerView, attribute: .centerX, multiplier: 1, constant: 0))
        footerView.addConstraint(NSLayoutConstraint(item: inviteFacebookFriendsButton, attribute: .top, relatedBy: .equal, toItem: footerView, attribute: .top, multiplier: 1, constant: 15))
        
        let logoutButton = UIButton(type: .custom)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.setImage(UIImage(named: "btn_logout"), for: UIControlState())
        logoutButton.addTarget(self, action: #selector(PreferencesViewController.logoutButtonTouched), for: .touchUpInside)
        footerView.addSubview(logoutButton)
        
        footerView.addConstraint(NSLayoutConstraint(item: logoutButton, attribute: .top, relatedBy: .equal, toItem: inviteFacebookFriendsButton, attribute: .bottom, multiplier: 1, constant: 10))
        footerView.addConstraint(NSLayoutConstraint(item: logoutButton, attribute: .centerX, relatedBy: .equal, toItem: footerView, attribute: .centerX, multiplier: 1, constant: 0))
        
        tableView.tableFooterView = footerView
        tableView.backgroundColor = UIColor.lightGrayDochaColor()
    }
    
    
//MARK: Table View Data Source Methods
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellContent[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cellContent[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]["title"] == "Notifications" {
            let cell = tableView.dequeueReusableCell(withIdentifier: idSwitchTableViewCell, for: indexPath) as? PreferencesSwitchTableViewCell
            let cellTitle = cellContent[1][(indexPath as NSIndexPath).row]["title"]
            cell?.titleLabel.text = cellTitle
            cell?.iconImageView.image = UIImage(named: self.cellContent[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]["iconPath"]!)
            
            return cell!
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: idNormalTableViewCell, for: indexPath) as? PreferencesNormalTableViewCell
            let title = cellContent[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]["title"]
            cell?.titleLabel.text = title
            cell?.iconImageView.image = UIImage(named: self.cellContent[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]["iconPath"]!)
            cell?.accessoryType = .disclosureIndicator
            
            return cell!
        }
    }
    
    
//MARK: Table View Delegate Methods
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath as NSIndexPath).section {
        case 0:
            // Compte section
            switch (indexPath as NSIndexPath).row {
            case 0:
                // Modifier le profil
                let changeProfilVC = self.storyboard?.instantiateViewController(withIdentifier: "idPreferencesChangeProfilViewController") as! PreferencesChangeProfilViewController
                self.navigationController?.pushViewController(changeProfilVC, animated: true)
                break
            case 1:
                if isPasswordChangeCellHidden {
                    let categoriesVC = self.storyboard?.instantiateViewController(withIdentifier: "idPreferencesCategoryViewController") as! PreferencesCategoriesViewController
                    self.navigationController?.pushViewController(categoriesVC, animated: true)
                    
                } else {
                    // Changer le mdp
                    let changePasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "idPreferencesChangePasswordViewController") as! PreferencesChangePasswordViewController
                    self.navigationController?.pushViewController(changePasswordVC, animated: true)
                }
                break
            default:
                // Catégories préférées
                let categoriesVC = self.storyboard?.instantiateViewController(withIdentifier: "idPreferencesCategoryViewController") as! PreferencesCategoriesViewController
                self.navigationController?.pushViewController(categoriesVC, animated: true)
                break
            }
            break
        case 1:
            // Informations section
            if (indexPath as NSIndexPath).row == 1 {
                // A propos
                let aboutVC = self.storyboard?.instantiateViewController(withIdentifier: "idPreferencesAboutViewController") as! PreferencesAboutViewController
                self.navigationController?.pushViewController(aboutVC, animated: true)
                
            } else if (indexPath as NSIndexPath).row == 2 {
                // Tutoriel
                let tutorialVC = self.storyboard?.instantiateViewController(withIdentifier: "idTutorialViewController") as! TutorialViewController
                self.present(tutorialVC, animated: true, completion: nil)
                
            } else if (indexPath as NSIndexPath).row == 3 {
                // Feedbacks
                let url = URL(string: "https://morganegr.typeform.com/to/NbeMZ2")
                let feedbackWebVC = self.storyboard?.instantiateViewController(withIdentifier: "idPreferencesFeedbackWebViewController") as! PreferencesFeedbackViewController
                feedbackWebVC.url = url
                
                let activity = UIActivity()
                feedbackWebVC.applicationActivities = [activity]
                feedbackWebVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(feedbackWebVC, animated: true)
            }
        default:
            // Autres section
            break
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.width, height: 28))
        viewHeader.backgroundColor = UIColor.lightGrayDochaColor()
        let sectionLabel = UILabel(frame: CGRect(x: 5.0, y: 5.0, width: 100.0, height: 28.0))
        sectionLabel.textColor = UIColor.darkBlueDochaColor()
        sectionLabel.text = self.sections[section]
        sectionLabel.font = UIFont(name: "Montserrat-Semibold", size: 12)
        viewHeader.addSubview(sectionLabel)
        
        return viewHeader
    }
    
    
//MARK: FBSDKSharingDelegate
    
//    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable: Any]!) {
//        
//    }
//    
//    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: NSError!) {
//        
//    }
//    
//    func sharerDidCancel(_ sharer: FBSDKSharing!) {
//        
//    }
    
    
//MARK: @IBAction Methods
    
    func inviteFacebookFriendsButtonTouched() {
        // Amplitude
        Amplitude.instance().logEvent("ClickInviteFriends")
        
        // Facebook Sharing
        let content = FBSDKShareLinkContent()
        content.contentURL = URL(string: "http://www.docha.fr")
        let shareDialog = FBSDKShareDialog()
        shareDialog.fromViewController = self
        shareDialog.shareContent = content
        shareDialog.mode = .shareSheet
        shareDialog.show()
    }
    @IBAction func doneButtonTouched(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func logoutButtonTouched() {
        // Amplitude
        Amplitude.instance().logEvent("LogOutUser")
        
        UserSessionManager.sharedInstance.logout()
        let connexionViewController = self.storyboard?.instantiateViewController(withIdentifier: "idStarterNavController")
        NavSchemeManager.sharedInstance.changeRootViewController(connexionViewController!)
    }
}
