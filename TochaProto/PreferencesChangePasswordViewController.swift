//
//  PreferencesChangePasswordViewController.swift
//  Docha
//
//  Created by Mathis D on 12/07/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

class PreferencesChangePasswordViewController: RootViewController, UITableViewDelegate, UITableViewDataSource, ChangePasswordCellDelegate {
    
    let textFielsdPlaceholders = ["Ancien mot de passe", "Nouveau mot de passe", "Confirmation mot de passe"]
    let passwordDataKeyArray = [UserDataKey.kOldPassword, UserDataKey.kNewPassword1, UserDataKey.kNewPassword2]
    var data: [String: String] = [:]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var validBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var cancelBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var heightTableViewConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightGrayDochaColor()
        tableView.backgroundColor = UIColor.lightGrayDochaColor()
        
        configNavigationBarWithTitle("Modifier le mot de passe")
        
        validBarButtonItem.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Montserrat-SemiBold", size: 11.0)!], for: UIControlState())
        cancelBarButtonItem.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Montserrat-SemiBold", size: 11.0)!], for: UIControlState())
        
        heightTableViewConstraint.constant = CGFloat(self.textFielsdPlaceholders.count) * tableView.rowHeight + tableView.sectionHeaderHeight * 2 + tableView.sectionFooterHeight * 2
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idPreferencesChangePasswordCell", for: indexPath) as! PreferencesChangePasswordTableViewCell
        
        let placeholderString = self.textFielsdPlaceholders[(indexPath as NSIndexPath).row + (indexPath as NSIndexPath).section]
        cell.placeholderString = placeholderString
        cell.textField.attributedPlaceholder = NSAttributedString(string: placeholderString, attributes: [NSFontAttributeName: UIFont(name: "Montserrat-Regular", size: 15.0)!])
        cell.textField.font = UIFont(name: "Montserrat-Regular", size: 15.0)
        if indexPath.section == 0 {
            cell.dataKey = passwordDataKeyArray[0]
            
        } else {
            cell.dataKey = passwordDataKeyArray[indexPath.row + indexPath.section]
        }
        cell.delegate = self
        
        return cell
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
        return
    }
    

//MARK: Change Password Cell Delegate
    
    func textFieldTouched(_ sender: UITextField, dataKey: String) {
        data[dataKey] = sender.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
//    func containsEmptyField(data: [String: Any]!) -> Bool {
//        for (_, value):(String, String) in data {
//            if value == "" {
//                return true
//            }
//        }
//        
//        return false
//    }
    
    
//MARK: @IBActions

    @IBAction func cancelButtonTouched(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func validButtonTouched(_ sender: UIBarButtonItem) {
        if data.count != textFielsdPlaceholders.count {
            PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorChangePasswordFieldMissing, viewController: self,
                doneActionCompletion: {
                    return
                }
            )
            
        } else if (data[UserDataKey.kNewPassword1]) != (data[UserDataKey.kNewPassword2]) {
            PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorChangePasswordNewPwdNotEqual, viewController: self,
                    doneActionCompletion: {
                        return
                }
            )
            
        } else if data.values.contains("") {
            PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorChangePasswordFieldMissing, viewController: self,
                    doneActionCompletion: {
                        return
                }
            )
            
        } else {
            PopupManager.sharedInstance.showLoadingPopup(message: Constants.PopupMessage.InfosMessage.kUserProfilUpdating, viewController: self,
                completion: {
                    UserSessionManager.sharedInstance.changeUserPassword(withData: self.data,
                        success: {
                            PopupManager.sharedInstance.dismissPopup(true, completion: { 
                                    _ = self.navigationController?.popViewController(animated: true)
                                }
                            )
                        }
                    ) { (error) in
                        PopupManager.sharedInstance.dismissPopup(true,
                            completion: {
                                PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorOccured)
                            }
                        )
                    }
                }
            )
        }
    }
}
