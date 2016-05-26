//
//  InscriptionThirdStepViewController.swift
//  DochaProto
//
//  Created by Mathis D on 22/05/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class InscriptionThirdStepViewController: RootViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let CATEGORY_NUMBER = 10
    let reuseIdentifier = "idCategoryCollectionCell"
    
    let categoriesImagesPathArray = ["lifestyle", "high-tech", "maison_deco", "bijoux_montres", "electromenager", "art", "objets_connectes", "gastronomie_vin", "beauty", "sport"]
    var categoriesImages = [UIImage]?()
    var categoryPrefered: String?
    var oldCategoryIndexPath: NSIndexPath?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var footerValidateView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.footerValidateView.alpha = 0.0
        loadData()
    }
    
    func loadData() {
        self.categoriesImages = [UIImage]()
        for item in categoriesImagesPathArray {
            categoriesImages?.append(UIImage(named: item)!)
        }
        
        self.collectionView.reloadData()
    }
    
    //MARK: Collection View Data Source
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
    
    //MARK: Collection View Delegate
    
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
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        return CGSizeMake(self.view.frame.size.width/2, self.view.frame.size.width/2)
//    }
    
    @IBAction func backButtonTapped(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}