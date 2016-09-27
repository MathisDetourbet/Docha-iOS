//
//  InscriptionInfosUserViewController.swift
//  DochaProto
//
//  Created by Mathis D on 27/05/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import TextFieldEffects

class InscriptionInfosUserViewController: RootViewController, UITextFieldDelegate {
    
    var genderSelected: String? = "M"
    var dateOfBirthday: String? = "1 Janvier 1990"
    
    @IBOutlet weak var manButton: UIButton!
    @IBOutlet weak var womanButton: UIButton!
    @IBOutlet weak var birthdayTextField: HoshiTextField!
    @IBOutlet weak var validProfilButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        self.validProfilButton.isEnabled = false
        self.navigationController!.setNavigationBarHidden(false, animated: false)
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.configNavigationBarWithTitle("Qui es-tu ?")
        self.birthdayTextField.placeholderColor = UIColor.blueDochaColor()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func textFieldTouched(_ sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        let gregorian: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let currentDate: Date = Date()
        var components: DateComponents = DateComponents()
        
        components.year = -120
        let minDate: Date = (gregorian as NSCalendar).date(byAdding: components, to: currentDate, options: NSCalendar.Options(rawValue: 0))!
        
        components.year = -150
        let maxDate: Date = (gregorian as NSCalendar).date(byAdding: components, to: currentDate, options: NSCalendar.Options(rawValue: 0))!
        
        datePickerView.minimumDate = minDate
        datePickerView.maximumDate = maxDate
        
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(InscriptionInfosUserViewController.handleDatePicker(_:)), for: UIControlEvents.valueChanged)
    }
    
    func handleDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        self.birthdayTextField.text = dateFormatter.string(from: sender.date)
        self.dateOfBirthday = birthdayTextField.text
        
        if self.birthdayTextField.text != nil || !((self.birthdayTextField.text?.isEmpty)!) {
            self.birthdayTextField.borderActiveColor = UIColor.blueDochaColor()
            self.birthdayTextField.borderInactiveColor = UIColor.blueDochaColor()
            self.birthdayTextField.placeholder = ""
            self.validProfilButton.isEnabled = true
            
        } else {
            self.validProfilButton.isEnabled = false
            self.birthdayTextField.borderActiveColor = UIColor.redDochaColor()
            self.birthdayTextField.borderInactiveColor = UIColor.redDochaColor()
            self.birthdayTextField.placeholder = "Exemple : 1er Janvier 1990"
        }
    }
    
    @IBAction func skipButtonTouched(_ sender: UIButton) {
//        self.genderSelected = "M"
//        self.dateOfBirthday = "1 Janvier 1990"
//        self.validButtonTouched(nil)
//        let inscriptionAvatarVC = self.storyboard?.instantiateViewControllerWithIdentifier("idInscriptionProfilViewController") as! InscriptionProfilViewController
//        self.navigationController?.pushViewController(inscriptionAvatarVC, animated: true)
    }
    
    @IBAction func genderButtonTouched(_ sender: UIButton) {
        if sender.tag == 1 {
            // Man selected
            self.genderSelected = "M"
            self.manButton.setImage(UIImage(named: "avatar_homme_selected_infos_user.png"), for: UIControlState())
            self.womanButton.setImage(UIImage(named: "avatar_femme_infos_user.png"), for: UIControlState())
            self.manButton.animatedLikeBubbleWithDelay(0.0, duration: 0.5)
            
        } else {
            // Woman selected
            self.genderSelected = "F"
            self.womanButton.setImage(UIImage(named: "avatar_femme_selected_infos_user.png"), for: UIControlState())
            self.manButton.setImage(UIImage(named: "avatar_homme_infos_user.png"), for: UIControlState())
            self.womanButton.animatedLikeBubbleWithDelay(0.0, duration: 0.5)
        }
    }
    
    @IBAction func validButtonTouched(_ sender: UIButton?) {
        let userSessionManager = UserSessionManager.sharedInstance
        
        if userSessionManager.dicoUserDataInscription == nil {
            userSessionManager.dicoUserDataInscription = [String:AnyObject]()
        }
        
        if let genderString = self.genderSelected, let birthday = self.dateOfBirthday {
            userSessionManager.dicoUserDataInscription!["sexe"] = genderString as AnyObject?
            userSessionManager.dicoUserDataInscription!["date_birthday"] = birthday as AnyObject?
            
            if genderString == "F" {
                userSessionManager.dicoUserDataInscription!["avatar"] = "avatar_woman" as AnyObject?
            } else {
                userSessionManager.dicoUserDataInscription!["avatar"] = "avatar_man" as AnyObject?
            }
        }
        
        let inscriptionPseudoVC = self.storyboard?.instantiateViewController(withIdentifier: "idInscriptionPseudoSelectionViewController") as! InscriptionPseudoSelectionViewController
        self.navigationController?.pushViewController(inscriptionPseudoVC, animated: true)
    }
}
