//
//  PreferencesChangePasswordViewController.swift
//  Docha
//
//  Created by Mathis D on 12/07/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class PreferencesChangePasswordViewController: RootViewController, UITableViewDelegate, UITableViewDataSource {
    
    let textFielsdPlaceholders = ["Ancien mot de passe", "Nouveau mot de passe", "Confirmation mot de passe"]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var validBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var cancelBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var heightTableViewConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightGrayDochaColor()
        self.tableView.backgroundColor = UIColor.lightGrayDochaColor()
        
        configNavigationBarWithTitle("Modifier le mot de passe", andFontSize: 15.0)
        
        self.validBarButtonItem.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Montserrat-SemiBold", size: 11.0)!], for: UIControlState())
        self.cancelBarButtonItem.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Montserrat-SemiBold", size: 11.0)!], for: UIControlState())
        
        self.heightTableViewConstraint.constant = CGFloat(self.textFielsdPlaceholders.count) * tableView.rowHeight + tableView.sectionHeaderHeight * 2 + tableView.sectionFooterHeight * 2
    }


//MARK: UITableViewC Data Source Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 2
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""//"Section \(section)"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "idPreferencesChangePasswordCell") as? PreferencesChangePasswordTableViewCell
//        if indexPath.section == 0 {
//            cell?.contentView.layer.borderColor = UIColor(red:0.78, green:0.78, blue:0.80, alpha:1.0).CGColor
//            cell?.contentView.layer.borderWidth = 1.0
//        }
        let placeholderString = self.textFielsdPlaceholders[(indexPath as NSIndexPath).row + (indexPath as NSIndexPath).section]
        cell!.placeholderString = placeholderString
        cell!.textField.attributedPlaceholder = NSAttributedString(string: placeholderString, attributes: [NSFontAttributeName: UIFont(name: "Montserrat-Regular", size: 15.0)!])
        cell?.textField.font = UIFont(name: "Montserrat-Regular", size: 15.0)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.tableView.frame.width, height: 30.0))
        headerView.backgroundColor = UIColor.lightGrayDochaColor()
        headerView.layer.borderWidth = 1.0
        headerView.layer.borderColor = UIColor(red:0.78, green:0.78, blue:0.80, alpha:1.0).cgColor
        return headerView
    }
    
    
//MARK: UITableView Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
//MARK: @IBActions

    @IBAction func cancelButtonTouched(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func validButtonTouched(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}
