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
    
    var genderSelected: String? = "other"
    var dateOfBirthday: String?
    var avatarUrl: String = "avatar_man"
    
    @IBOutlet weak var manButton: UIButton!
    @IBOutlet weak var womanButton: UIButton!
    @IBOutlet weak var birthdayTextField: HoshiTextField!
    @IBOutlet weak var validProfilButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.setNavigationBarHidden(false, animated: false)
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        hideKeyboardWhenTappedAround()
        configNavigationBarWithTitle("Qui es-tu ?")
        buildUI()
    }
    
    func buildUI() {
        validProfilButton.isEnabled = false
        birthdayTextField.placeholderColor = UIColor.blueDochaColor()
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
        birthdayTextField.text = dateFormatter.string(from: sender.date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateOfBirthday = dateFormatter.string(from: sender.date)
        
        if birthdayTextField.text != nil || !((birthdayTextField.text?.isEmpty)!) {
            birthdayTextField.borderActiveColor = UIColor.blueDochaColor()
            birthdayTextField.borderInactiveColor = UIColor.blueDochaColor()
            birthdayTextField.placeholder = ""
            validProfilButton.isEnabled = true
            
        } else {
            validProfilButton.isEnabled = false
            birthdayTextField.borderActiveColor = UIColor.redDochaColor()
            birthdayTextField.borderInactiveColor = UIColor.redDochaColor()
            birthdayTextField.placeholder = "Exemple : 1er Janvier 1990"
        }
    }
    
    @IBAction func skipButtonTouched(_ sender: UIButton) {
        let inscriptionAvatarVC = self.storyboard?.instantiateViewController(withIdentifier: "idInscriptionProfilViewController") as! InscriptionProfilViewController
        self.navigationController?.pushViewController(inscriptionAvatarVC, animated: true)
    }
    
    @IBAction func genderButtonTouched(_ sender: UIButton) {
        if sender.tag == 1 {
            // Man selected
            genderSelected = "male"
            avatarUrl = "avatar_man"
            manButton.setImage(UIImage(named: "avatar_man_large_selected"), for: UIControlState())
            womanButton.setImage(UIImage(named: "avatar_woman_large"), for: UIControlState())
            manButton.animatedLikeBubbleWithDelay(0.0, duration: 0.5)
            
        } else {
            // Woman selected
            genderSelected = "female"
            avatarUrl = "avatar_woman"
            womanButton.setImage(UIImage(named: "avatar_woman_large_selected"), for: UIControlState())
            manButton.setImage(UIImage(named: "avatar_man_large"), for: UIControlState())
            womanButton.animatedLikeBubbleWithDelay(0.0, duration: 0.5)
        }
    }
    
    @IBAction func validButtonTouched(_ sender: UIButton?) {
        if let gender = genderSelected, let birthday = dateOfBirthday {
            PopupManager.sharedInstance.showLoadingPopup("Chargement en cours", message: "Création du profil...",
                completion: {
                    let data = [UserDataKey.kGender: gender,
                                UserDataKey.kDateBirthday: birthday,
                                UserDataKey.kAvatarUrl: self.avatarUrl]
                    
                    UserSessionManager.sharedInstance.updateUser(withData: data,
                        success: {
                            PopupManager.sharedInstance.dismissPopup(true,
                                completion: {
                                    let inscriptionPseudoVC = self.storyboard?.instantiateViewController(withIdentifier: "idInscriptionPseudoSelectionViewController") as! InscriptionPseudoSelectionViewController
                                    self.navigationController?.pushViewController(inscriptionPseudoVC, animated: true)
                                }
                            )
                        }
                    ) { (error) in
                        PopupManager.sharedInstance.dismissPopup(true,
                            completion: {
                                PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorNoInternetConnection)
                            }
                        )
                    }
                }
            )
            
        } else {
            PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorInscriptionBadBirthOrGender)
        }
    }
}
