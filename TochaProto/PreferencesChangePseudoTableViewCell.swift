//
//  PreferencesChangePseudoTableViewCell.swift
//  Docha
//
//  Created by Mathis D on 06/07/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

protocol PseudoCellDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    func textFieldTouched(_ sender: UITextField)
}

class PreferencesChangePseudoTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    var delegate: PseudoCellDelegate?
    var isPseudoCell: Bool = true
    
    @IBOutlet weak var imageViewCell: UIImageView!
    @IBOutlet weak var pseudoTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.pseudoTextField.font = UIFont(name: "Montserrat-Regular", size: 15.0)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return (self.delegate?.textFieldShouldReturn(textField))!
    }
    
    @IBAction func textFieldTouched(_ sender: UITextField) {
        if isPseudoCell {
            if self.pseudoTextField.text == "" {
                self.pseudoTextField.placeholder = "Tu n'as pas de pseudo ?!"
            }
        } else {
            self.delegate?.textFieldTouched(sender)
            if self.pseudoTextField.text == "" {
                self.pseudoTextField.placeholder = "Anniveraire"
            }
            
        }
    }
}
