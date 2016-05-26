//
//  InscriptionSecondStepViewController.swift
//  DochaProto
//
//  Created by Mathis D on 22/05/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import TextFieldEffects

class InscriptionSecondStepViewController: RootViewController, UITextFieldDelegate {
    
    var genderSelected: String?
    var dateOfBirthday: Int?
    
    @IBOutlet weak var manButton: UIButton!
    @IBOutlet weak var womanButton: UIButton!
    @IBOutlet weak var birthdayTextField: HoshiTextField!
    @IBOutlet weak var validProfilButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 246.0, green: 90.0, blue: 79.0, alpha: 1.0)
        self.hideKeyboardWhenTappedAround()
        self.validProfilButton.enabled = true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func isValidBirthday() -> Bool {
        if let birthdayString = self.birthdayTextField.text {
            if let birthdayInteger = Int(birthdayString) {
                if case 1900...2017 = birthdayInteger {
                    self.birthdayTextField.borderActiveColor = UIColor.greenColor()
                    self.birthdayTextField.borderInactiveColor = UIColor.greenColor()
                    self.dateOfBirthday = birthdayInteger
                    
                    return true
                } else {
                    // Wrong date
                    print("Wrong date")
                }
            } else {
                // Not a date (integer conversion equal nil)
                print("Date not an integer")
            }
        } else {
            // Birthday nil !
            print("Date is nil")
        }
        
        self.birthdayTextField.borderActiveColor = UIColor.redColor()
        self.birthdayTextField.borderInactiveColor = UIColor.redColor()
        
        return false
    }
    
    @IBAction func birthdayTextFieldEditingChanged(sender: HoshiTextField) {
        self.validProfilButton.enabled = isValidBirthday() ? true : false
    }
    
    @IBAction func backButtonTapped(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func genderButtonTouched(sender: UIButton) {
        if sender.tag == 1 {
            // Man selected
            self.genderSelected = "man"
            self.manButton.setImage(UIImage(named: "avatar_homme_selected.png"), forState: .Normal)
            self.womanButton.setImage(UIImage(named: "avatar_femme.png"), forState: .Normal)
        } else {
            // Woman selected
            self.genderSelected = "woman"
            self.womanButton.setImage(UIImage(named: "avatar_femme_selected.png"), forState: .Normal)
            self.manButton.setImage(UIImage(named: "avatar_homme.png"), forState: .Normal)
        }
        
        self.view.setNeedsDisplay()
    }
    
    @IBAction func validProfilButtonTouched(sender: UIButton) {
        
    }
}