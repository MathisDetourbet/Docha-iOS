//
//  PreferencesChangeProfilViewController.swift
//  Docha
//
//  Created by Mathis D on 06/07/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

class PreferencesChangeProfilViewController: RootViewController, UITableViewDelegate, UITableViewDataSource, PseudoCellDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RSKImageCropViewControllerDelegate, ChooseAvatarDochaDelegate {
    
    var userSession: UserSession?
    var pseudoIndexPath: IndexPath?
    var birthdayIndexPathCell: IndexPath?
    var avatarIndexPath: IndexPath?
    let imagePicker = UIImagePickerController()
    var imageViewPicked: UIImageView?
    var genderNotConverted: String?
    var birthdayString: String?
    var avatarImageName: String?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var validBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var heightTableViewConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userSession = UserSessionManager.sharedInstance.currentSession()!
        
        configNavigationBarWithTitle("Modifier le profil", andFontSize: 15.0)

        self.validBarButtonItem.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Montserrat-SemiBold", size: 11.0)!], for: UIControlState())
        self.cancelBarButtonItem.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Montserrat-SemiBold", size: 11.0)!], for: UIControlState())

        self.heightTableViewConstraint.constant = 4 * tableView.rowHeight + tableView.sectionHeaderHeight + tableView.sectionFooterHeight
        
        self.imagePicker.delegate = self
    }
    
    
//MARK: UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "idPreferencesChangePseudoCell") as! PreferencesChangePseudoTableViewCell
            let userName = userSession?.pseudo
            if userName != nil && userName != "" {
                cell.pseudoTextField.text = userName
                cell.pseudoTextField.font = UIFont(name: "Montserrat-Regular", size: 15.0)
                cell.pseudoTextField.placeholder = nil
                cell.delegate = self
                
            } else {
                cell.pseudoTextField.placeholder = "Pseudo"
                cell.pseudoTextField.attributedPlaceholder = NSAttributedString(string: "Pseudo", attributes: [NSFontAttributeName: UIFont(name: "Montserrat-Regular", size: 15.0)!])
                cell.pseudoTextField.text = nil
            }
            
            cell.imageViewCell.image = UIImage(named: "profil_icon")
            self.pseudoIndexPath = indexPath
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "idPreferencesChangeProfilCell") as! PreferencesChangeProfilTableViewCell
//            if indexPath.row == 1 {
//                cell.titleLabel.text = "Avatar / Photo de profil"
//                cell.imageViewCell.image = UIImage(named: "smile_icon")
//                cell.accessoryType = .DisclosureIndicator
//                self.avatarIndexPath = indexPath
            
            if (indexPath as NSIndexPath).row == 1 {
                let newCell = tableView.dequeueReusableCell(withIdentifier: "idPreferencesChangePseudoCell") as! PreferencesChangePseudoTableViewCell
                newCell.pseudoTextField.attributedPlaceholder = NSAttributedString(string: "Anniversaire", attributes: [NSFontAttributeName: UIFont(name: "Montserrat-Regular", size: 15.0)!])
                
                if let dateOfBirthday = userSession!.dateBirthday {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd MMMM yyyy"
                    newCell.pseudoTextField.text = dateFormatter.string(from: dateOfBirthday as Date)
                    newCell.pseudoTextField.placeholder = nil
                } else {
                    newCell.pseudoTextField.placeholder = "Anniversaire"
                    newCell.pseudoTextField.text = nil
                }
                newCell.imageViewCell.image = UIImage(named: "cake_icon")
                newCell.delegate = self
                newCell.isPseudoCell = false
                self.birthdayIndexPathCell = indexPath
                
                return newCell
                
            } else if (indexPath as NSIndexPath).row == 2 {
                let gender = userSession!.gender
                
                if let genderString = gender {
                    if genderString == "M" {
                        cell.titleLabel.text = "Homme"
                        
                    } else if genderString == "F" {
                        cell.titleLabel.text = "Femme"
                        
                    } else {
                        cell.titleLabel.text = "Autre"
                    }
                } else {
                    cell.titleLabel.text = ""
                }
                cell.imageViewCell.image = UIImage(named: "sex_icon")
            }
            return cell
        }
    }
    

//MARK: UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row == 1 {
//            let alertController = UIAlertController(title: "Choisir une action", message: nil, preferredStyle: .ActionSheet)
//            alertController.view.tintColor = UIColor.redDochaColor()
//            var action = UIAlertAction(title: "Choisir un avatar Docha", style: .Default, handler: { (_) in
//                let chooseAvatarVC = self.storyboard?.instantiateViewControllerWithIdentifier("idChooseAvatarViewController") as! PreferencesChoosAvatarViewController
//                chooseAvatarVC.delegate = self
//                if let genderNotConvertedString = self.genderNotConverted {
//                    var finalGender = ""
//                    if genderNotConvertedString == "Homme" {
//                        finalGender = "M"
//                        
//                    } else if genderNotConvertedString == "Femme" {
//                        finalGender = "F"
//                        
//                    } else {
//                        finalGender = "U"
//                    }
//                    chooseAvatarVC.userGender = finalGender
//                } else {
//                    let gender = self.userSession!.gender
//                    if let gender = gender {
//                        chooseAvatarVC.userGender = gender
//                    }
//                }
//                self.presentViewController(chooseAvatarVC, animated: true, completion: nil)
//            })
//            alertController.addAction(action)
//            
//            action = UIAlertAction(title: "Choisir dans vos albums", style: .Default, handler: { (_) in
//                self.imagePicker.allowsEditing = false
//                self.imagePicker.sourceType = .PhotoLibrary
//                self.presentViewController(self.imagePicker, animated: true, completion: nil)
//            })
//            alertController.addAction(action)
//            
//            action = UIAlertAction(title: "Prendre une photo", style: .Default, handler: { (_) in
//                if (UIImagePickerController.availableCaptureModesForCameraDevice(.Front) != nil) || (UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil) {
//                    self.imagePicker.allowsEditing = false
//                    self.imagePicker.sourceType = .Camera
//                    self.imagePicker.cameraCaptureMode = .Photo
//                    self.imagePicker.modalPresentationStyle = .FullScreen
//                    self.presentViewController(self.imagePicker, animated: true, completion: nil)
//                    
//                } else {
//                    self.noCameraAlert()
//                }
//            })
//            alertController.addAction(action)
//            
//            let cancelAction = UIAlertAction(title: "Annuler", style: .Cancel, handler: { (_) in
//                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
//            })
//            alertController.addAction(cancelAction)
//            self.presentViewController(alertController, animated: true, completion: nil)
//            alertController.view.tintColor = UIColor.redDochaColor()
            
        if  (indexPath as NSIndexPath).row == 1 {
            let cell = tableView.cellForRow(at: indexPath) as! PreferencesChangePseudoTableViewCell
            textFieldTouched(cell.pseudoTextField)
            self.tableView.deselectRow(at: indexPath, animated: true)
            
        } else if (indexPath as NSIndexPath).row == 2 {
            let alertController = UIAlertController(title: "Sexe", message: nil, preferredStyle: .actionSheet)
            alertController.view.tintColor = UIColor.redDochaColor()
            let genderArray = ["Homme", "Femme", "Autre"]
            
            for gender in genderArray {
                let action = UIAlertAction(title: gender, style: .default, handler: { (_) in
                    let cell = self.tableView.cellForRow(at: indexPath) as! PreferencesChangeProfilTableViewCell
                    cell.titleLabel.text = gender
                    self.tableView.deselectRow(at: indexPath, animated: true)
                    self.genderNotConverted = gender
                })
                alertController.addAction(action)
            }
            let cancelAction = UIAlertAction(title: "Annuler", style: .cancel, handler: { (_) in
                self.tableView.deselectRow(at: indexPath, animated: true)
            })
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
            alertController.view.tintColor = UIColor.redDochaColor()
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    

//MARK: UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageViewPicked = UIImageView(image: pickedImage)
            imageViewPicked!.contentMode = .scaleToFill
        }
        dismiss(animated: true, completion: nil)
        let imageCropVC = RSKImageCropViewController(image: imageViewPicked!.image!)
        imageCropVC.delegate = self
        imageCropVC.moveAndScaleLabel.text = "Recadrer"
        imageCropVC.cancelButton.setTitle("Annuler", for: UIControlState())
        imageCropVC.chooseButton.setTitle("Choisir", for: UIControlState())
        
        hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(imageCropVC, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        tableView.deselectRow(at: self.avatarIndexPath!, animated: true)
        dismiss(animated: true, completion: nil)
    }
    

//MARK: RSKImageCropViewControllerDelegate Methods
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        tableView.deselectRow(at: self.avatarIndexPath!, animated: true)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        imageViewPicked = UIImageView(image: croppedImage)
        imageViewPicked?.contentMode = .scaleToFill
        tableView.deselectRow(at: self.avatarIndexPath!, animated: true)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    func textFieldTouched(_ sender: UITextField) {
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
        
        datePickerView.addTarget(self, action: #selector(PreferencesChangeProfilViewController.handleDatePicker(_:textField:)), for: UIControlEvents.valueChanged)
    }
    
    func handleDatePicker(_ sender: UIDatePicker, textField: UITextField) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        textField.text = dateFormatter.string(from: sender.date)
        
        birthdayString = dateFormatter.string(from: sender.date)
        
        let cell = tableView.cellForRow(at: self.birthdayIndexPathCell!) as! PreferencesChangePseudoTableViewCell
        cell.pseudoTextField.text = dateFormatter.string(from: sender.date)
    }
    
    func saveUserProfilDataWithCompletion(_ completion: @escaping (_ success: Bool) -> Void) {
        var needToUpdateProfil = false
        
        // Save Profile Image
//        if let _ = self.imageViewPicked, imageToSave = self.imageViewPicked?.image {
//            needToUpdateProfil = true
//            UserSessionManager.sharedInstance.currentSession()?.saveProfileImage(imageToSave)
//        }
        
        // Save other user data
        if var dicoParameters = self.userSession?.generateJSONFromUserSession() {
            
//            if let _ = self.avatarImageName {
//                needToUpdateProfil = true
//                dicoParameters[UserDataKey.kAvatar] = self.avatarImageName
//            }
            
            if let genderNotConvertedString = self.genderNotConverted {
                var finalGender = ""
                if genderNotConvertedString == "Homme" {
                   finalGender = "M"
                    
                } else if genderNotConvertedString == "Femme" {
                    finalGender = "F"
                    
                } else {
                    finalGender = "U"
                }
                needToUpdateProfil = true
                dicoParameters[UserDataKey.kGender] = finalGender as AnyObject?
            }
            
            let pseudoCell = self.tableView.cellForRow(at: self.pseudoIndexPath!) as! PreferencesChangePseudoTableViewCell
            let pseudoString = pseudoCell.pseudoTextField.text
            let currentPseudo = UserSessionManager.sharedInstance.currentSession()?.pseudo
            if let pseudo = pseudoString {
                if pseudo != currentPseudo {
                    needToUpdateProfil = true
                    dicoParameters[UserDataKey.kPseudo] = pseudo as AnyObject?
                }
            }
            
            if let birthday = self.birthdayString {
                if birthday != "" {
                    needToUpdateProfil = true
                    dicoParameters[UserDataKey.kDateBirthday] = birthday as AnyObject?
                }
            }
            
            if needToUpdateProfil {
                UserSessionManager.sharedInstance.updateUserProfil(dicoParameters, success: {
                        print("Success update user profil")
                        completion(true)
                    }, fail: { (error, listError) in
                        print("Fail updating user profil")
                        completion(false)
                })
            }
        }
    }
    
    func noCameraAlert() {
        let alertVC = UIAlertController(title: "Oups !", message: "Désolé, aucune camera détectée... :-(", preferredStyle: .alert)
        let agreeAction = UIAlertAction(title: "D'accord", style: .default, handler: nil)
        alertVC.addAction(agreeAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func didChosenAvatarDochaWithImage(_ imageName: String) {
        self.avatarImageName = imageName
    }
    

//MARK: @IBActions
    
    @IBAction func validBarButtonItemTouched(_ sender: UIBarButtonItem) {
        PopupManager.sharedInstance.showLoadingPopup("Mise à jour de ton profil...", message: nil, viewController: self, completion: {
            self.saveUserProfilDataWithCompletion { (success) in
                PopupManager.sharedInstance.dismissPopup(true, completion: {
                    if success {
                        UserSessionManager.sharedInstance.needsToUpdateHome = true
                        _ = self.navigationController?.popViewController(animated: true)
                        
                    } else {
                        PopupManager.sharedInstance.showErrorPopup("Oups !", message: "La connexion internet semble interrompue. Essaie à nouveau ultérieurement.", completion: nil)
                    }
                })
            }
        })
    }
    
    @IBAction func cancelBarButtonItemTouched(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
