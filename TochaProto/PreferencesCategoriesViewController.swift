//
//  PreferencesCategoriesViewController.swift
//  Docha
//
//  Created by Mathis D on 27/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import SCLAlertView
import Amplitude_iOS

class PreferencesCategoriesViewController: RootViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let CATEGORY_NUMBER = 10
    let reuseIdentifier = "idPreferencesCategoryCollectionCell"
    
    let categoriesImagesPathArray = ["lifestyle", "high-tech", "maison_deco", "bijoux_montres", "electromenager", "art", "objets_connectes", "gastronomie_vin", "beauty", "sport"]
    let categoriesNames = ["Lifestyle", "High-Tech", "Maison / déco", "Bijoux / Montres", "Électroménager", "Art", "Objets connectés", "Gastronomie", "Beauté", "Sport"]
    var categoriesImages = [UIImage]?()
    var categoriesPrefered: [String]?
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var infoButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var footerValidateView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Amplitude
        Amplitude.instance().logEvent("Preferences category selection opened")
        
        self.navigationController!.setNavigationBarHidden(false, animated: false)
        self.footerValidateView.alpha = 0.0
        
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.collectionView.backgroundView = nil
        
        self.configNavigationBarWithTitle("Choisissez votre catégorie préférée", andFontSize: 13.0)
        
        loadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func loadData() {
        self.categoriesImages = [UIImage]()
        for item in categoriesImagesPathArray {
            categoriesImages?.append(UIImage(named: item)!)
        }
        
        self.collectionView.reloadData()
        
        let currentSession = UserSessionManager.sharedInstance.currentSession()
        self.categoriesPrefered = currentSession?.categoriesFavorites
        if self.categoriesPrefered == nil {
            self.categoriesPrefered = []
        }
    }
    
    func saveCategorieFavoriteWithUserSession(userSession: UserSession, completion: ( (success: Bool) -> Void)) {
        let params = userSession.generateJSONFromUserSession()
        
        if let param = params {
            UserSessionManager.sharedInstance.updateUserProfil(param, success: {
                print("Success categories VC")
                PopupManager.sharedInstance.dismissPopup(true, completion: {
                    PopupManager.sharedInstance.showSuccessPopup("Succès !", message: "Tes catégories préférées ont été mise à jour 😎", viewController: self, completion: nil, doneActionCompletion: {
                        completion(success: true)
                    })
                })
            }, fail: { (error, listError) in
                PopupManager.sharedInstance.dismissPopup(true, completion: {
                    print("Fail categories VC")
                    PopupManager.sharedInstance.showErrorPopup("Oups !", message: "Il semblerait que tu ne possède pas de connexion à internet... Essaie ultérieurement.", viewController: self, completion: nil, doneActionCompletion: {
                        completion(success: false)
                    })
                })
            })
        }
    }
    
    
//MARK: Collection View Data Source Methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CATEGORY_NUMBER
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! InscriptionCategoryCollectionViewCell
        
        cell.categoryImageView.image = self.categoriesImages![indexPath.item]
        cell.categoryName = self.categoriesImagesPathArray[indexPath.item]
        cell.categoryNameLabel.text = self.categoriesNames[indexPath.item]
        
        if let categoriesPrefered = self.categoriesPrefered {
            if categoriesPrefered.contains(cell.categoryName!) == true {
                cell.imageSelected = true
            } else {
                cell.imageSelected = false
            }
        } else {
            cell.imageSelected = false
        }
        return cell
    }
    
    
//MARK: Collection View Delegate Methods
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cellSelected = collectionView.cellForItemAtIndexPath(indexPath) as! InscriptionCategoryCollectionViewCell
        if cellSelected.imageSelected {
            cellSelected.imageSelected = false
            self.categoriesPrefered?.removeObject(cellSelected.categoryName)
            
        } else {
            cellSelected.imageSelected = true
            self.categoriesPrefered?.append(cellSelected.categoryName)
        }
    }
    
    
//MARK: @IBActions
    
    @IBAction func backButtonTouched(sender: UIBarButtonItem) {
        let currentSession = UserSessionManager.sharedInstance.currentSession()
        
        if self.categoriesPrefered == nil || (self.categoriesPrefered?.isEmpty)! {
            self.navigationController?.popViewControllerAnimated(true)
            
        } else if self.categoriesPrefered! == (currentSession?.categoriesFavorites)! {
            self.navigationController?.popViewControllerAnimated(true)
            
        } else {
            PopupManager.sharedInstance.showLoadingPopup("Chargement...", message: "Mise à jour de ton profil Docha...", viewController: self, completion: nil)
            let categoriesFavoritesTemp = currentSession?.categoriesFavorites
            currentSession?.categoriesFavorites = self.categoriesPrefered
            
            if let currentSession = currentSession {
                saveCategorieFavoriteWithUserSession(currentSession, completion: { (success) in
                    if success {
                        self.navigationController?.popViewControllerAnimated(true)
                    } else {
                        self.categoriesPrefered = categoriesFavoritesTemp
                        self.collectionView.reloadData()
                    }
                })
            }
        }
    }
    
    @IBAction func infosButtonTouched(sender: UIBarButtonItem) {
        PopupManager.sharedInstance.showInfosPopup("Info", message: "Nous souhaitons te proposer au maximum des produits qui te correspondent.", viewController: self, completion: nil)
    }
}