//
//  PreferencesChangePasswordTableViewCell.swift
//  Docha
//
//  Created by Mathis D on 14/07/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class PreferencesChangePasswordTableViewCell: UITableViewCell {
    
    var placeholderString: String? {
        didSet {
            self.textField.placeholder = placeholderString
            

        }
    }
    
    @IBOutlet weak var textField: UITextField!
}