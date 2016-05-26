//
//  InscriptionFirstStepViewController.swift
//  DochaProto
//
//  Created by Mathis D on 22/05/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import TextFieldEffects
import SCLAlertView

// Dismiss keyboard on UITextField for UIViewControllers
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(self)
    }
}


class InscriptionFirstStepViewController: RootViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.setNavigationBarHidden(true, animated: false)
        self.hideKeyboardWhenTappedAround()
        self.registerButton.enabled = true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func isEmailValid() -> Bool {
        if let emailString = emailTextField.text {
            if !emailString.isEmpty {
                if emailString.isValidEmail() {
                    self.emailTextField.borderActiveColor = UIColor.greenColor()
                    self.emailTextField.borderInactiveColor = UIColor.greenColor()
                    return true
                } else {
                    // Email is not valid
                    //print("Email is not valid")
                }
            } else {
                // Email text field is empty
                //print("Email text field is empty")
            }
        } else {
            // Email is nil
            //print("Email is nil")
        }
        
        self.emailTextField.borderActiveColor = UIColor.redColor()
        self.emailTextField.borderInactiveColor = UIColor.redColor()
        
        return false
    }
    
    func isPasswordValid() -> Bool {
        if let passwordString = passwordTextField.text {
            if !passwordString.isEmpty {
                self.passwordTextField.borderActiveColor = UIColor.greenColor()
                self.passwordTextField.borderInactiveColor = UIColor.greenColor()
                return true
            } else {
                // Password is empty
                //print("Password is empty")
            }
        } else {
            // Password is nil
            //print("Password is nil")
        }
        
        self.passwordTextField.borderActiveColor = UIColor.redColor()
        self.passwordTextField.borderInactiveColor = UIColor.redColor()
        
        return false
    }
    
    @IBAction func backButtonTapped(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func EmailTextFieldEditingChanged(sender: HoshiTextField) {
        self.registerButton.enabled = (isEmailValid() && isPasswordValid()) ? true : false
    }
    
    @IBAction func PasswordTextFieldEditingChanged(sender: HoshiTextField) {
        self.registerButton.enabled = (isPasswordValid() && isEmailValid()) ? true : false
    }
}
