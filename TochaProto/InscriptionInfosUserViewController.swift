//
//  InscriptionInfosUserViewController.swift
//  DochaProto
//
//  Created by Mathis D on 27/05/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import TextFieldEffects

class InscriptionInfosUserViewController: RootViewController, UITextFieldDelegate {
    
    var genderSelected: String?
    var dateOfBirthday: NSDate?
    
    @IBOutlet weak var manButton: UIButton!
    @IBOutlet weak var womanButton: UIButton!
    @IBOutlet weak var birthdayTextField: HoshiTextField!
    @IBOutlet weak var validProfilButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        self.validProfilButton.enabled = false
        self.navigationController!.setNavigationBarHidden(false, animated: false)
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.configNavigationBarWithTitle("Qui êtes-vous ?")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func textFieldTouched(sender: UITextField) {
        let datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        
        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let currentDate: NSDate = NSDate()
        let components: NSDateComponents = NSDateComponents()
        
        components.year = -120
        let minDate: NSDate = gregorian.dateByAddingComponents(components, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
        
        components.year = -150
        let maxDate: NSDate = gregorian.dateByAddingComponents(components, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
        
        datePickerView.minimumDate = minDate
        datePickerView.maximumDate = maxDate
        
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(InscriptionInfosUserViewController.handleDatePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        self.birthdayTextField.text = dateFormatter.stringFromDate(sender.date)
        self.dateOfBirthday = dateFormatter.dateFromString(self.birthdayTextField.text!)
        
        if self.birthdayTextField.text != nil || !((self.birthdayTextField.text?.isEmpty)!) {
            self.birthdayTextField.borderActiveColor = UIColor.greenColor()
            self.birthdayTextField.borderInactiveColor = UIColor.greenColor()
            self.validProfilButton.enabled = true
        } else {
            self.validProfilButton.enabled = false
            self.birthdayTextField.borderActiveColor = UIColor.redColor()
            self.birthdayTextField.borderInactiveColor = UIColor.redColor()
        }
    }
    
    @IBAction func genderButtonTouched(sender: UIButton) {
        if sender.tag == 1 {
            // Man selected
            self.genderSelected = "M"
            self.manButton.setImage(UIImage(named: "avatar_homme_selected_infos_user.png"), forState: .Normal)
            self.womanButton.setImage(UIImage(named: "avatar_femme_infos_user.png"), forState: .Normal)
            self.manButton.animatedButtonLikeBubbleWithDelay(0.0, duration: 0.5)
        } else {
            // Woman selected
            self.genderSelected = "F"
            self.womanButton.setImage(UIImage(named: "avatar_femme_selected_infos_user.png"), forState: .Normal)
            self.manButton.setImage(UIImage(named: "avatar_homme_infos_user.png"), forState: .Normal)
            self.womanButton.animatedButtonLikeBubbleWithDelay(0.0, duration: 0.5)
        }
    }
    
    @IBAction func validProfilButtonTouched(sender: UIButton) {
        let userSessionManager = UserSessionManager.sharedInstance
        
        if userSessionManager.dicoUserDataInscription == nil {
            userSessionManager.dicoUserDataInscription = [String:AnyObject]()
        }
        
        if let genderString = self.genderSelected, birthday = self.dateOfBirthday {
            userSessionManager.dicoUserDataInscription!["gender"] = genderString
            userSessionManager.dicoUserDataInscription!["birthday"] = birthday
        }
    }
}