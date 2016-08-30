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
    let reuseIdentifier = "idCategoryCollectionCell"
    
    let categoriesImagesPathArray = ["lifestyle", "high-tech", "maison_deco", "bijoux_montres", "electromenager", "art", "objets_connectes", "gastronomie_vin", "beauty", "sport"]
    var categoriesImages = [UIImage]?()
    var categoryPrefered: String?
    var oldCategoryIndexPath: NSIndexPath?
    
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
        
        self.categoryPrefered = UserSessionManager.sharedInstance.currentSession()?.categoryFavorite
        
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
        self.categoryPrefered = currentSession?.categoryFavorite
    }
    
    func saveCategorieFavoriteWithUserSession(userSession: UserSession, completion: ( (success: Bool) -> Void)) {
        let params = userSession.generateJSONFromUserSession()
        if let param = params {
            UserSessionManager.sharedInstance.updateUserProfil(param, success: {
                print("Success categories VC")
                completion(success: true)
                PopupManager.sharedInstance.dismissPopup(true, completion: {
                    PopupManager.sharedInstance.showSuccessPopup("Succès !", message: "Ta catégorie a été mise à jour 😎", completion: nil)
                })
            }, fail: { (error, listError) in
                self.dismissViewControllerAnimated(true, completion: { 
                    print("Fail categories VC")
                    PopupManager.sharedInstance.showErrorPopup("Oups !", message: "Il semblerait que tu ne possède pas de connexion à internet, la catégorie n'a pas pu être modifée... Essaie ultérieurement.", completion: nil)
                })
                completion(success: false)
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
        
        if let categoryFavorite = self.categoryPrefered {
            if cell.categoryName! == categoryFavorite {
                cell.imageSelected = true
                self.oldCategoryIndexPath = indexPath
            }
        } else {
            cell.imageSelected = false
        }
        return cell
    }
    
    
//MARK: Collection View Delegate Methods
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        PopupManager.sharedInstance.showLoadingPopup("Chargement...", message: "Mise à jour de ton profil Docha...", completion: nil)
        // Deselect old cell
        if self.oldCategoryIndexPath != nil {
            let oldCellSelected = collectionView.cellForItemAtIndexPath(oldCategoryIndexPath!) as! InscriptionCategoryCollectionViewCell
            oldCellSelected.imageSelected = false
        }
        
        let cellSelected = collectionView.cellForItemAtIndexPath(indexPath) as! InscriptionCategoryCollectionViewCell
        cellSelected.imageSelected = true
        self.categoryPrefered = cellSelected.categoryName!
        
        let currentSession = UserSessionManager.sharedInstance.currentSession()
        currentSession?.categoryFavorite = self.categoryPrefered
        currentSession?.saveSession()
        
        if let userSession = currentSession {
            saveCategorieFavoriteWithUserSession(userSession, completion: { (success) in
                if success {
                    self.oldCategoryIndexPath = indexPath
                } else {
                    let cellSelected = collectionView.cellForItemAtIndexPath(self.oldCategoryIndexPath!) as! InscriptionCategoryCollectionViewCell
                    cellSelected.imageSelected = true
                    self.categoryPrefered = cellSelected.categoryName!
                    
                    let cellDeselected = collectionView.cellForItemAtIndexPath(indexPath) as! InscriptionCategoryCollectionViewCell
                    cellDeselected.imageSelected = false
                }
            })
        }
    }
    
    
//MARK: @IBActions
    
    @IBAction func backButtonTouched(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func infosButtonTouched(sender: UIBarButtonItem) {
        PopupManager.sharedInstance.showInfosPopup("Info", message: "Nous souhaitons te proposer au maximum des produits qui te correspondent.", completion: nil)
    }
}