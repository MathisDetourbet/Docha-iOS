//
//  InscriptionCategorySelectionViewController.swift
//  DochaProto
//
//  Created by Mathis D on 27/05/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import SCLAlertView

class InscriptionCategorySelectionViewController: RootViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let CATEGORY_NUMBER = 10
    let reuseIdentifier = "idCategoryCollectionCell"
    
    let categoriesImagesPathArray = ["lifestyle", "high-tech", "maison_deco", "bijoux_montres", "electromenager", "art", "objets_connectes", "gastronomie_vin", "beauty", "sport"]
    let categoriesNames = ["Lifestyle", "High-Tech", "Maison / déco", "Bijoux / Montres", "Électroménager", "Art", "Objets connectés", "Gastronomie", "Beauté", "Sport"]
    var categoriesImages = [UIImage]?()
    var categoryPrefered: [String]?
    var comeFromConnexionVC: Bool = false
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var infoButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var footerValidateView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.setNavigationBarHidden(false, animated: false)
        self.footerValidateView.alpha = 0.0
        
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.backgroundView = nil
        self.categoryPrefered = []
        
        self.configNavigationBarWithTitle("Choisis tes catégories préférées")
        
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
        cell.imageSelected = false
        cell.categoryNameLabel.text = self.categoriesNames[(indexPath as NSIndexPath).item]
        
        return cell
    }
    
    
//MARK: Collection View Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellSelected = collectionView.cellForItem(at: indexPath) as! InscriptionCategoryCollectionViewCell
        if cellSelected.imageSelected {
            cellSelected.imageSelected = false
            self.categoryPrefered?.removeObject(cellSelected.categoryName)
            
        } else {
            cellSelected.imageSelected = true
            self.categoryPrefered?.append(cellSelected.categoryName)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.footerValidateView.alpha = 1.0
        }) 
    }
  
    
//MARK: @IBAction
    
    @IBAction func validButtonTouched(_ sender: UIButton) {
        let currentSessionManager = UserSessionManager.sharedInstance
        
        if self.comeFromConnexionVC {
            if let categoryFavorite = self.categoryPrefered {
                
                var params = currentSessionManager.currentSession()?.generateJSONFromUserSession()
                params?["category_favorite"] = categoryFavorite as AnyObject?
                
                if let param = params {
                    UserSessionManager.sharedInstance.updateUserProfil(param, success: {
                        print("Success categories VC")
                    }, fail: { (error, listError) in
                        print("Fail categories VC")
                    })
                }
            }
        }
        
        if currentSessionManager.dicoUserDataInscription == nil {
            currentSessionManager.dicoUserDataInscription = [String:AnyObject]()
            currentSessionManager.dicoUserDataInscription!["category_favorite"] = self.categoryPrefered as AnyObject?
        }
        
        if currentSessionManager.isLogged() {
            // User is already logged with facebook or googleplus
            self.goToHome()
            
        } else {
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "idInscriptionIdentifiantsViewController") as! InscriptionIdentifiantsViewController
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func backButtonTouched(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func infosButtonTouched(_ sender: UIBarButtonItem) {
        PopupManager.sharedInstance.showInfosPopup("Information", message: "Nous souhaitons vous proposer au maximum des produits qui vous correspondent.", completion: nil)
    }
}
