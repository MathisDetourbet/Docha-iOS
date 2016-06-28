//
//  PreferencesCategoriesViewController.swift
//  Docha
//
//  Created by Mathis D on 27/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import SCLAlertView

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
        self.navigationController!.setNavigationBarHidden(false, animated: false)
        self.footerValidateView.alpha = 0.0
        
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.collectionView.backgroundView = nil
        
        self.configNavigationBarWithTitle("Choisissez votre catégorie préférée")
        
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
        if cell.categoryName! == self.categoryPrefered! {
            cell.imageSelected = true
            self.oldCategoryIndexPath = indexPath
        } else {
            cell.imageSelected = false
        }
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
    }
    
    
    // MARK: @IBAction
    
    @IBAction func backButtonTouched(sender: UIBarButtonItem) {
        let currentSession = UserSessionManager.sharedInstance.currentSession()
        currentSession?.categoryFavorite = self.categoryPrefered
        currentSession?.saveSession()
        // Need to update the BDD !!
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func infosButtonTouched(sender: UIBarButtonItem) {
        SCLAlertView().showInfo("Info", subTitle: "Nous souhaitons vous proposer au maximum des produits qui vous correspondent.")
    }
}