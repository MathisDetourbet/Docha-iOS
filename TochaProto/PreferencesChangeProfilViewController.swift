//
//  PreferencesChangeProfilViewController.swift
//  Docha
//
//  Created by Mathis D on 06/07/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

class PreferencesChangeProfilViewController: RootViewController, UITableViewDelegate, UITableViewDataSource, PseudoCellDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RSKImageCropViewControllerDelegate, ChooseAvatarDochaDelegate {
    
    var pseudoIndexPath: IndexPath?
    var birthdayIndexPathCell: IndexPath?
    var avatarIndexPath: IndexPath?
    let imagePicker = UIImagePickerController()
    var imageViewPicked: UIImageView?
    var genderNotConverted: String?
    var birthdayString: String?
    var avatarImageName: String?
    var dataUser = UserSessionManager.sharedInstance.getUserInfosAndAvatarImage()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var validBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var heightTableViewConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configNavigationBarWithTitle("Modifier le profil")

        validBarButtonItem.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Montserrat-SemiBold", size: 11.0)!], for: UIControlState())
        cancelBarButtonItem.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Montserrat-SemiBold", size: 11.0)!], for: UIControlState())

        heightTableViewConstraint.constant = 4 * tableView.rowHeight + tableView.sectionHeaderHeight + tableView.sectionFooterHeight
        
        imagePicker.delegate = self
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
            
            if let pseudo = dataUser.user?.pseudo {
                cell.pseudoTextField.text = pseudo.isEmpty ? nil : pseudo
                cell.pseudoTextField.font = UIFont(name: "Montserrat-Regular", size: 15.0)
                cell.pseudoTextField.placeholder = nil
                
            } else {
                cell.pseudoTextField.placeholder = "Pseudo"
                cell.pseudoTextField.attributedPlaceholder = NSAttributedString(string: "Pseudo", attributes: [NSFontAttributeName: UIFont(name: "Montserrat-Regular", size: 15.0)!])
                cell.pseudoTextField.text = nil
            }
            
            cell.delegate = self
            cell.imageViewCell.image = UIImage(named: "profil_icon")
            self.pseudoIndexPath = indexPath
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "idPreferencesChangeProfilCell") as! PreferencesChangeProfilTableViewCell
            
            if (indexPath as NSIndexPath).row == 1 {
                let newCell = tableView.dequeueReusableCell(withIdentifier: "idPreferencesChangePseudoCell") as! PreferencesChangePseudoTableViewCell
                
                newCell.pseudoTextField.attributedPlaceholder = NSAttributedString(string: "Anniversaire", attributes: [NSFontAttributeName: UIFont(name: "Montserrat-Regular", size: 15.0)!])
                
                if let birthday = dataUser.user?.dateBirthday {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd MMMM yyyy"
                    newCell.pseudoTextField.text = dateFormatter.string(from: birthday as Date)
                    newCell.pseudoTextField.placeholder = nil
                    
                } else {
                    newCell.pseudoTextField.placeholder = "Anniversaire"
                    newCell.pseudoTextField.text = nil
                }
                
                newCell.imageViewCell.image = UIImage(named: "cake_icon")
                newCell.delegate = self
                newCell.isPseudoCell = false
                birthdayIndexPathCell = indexPath
                
                return newCell
                
            } else if (indexPath as NSIndexPath).row == 2 {
                
                if let gender = dataUser.user?.getGenderDataForDisplay() {
                    cell.titleLabel.text = gender
                    
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
    
    func handleDatePicker(_ sender: UIDatePicker, textField: UITextField) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        textField.text = dateFormatter.string(from: sender.date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        birthdayString = dateFormatter.string(from: sender.date)
        
        let cell = tableView.cellForRow(at: self.birthdayIndexPathCell!) as! PreferencesChangePseudoTableViewCell
        cell.pseudoTextField.text = dateFormatter.string(from: sender.date)
    }
    
    
//MARK: Save User Data Method
    
    func saveUserProfilData(withSuccess success: @escaping () -> Void, fail failure: @escaping (_ errorMessage: String?) -> Void) {
        var data: [String: Any] = [:]
        let pseudoCell = tableView.cellForRow(at: pseudoIndexPath!) as! PreferencesChangePseudoTableViewCell
        if let pseudo = pseudoCell.pseudoTextField.text {
            if pseudo != dataUser.user?.pseudo {
                data[UserDataKey.kUsername] = pseudo
            }
            
        } else {
            failure("Entre un pseudo valide.")
            return
        }
        
        if let birthday = birthdayString {
            data[UserDataKey.kDateBirthday] = birthday
        }
        
        if let gender = genderNotConverted {
            let genderData = ConverterHelper.convertGenderToData(withGender: gender)
            data[UserDataKey.kGender] = genderData
        }
        
        if data.isEmpty {
            success()
            return
        }
        
        UserSessionManager.sharedInstance.updateUser(withData: data,
            success: {
                success()
                
            }, fail: { error in
                failure(Constants.PopupMessage.ErrorMessage.kErrorNoInternetConnection)
            }
        )
    }
    
    func noCameraAlert() {
        let alertVC = UIAlertController(title: "Oups !", message: "Désolé, aucune camera détectée... :-(", preferredStyle: .alert)
        let agreeAction = UIAlertAction(title: "D'accord", style: .default, handler: nil)
        alertVC.addAction(agreeAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    
//MARK: Pseudo Cell Delegate
    
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
//MARK: ChooseAvatarDocha Delegate
    
    func didChosenAvatarDochaWithImage(_ imageName: String) {
        
    }
    

//MARK: @IBActions: Valid & Cancel
    
    @IBAction func validBarButtonItemTouched(_ sender: UIBarButtonItem) {
        PopupManager.sharedInstance.showLoadingPopup("Mise à jour de ton profil...", message: nil, viewController: self,
            completion: {
                self.saveUserProfilData(
                    withSuccess: {
                        PopupManager.sharedInstance.dismissPopup(true,
                            completion: {
                                _ = self.navigationController?.popViewController(animated: true)
                            }
                        )
                        
                    }, fail: { (errorMessage) in
                        PopupManager.sharedInstance.dismissPopup(true,
                            completion: {
                                PopupManager.sharedInstance.showErrorPopup(message: errorMessage, viewController: self)
                            }
                        )
                    }
                )
            }
        )
    }
    
    @IBAction func cancelBarButtonItemTouched(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
