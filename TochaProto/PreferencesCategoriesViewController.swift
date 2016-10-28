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
    
    let categoriesImagesPathArray = ["lifestyle", "high_tech", "maison_deco", "bijoux_montres", "electromenager", "art", "objets_connectes", "gastronomie_vin", "beauty", "sport"]
    let categoriesNames = ["Lifestyle", "High-Tech", "Maison / déco", "Bijoux / Montres", "Électroménager", "Art", "Objets connectés", "Gastronomie", "Beauté", "Sport"]
    var categoriesImages: [UIImage]?
    var categoriesPrefered: [String]? = UserSessionManager.sharedInstance.getUserInfosAndAvatarImage().user?.categoriesPrefered
    var categoriesList: [Category]?
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var infoButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Amplitude
        Amplitude.instance().logEvent("Preferences category selection opened")
        
        self.navigationController!.setNavigationBarHidden(false, animated: false)
        
        collectionView.backgroundColor = UIColor.clear
        collectionView.backgroundView = nil
        
        configNavigationBarWithTitle("Choisis tes catégories préférées")
        
        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func loadCategories() {
        categoriesList = []
        
        UserSessionManager.sharedInstance.getAllCategory(
            success: { (categoriesList) in
                
                for category in categoriesList {
                    category.image = UIImage(named: category.slugName)
                    self.categoriesList?.append(category)
                }
                
                self.collectionView.reloadData()
            }
        )
        { (error) in
            
            var index = 0
            for item in self.categoriesImagesPathArray {
                let image = UIImage(named: item)
                let category = Category(name: self.categoriesNames[index], slugName: item, image: image)
                self.categoriesList?.append(category)
                index += 1
            }
            
            self.collectionView.reloadData()
        }
    }
    
    func saveCategorieFavorite(withdData data: [String: Any], _ success: @escaping () -> Void, fail failure: @escaping (_ error: Error?) -> Void) {
        UserSessionManager.sharedInstance.updateUser(withData: data,
            success: {
                success()
            }
        ) { (error) in
                failure(error)
        }
    }
    
    
//MARK: Collection View Data Source Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let categoriesList = self.categoriesList {
            return categoriesList.count
            
        } else {
            return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! InscriptionCategoryCollectionViewCell
        
        if let category = categoriesList?[indexPath.item] {
            cell.categoryName = category.slugName
            cell.categoryNameLabel.text = category.name
            cell.categoryImageView.image = category.image
            cell.imageSelected = false
            
            if let categoriesPrefered = categoriesPrefered {
                cell.imageSelected = categoriesPrefered.contains(category.slugName) ? true : false
                
            } else {
                cell.imageSelected = false
            }
        }
        
        return cell
    }
    
    
//MARK: Collection View Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellSelected = collectionView.cellForItem(at: indexPath) as! InscriptionCategoryCollectionViewCell
        if cellSelected.imageSelected {
            cellSelected.imageSelected = false
            categoriesPrefered?.removeObject(cellSelected.categoryName)
            
        } else {
            cellSelected.imageSelected = true
            categoriesPrefered?.append(cellSelected.categoryName)
        }
    }
    
    
//MARK: @IBActions
    
    @IBAction func backButtonTouched(_ sender: UIBarButtonItem) {
        let userData = UserSessionManager.sharedInstance.getUserInfosAndAvatarImage().user!
        
        if let categoriesPrefered = self.categoriesPrefered {
            if categoriesPrefered.isEmpty {
                PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorNoCategorySelected, viewController: self, doneActionCompletion: {
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                )
                
            } else if containSameElements(array1: userData.categoriesPrefered, categoriesPrefered) {
                _ = self.navigationController?.popViewController(animated: true)
                
            } else {
                PopupManager.sharedInstance.showLoadingPopup(message: Constants.PopupMessage.InfosMessage.kUserProfilUpdating, viewController: self, completion: {
                    let data = [UserDataKey.kCategoryPrefered: categoriesPrefered]
                    self.saveCategorieFavorite(withdData: data,
                        {
                            PopupManager.sharedInstance.dismissPopup(true,
                                completion: {
                                    _ = self.navigationController?.popViewController(animated: true)
                                }
                            )
                                            
                        }, fail: { (error) in
                            PopupManager.sharedInstance.dismissPopup(true,
                                completion: {
                                    PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorNoInternetConnection, viewController: self,
                                            doneActionCompletion: {
                                                _ = self.navigationController?.popViewController(animated: true)
                                            }
                                    )
                                }
                            )
                        }
                    )}
                )
            }
            
        } else {
            PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorNoCategorySelected, viewController: self, doneActionCompletion: {
                    _ = self.navigationController?.popViewController(animated: true)
                }
            )
        }
    }
    
    @IBAction func infosButtonTouched(_ sender: UIBarButtonItem) {
        PopupManager.sharedInstance.showInfosPopup(message: Constants.PopupMessage.InfosMessage.kInfosCategoryHelp, viewController: self, completion: nil)
    }
    
    
//MARK: Helper Method
    
    func containSameElements<T: Comparable>(array1: [T], _ array2: [T]) -> Bool {
        guard array1.count == array2.count else {
            return false // No need to sorting if they already have different counts
        }
        
        return array1.sorted() == array2.sorted()
    }
}
