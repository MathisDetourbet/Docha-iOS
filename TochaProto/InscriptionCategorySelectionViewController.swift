//
//  InscriptionCategorySelectionViewController.swift
//  DochaProto
//
//  Created by Mathis D on 27/05/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

class InscriptionCategorySelectionViewController: RootViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let CATEGORY_NUMBER = 10
    let reuseIdentifier = "idCategoryCollectionCell"
    
    let categoriesImagesPathArray = ["lifestyle", "high_tech", "maison_deco", "bijoux_montres", "electromenager", "art", "objets_connectes", "gastronomie_vin", "beauty", "sport"]
    let categoriesNames = ["Lifestyle", "High-Tech", "Maison / déco", "Bijoux / Montres", "Électroménager", "Art", "Objets connectés", "Gastronomie", "Beauté", "Sport"]
    var categoriesList: [Category]?
    var categoriesImages: [UIImage]?
    var categoryPrefered: [String] = []
    var comeFromConnexionVC: Bool = false
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var infoButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var footerValidateView: UIView!
    @IBOutlet weak var heightCollectionViewConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.setNavigationBarHidden(false, animated: false)
        footerValidateView.alpha = 0.0
        
        collectionView.backgroundColor = UIColor.clear
        collectionView.backgroundView = nil
        
        configNavigationBarWithTitle("Choisis tes catégories préférées")
        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func loadCategories() {
        self.categoriesList = []
        
        UserSessionManager.sharedInstance.getAllCategory(
            success: { (categoriesList) in
                
                for category in categoriesList {
                    category.image = UIImage(named: category.slugName)
                    self.categoriesList?.append(category)
                }
                
                self.collectionView.reloadData()
            })
            {(error) in
                
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
    
    func showFooterView(whithCompletion completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.3,
            animations: {
                self.heightCollectionViewConstraint.constant -= self.footerValidateView.frame.size.height
                self.footerValidateView.alpha = 1.0
                self.view.layoutIfNeeded()
            }
        )
    }
    
    func hideFooterView(withCompletion completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.3,
            animations: {
                self.heightCollectionViewConstraint.constant += self.footerValidateView.frame.size.height
                self.footerValidateView.alpha = 0.0
                self.view.layoutIfNeeded()
            }
        )
    }

    
//MARK: Collection View Data Source Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ((categoriesList != nil) ? categoriesList!.count : 0)
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
            cell.imageSelected = categoryPrefered.contains(category.slugName) ? true : false
        }
        
        return cell
    }
    
    
//MARK: Collection View Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellSelected = collectionView.cellForItem(at: indexPath) as! InscriptionCategoryCollectionViewCell
        if cellSelected.imageSelected {
            cellSelected.imageSelected = false
            categoryPrefered.removeObject(cellSelected.categoryName)
            
            if categoryPrefered.isEmpty {
                hideFooterView(withCompletion: nil)
            }
            
        } else {
            cellSelected.imageSelected = true
            
            if categoryPrefered.isEmpty {
                showFooterView(whithCompletion: nil)
            }
            
            categoryPrefered.append(cellSelected.categoryName)
        }
    }
  
    
//MARK: @IBAction
    
    @IBAction func validButtonTouched(_ sender: UIButton) {
        if comeFromConnexionVC {
            
            PopupManager.sharedInstance.showLoadingPopup(message: nil,
                completion: {
                    let data = [UserDataKey.kCategoryPrefered: self.categoryPrefered]
                    
                    UserSessionManager.sharedInstance.updateUser(withData: data,
                        success: {
                            PopupManager.sharedInstance.dismissPopup(true,
                                completion: {
                                    self.goToHome()
                                }
                            )
                                                                    
                        }, fail: { (error) in
                            PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorNoInternetConnection)
                        }
                    )
                }
            )
            
        } else {
            let inscriptionIdentifiantsVC = storyboard?.instantiateViewController(withIdentifier: "idInscriptionIdentifiantsViewController") as! InscriptionIdentifiantsViewController
            inscriptionIdentifiantsVC.categoryFavorites = categoryPrefered
            self.navigationController?.pushViewController(inscriptionIdentifiantsVC, animated: true)
        }
    }
    
    @IBAction func backButtonTouched(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func infosButtonTouched(_ sender: UIBarButtonItem) {
        PopupManager.sharedInstance.showInfosPopup(message: Constants.PopupMessage.InfosMessage.kInfosCategoryHelp)
    }
}
