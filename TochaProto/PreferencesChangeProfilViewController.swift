//
//  PreferencesChangeProfilViewController.swift
//  Docha
//
//  Created by Mathis D on 06/07/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import SCLAlertView

class PreferencesChangeProfilViewController: RootViewController, UITableViewDelegate, UITableViewDataSource, PseudoCellDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RSKImageCropViewControllerDelegate, ChooseAvatarDochaDelegate {
    
    var userSession: UserSession?
    var pseudoIndexPath: NSIndexPath?
    var birthdayIndexPathCell: NSIndexPath?
    var avatarIndexPath: NSIndexPath?
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

        self.validBarButtonItem.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Montserrat-SemiBold", size: 11.0)!], forState: .Normal)
        self.cancelBarButtonItem.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Montserrat-SemiBold", size: 11.0)!], forState: .Normal)

        self.heightTableViewConstraint.constant = 4 * tableView.rowHeight + tableView.sectionHeaderHeight + tableView.sectionFooterHeight
        
        self.imagePicker.delegate = self
    }
    
    
//MARK: UITableViewDataSource Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("idPreferencesChangePseudoCell") as! PreferencesChangePseudoTableViewCell
            let userName = userSession?.username
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
            let cell = tableView.dequeueReusableCellWithIdentifier("idPreferencesChangeProfilCell") as! PreferencesChangeProfilTableViewCell
            if indexPath.row == 1 {
                cell.titleLabel.text = "Avatar / Photo de profil"
                cell.imageViewCell.image = UIImage(named: "smile_icon")
                cell.accessoryType = .DisclosureIndicator
                self.avatarIndexPath = indexPath
                
            } else if indexPath.row == 2 {
                let newCell = tableView.dequeueReusableCellWithIdentifier("idPreferencesChangePseudoCell") as! PreferencesChangePseudoTableViewCell
                newCell.pseudoTextField.attributedPlaceholder = NSAttributedString(string: "Anniversaire", attributes: [NSFontAttributeName: UIFont(name: "Montserrat-Regular", size: 15.0)!])
                
                if let dateOfBirthday = userSession!.dateBirthday {
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "dd MMMM yyyy"
                    newCell.pseudoTextField.text = dateFormatter.stringFromDate(dateOfBirthday)
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
                
            } else if indexPath.row == 3 {
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 1 {
            let alertController = UIAlertController(title: "Choisir une action", message: nil, preferredStyle: .ActionSheet)
            alertController.view.tintColor = UIColor.redDochaColor()
            var action = UIAlertAction(title: "Choisir un avatar Docha", style: .Default, handler: { (_) in
                let chooseAvatarVC = self.storyboard?.instantiateViewControllerWithIdentifier("idChooseAvatarViewController") as! PreferencesChoosAvatarViewController
                chooseAvatarVC.delegate = self
                self.presentViewController(chooseAvatarVC, animated: true, completion: nil)
            })
            alertController.addAction(action)
            
            action = UIAlertAction(title: "Choisir dans vos albums", style: .Default, handler: { (_) in
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = .PhotoLibrary
                self.presentViewController(self.imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(action)
            
            action = UIAlertAction(title: "Prendre une photo", style: .Default, handler: { (_) in
                if (UIImagePickerController.availableCaptureModesForCameraDevice(.Front) != nil) || (UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil) {
                    self.imagePicker.allowsEditing = false
                    self.imagePicker.sourceType = .Camera
                    self.imagePicker.cameraCaptureMode = .Photo
                    self.imagePicker.modalPresentationStyle = .FullScreen
                    self.presentViewController(self.imagePicker, animated: true, completion: nil)
                    
                } else {
                    self.noCameraAlert()
                }
            })
            alertController.addAction(action)
            
            let cancelAction = UIAlertAction(title: "Annuler", style: .Cancel, handler: { (_) in
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            })
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            alertController.view.tintColor = UIColor.redDochaColor()
            
        } else if  indexPath.row == 2 {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! PreferencesChangePseudoTableViewCell
            textFieldTouched(cell.pseudoTextField)
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
        } else if indexPath.row == 3 {
            let alertController = UIAlertController(title: "Sexe", message: nil, preferredStyle: .ActionSheet)
            alertController.view.tintColor = UIColor.redDochaColor()
            let genderArray = ["Homme", "Femme", "Autre"]
            
            for gender in genderArray {
                let action = UIAlertAction(title: gender, style: .Default, handler: { (_) in
                    let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! PreferencesChangeProfilTableViewCell
                    cell.titleLabel.text = gender
                    self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    self.genderNotConverted = gender
                })
                alertController.addAction(action)
            }
            let cancelAction = UIAlertAction(title: "Annuler", style: .Cancel, handler: { (_) in
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            })
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            alertController.view.tintColor = UIColor.redDochaColor()
        }
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    

//MARK: UIImagePickerControllerDelegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageViewPicked = UIImageView(image: pickedImage)
            imageViewPicked!.contentMode = .ScaleToFill
        }
        dismissViewControllerAnimated(true, completion: nil)
        let imageCropVC = RSKImageCropViewController(image: imageViewPicked!.image!)
        imageCropVC.delegate = self
        imageCropVC.moveAndScaleLabel.text = "Recadrer"
        imageCropVC.cancelButton.setTitle("Annuler", forState: .Normal)
        imageCropVC.chooseButton.setTitle("Choisir", forState: .Normal)
        
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(imageCropVC, animated: true)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.tableView.deselectRowAtIndexPath(self.avatarIndexPath!, animated: true)
        dismissViewControllerAnimated(true, completion: nil)
    }
    

//MARK: RSKImageCropViewControllerDelegate Methods
    
    func imageCropViewControllerDidCancelCrop(controller: RSKImageCropViewController) {
        self.tableView.deselectRowAtIndexPath(self.avatarIndexPath!, animated: true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func imageCropViewController(controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        self.imageViewPicked = UIImageView(image: croppedImage)
        self.imageViewPicked?.contentMode = .ScaleToFill
        self.tableView.deselectRowAtIndexPath(self.avatarIndexPath!, animated: true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func textFieldTouched(sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
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
        
        datePickerView.addTarget(self, action: #selector(PreferencesChangeProfilViewController.handleDatePicker(_:textField:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func handleDatePicker(sender: UIDatePicker, textField: UITextField) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        textField.text = dateFormatter.stringFromDate(sender.date)
        
        self.birthdayString = dateFormatter.stringFromDate(sender.date)
        
        let cell = tableView.cellForRowAtIndexPath(self.birthdayIndexPathCell!) as! PreferencesChangePseudoTableViewCell
        cell.pseudoTextField.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func saveUserProfilDataWithCompletion(completion: (success: Bool) -> Void) {
        var needToUpdateProfil = false
        
        // Save Profile Image
        if let _ = self.imageViewPicked, imageToSave = self.imageViewPicked?.image {
            needToUpdateProfil = true
            UserSessionManager.sharedInstance.currentSession()?.saveProfileImage(imageToSave)
            UserSessionManager.sharedInstance.currentSession()!.updateProfilImagePrefered(.PhotoImage)
        }
        
        // Save other user data
        if var dicoParameters = self.userSession?.generateJSONFromUserSession() {
            
            if let _ = self.avatarImageName {
                needToUpdateProfil = true
                dicoParameters[UserDataKey.kAvatar] = self.avatarImageName
                UserSessionManager.sharedInstance.currentSession()!.updateProfilImagePrefered(.AvatarDochaImage)
            }
            
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
                dicoParameters[UserDataKey.kGender] = finalGender
            }
            
            let pseudoCell = self.tableView.cellForRowAtIndexPath(self.pseudoIndexPath!) as! PreferencesChangePseudoTableViewCell
            let pseudoString = pseudoCell.pseudoTextField.text
            if let pseudo = pseudoString {
                if pseudo != "" {
                    needToUpdateProfil = true
                    dicoParameters[UserDataKey.kUsername] = pseudo
                }
            }
            
            if let birthday = self.birthdayString {
                if birthday != "" {
                    needToUpdateProfil = true
                    dicoParameters[UserDataKey.kDateBirthday] = birthday
                }
            }
            
            if needToUpdateProfil {
                UserSessionManager.sharedInstance.updateUserProfil(dicoParameters, success: {
                        print("Success update user profil")
                        completion(success: true)
                    }, fail: { (error, listError) in
                        print("Fail updating user profil")
                        completion(success: false)
                })
            }
        }
    }
    
    func noCameraAlert() {
        let alertVC = UIAlertController(title: "Oups !", message: "Désolé, aucune camera détectée... :-(", preferredStyle: .Alert)
        let agreeAction = UIAlertAction(title: "D'accord", style: .Default, handler: nil)
        alertVC.addAction(agreeAction)
        self.presentViewController(alertVC, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func didChosenAvatarDochaWithImage(imageName: String) {
        self.avatarImageName = imageName
    }
    

//MARK: @IBActions
    
    @IBAction func validBarButtonItemTouched(sender: UIBarButtonItem) {
        self.presentViewController(DochaPopupHelper.sharedInstance.showLoadingPopup("Mise à jour de ton profil...")!, animated: true, completion: {
            self.saveUserProfilDataWithCompletion { (success) in
                self.dismissViewControllerAnimated(true, completion: {
                    
                    if success {
                        UserSessionManager.sharedInstance.needsToUpdateHome = true
                        self.navigationController?.popViewControllerAnimated(true)
                        
                    } else {
                        self.presentViewController(DochaPopupHelper.sharedInstance.showErrorPopup("Oups...", message: "La connexion internet semble interrompue...")!, animated: true, completion: nil)
                    }
                })
            }
        })
    }
    
    @IBAction func cancelBarButtonItemTouched(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}