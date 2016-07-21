//
//  InscriptionCategorySelectionViewController.swift
//  DochaProto
//
//  Created by Mathis D on 27/05/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import SCLAlertView

class InscriptionCategorySelectionViewController: RootViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let CATEGORY_NUMBER = 10
    let reuseIdentifier = "idCategoryCollectionCell"
    
    let categoriesImagesPathArray = ["lifestyle", "high-tech", "maison_deco", "bijoux_montres", "electromenager", "art", "objets_connectes", "gastronomie_vin", "beauty", "sport"]
    var categoriesImages = [UIImage]?()
    var categoryPrefered: String?
    var oldCategoryIndexPath: NSIndexPath?
    var comeFromConnexionVC: Bool = false
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var infoButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var footerValidateView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        cell.imageSelected = false
        return cell
    }
    
    //MARK: Collection View Delegate Methods
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // Deselect old cell
        if self.oldCategoryIndexPath != nil {
            let oldCellSelected = collectionView.cellForItemAtIndexPath(oldCategoryIndexPath!) as! InscriptionCategoryCollectionViewCell
            oldCellSelected.imageSelected = false
        }
        
        let cellSelected = collectionView.cellForItemAtIndexPath(indexPath) as! InscriptionCategoryCollectionViewCell
        cellSelected.imageSelected = true
        self.categoryPrefered = cellSelected.categoryName!
        self.oldCategoryIndexPath = indexPath
        
        UIView.animateWithDuration(0.3) {
            self.footerValidateView.alpha = 1.0
        }
    }
    
    // MARK: @IBAction
    @IBAction func validButtonTouched(sender: UIButton) {
        let currentSessionManager = UserSessionManager.sharedInstance
        
        if self.comeFromConnexionVC {
            if let categoryFavorite = self.categoryPrefered {
                
                var params = currentSessionManager.currentSession()?.generateJSONFromUserSession()
                params?["category_favorite"] = categoryFavorite
                
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
            currentSessionManager.dicoUserDataInscription!["category_favorite"] = self.categoryPrefered
        }
        
        if currentSessionManager.isLogged() {
            // User is already logged with facebook or googleplus
            self.goToHome()
            
        } else {
            let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("idInscriptionIdentifiantsViewController") as! InscriptionIdentifiantsViewController
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func backButtonTouched(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func infosButtonTouched(sender: UIBarButtonItem) {
        self.presentViewController(DochaPopupHelper.sharedInstance.showInfoPopup("Info", message: "Nous souhaitons vous proposer au maximum des produits qui vous correspondent.")!, animated: true, completion: nil)
        //SCLAlertView().showInfo("Info", subTitle: "Nous souhaitons vous proposer au maximum des produits qui vous correspondent.")
    }
}