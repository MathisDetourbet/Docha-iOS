//
//  PreferencesCategoriesViewController.swift
//  Docha
//
//  Created by Mathis D on 27/06/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import Amplitude_iOS

class PreferencesCategoriesViewController: RootViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let CATEGORY_NUMBER = 10
    let reuseIdentifier = "idPreferencesCategoryCollectionCell"
    
    let categoriesImagesPathArray = ["lifestyle", "high-tech", "maison_deco", "bijoux_montres", "electromenager", "art", "objets_connectes", "gastronomie_vin", "beauty", "sport"]
    let categoriesNames = ["Lifestyle", "High-Tech", "Maison / déco", "Bijoux / Montres", "Électroménager", "Art", "Objets connectés", "Gastronomie", "Beauté", "Sport"]
    var categoriesImages: [UIImage]?
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
        
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.backgroundView = nil
        
        self.configNavigationBarWithTitle("Choisissez votre catégorie préférée", andFontSize: 13.0)
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func loadData() {
        self.categoriesImages = [UIImage]()
        for item in categoriesImagesPathArray {
            categoriesImages?.append(UIImage(named: item)!)
        }
        
        self.collectionView.reloadData()
        
        let currentSession = UserSessionManager.sharedInstance.currentSession()
        self.categoriesPrefered = currentSession?.categoriesPrefered
        if self.categoriesPrefered == nil {
            self.categoriesPrefered = []
        }
    }
    
    func saveCategorieFavoriteWithUserSession(_ userSession: UserSession, completion: @escaping ( (_ success: Bool) -> Void)) {
        let params = userSession.generateJSONFromUserSession()
        
        if let param = params {
//            UserSessionManager.sharedInstance.updateUserProfil(param, success: {
//                print("Success categories VC")
//                PopupManager.sharedInstance.dismissPopup(true, completion: {
//                    PopupManager.sharedInstance.showSuccessPopup("Succès !", message: "Tes catégories préférées ont été mise à jour 😎", viewController: self, completion: nil, doneActionCompletion: {
//                        completion(true)
//                    })
//                })
//            }, fail: { (error, listError) in
//                PopupManager.sharedInstance.dismissPopup(true, completion: {
//                    print("Fail categories VC")
//                    PopupManager.sharedInstance.showErrorPopup("Oups !", message: "Il semblerait que tu ne possède pas de connexion à internet... Essaie ultérieurement.", viewController: self, completion: nil, doneActionCompletion: {
//                        completion(false)
//                    })
//                })
//            })
        }
    }
    
    
//MARK: Collection View Data Source Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CATEGORY_NUMBER
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! InscriptionCategoryCollectionViewCell
        
        cell.categoryImageView.image = self.categoriesImages![(indexPath as NSIndexPath).item]
        cell.categoryName = self.categoriesImagesPathArray[(indexPath as NSIndexPath).item]
        cell.categoryNameLabel.text = self.categoriesNames[(indexPath as NSIndexPath).item]
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellSelected = collectionView.cellForItem(at: indexPath) as! InscriptionCategoryCollectionViewCell
        if cellSelected.imageSelected {
            cellSelected.imageSelected = false
            self.categoriesPrefered?.removeObject(cellSelected.categoryName)
            
        } else {
            cellSelected.imageSelected = true
            self.categoriesPrefered?.append(cellSelected.categoryName)
        }
    }
    
    
//MARK: @IBActions
    
    @IBAction func backButtonTouched(_ sender: UIBarButtonItem) {
        let currentSession = UserSessionManager.sharedInstance.currentSession()
        
        if self.categoriesPrefered == nil || (self.categoriesPrefered?.isEmpty)! {
            _ = self.navigationController?.popViewController(animated: true)
            
        } else if self.categoriesPrefered! == (currentSession?.categoriesPrefered)! {
            _ = self.navigationController?.popViewController(animated: true)
            
        } else {
            PopupManager.sharedInstance.showLoadingPopup("Chargement...", message: "Mise à jour de ton profil Docha...", viewController: self, completion: nil)
            let categoriesFavoritesTemp = currentSession?.categoriesPrefered
            currentSession?.categoriesPrefered = self.categoriesPrefered!
            
            if let currentSession = currentSession {
                saveCategorieFavoriteWithUserSession(currentSession, completion: { (success) in
                    if success {
                        _ = self.navigationController?.popViewController(animated: true)
                    } else {
                        self.categoriesPrefered = categoriesFavoritesTemp
                        self.collectionView.reloadData()
                    }
                })
            }
        }
    }
    
    @IBAction func infosButtonTouched(_ sender: UIBarButtonItem) {
        PopupManager.sharedInstance.showInfosPopup("Info", message: "Nous souhaitons te proposer au maximum des produits qui te correspondent.", viewController: self, completion: nil)
    }
}
