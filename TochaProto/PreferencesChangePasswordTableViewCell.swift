//
//  PreferencesChangePasswordTableViewCell.swift
//  Docha
//
//  Created by Mathis D on 14/07/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

protocol ChangePasswordCellDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    func textFieldTouched(_ sender: UITextField, dataKey: String)
}

class PreferencesChangePasswordTableViewCell: UITableViewCell {
    
    var delegate: ChangePasswordCellDelegate?
    var dataKey: String?
    
    var placeholderString: String? {
        didSet {
            self.textField.placeholder = placeholderString
        }
    }
    
    @IBOutlet weak var textField: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return (self.delegate?.textFieldShouldReturn(textField))!
    }
    
    @IBAction func textFieldTouched(_ sender: UITextField) {
        self.delegate?.textFieldTouched(sender, dataKey: dataKey!)
    }
}
