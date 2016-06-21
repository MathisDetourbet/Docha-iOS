//
//  PreferencesViewController.swift
//  Docha
//
//  Created by Mathis D on 06/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class PreferencesViewController: RootViewController, UITableViewDelegate, UITableViewDataSource {
    
    let idNormalTableViewCell = "idNormalTableViewCell"
    let idSwitchTableViewCell = "idSwitchTableViewCell"
    let sections: [String] = ["COMPTE", "PARAMÈTRES", "AUTRES"]
    let cellContent: [[[String:String]]] = [[["title":"Modifier le profil","iconPath": "profil_icon"], ["title":"Changer le mot de passe","iconPath": "password_change_icon"], ["title":"Catégorie préférées","iconPath": "category_selection_icon"]],
                                            [["title":"Notifications","iconPath": "notifications_icon"], ["title":"Newsletter","iconPath": "newsletter_icon"], ["title":"Langue","iconPath": "language_icon"]],
                                            [["title":"À propos","iconPath": "rocket_icon"], ["title":"Nous contacter","iconPath": "mail_icon"]]]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buildUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func buildUI() {
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
            cell?.titleLabel.text = self.cellContent[1][indexPath.row]["title"]
            cell?.iconImageView.image = UIImage(named: self.cellContent[indexPath.section][indexPath.row]["iconPath"]!)
            
            return cell!
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(self.idNormalTableViewCell, forIndexPath: indexPath) as? PreferencesNormalTableViewCell
            let title = self.cellContent[indexPath.section][indexPath.row]["title"]
            cell?.titleLabel.text = title
            (title == "Categorie préférée") ? (cell?.categoryFavoriteLabel.text = title) : (cell?.categoryFavoriteLabel.text = "")
            cell?.iconImageView.image = UIImage(named: self.cellContent[indexPath.section][indexPath.row]["iconPath"]!)
            
            return cell!
        }
    }
    
    
    //MARK: Table View Delegate Methods
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Montserrat-Semibold", size: 12)
        header.textLabel?.textColor = UIColor.darkBlueColor()
    }
    
    
    //MARK: IBAction Methods
    
    func inviteFacebookFriendsButtonTouched() {
        
    }
    
    func logoutButtonTouched() {
        UserSessionManager.sharedInstance.logout()
        let connexionViewController = self.storyboard?.instantiateViewControllerWithIdentifier("idStarterNavController")
        NavSchemeManager.sharedInstance.changeRootViewController(connexionViewController!)
    }
}