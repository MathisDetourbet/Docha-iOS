//
//  NewGameCategorieSelectionViewController.swift
//  Docha
//
//  Created by Mathis D on 01/09/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class NewGameCategorieSelectionViewController: GameViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let categoriesNamesImageView = ["Lifestyle" : "lifestyle", "High-Tech" : "high-tech", "Maison / déco" : "maison_deco", "Bijoux / Montres" : "bijoux_montres", "Électroménager" : "electromenager", "Art" : "art", "Objets connectés" : "objets_connectes", "Gastronomie" : "gastronomie_vin", "Beauté" : "beauty", "Sport" : "sport"]
    var categoriesDisplayed: [String]?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
//MARK: Life View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildUI()
        generateCategories()
    }
    
    func buildUI() {
        self.view.backgroundColor = UIColor.lightGrayDochaColor()
        self.collectionView.backgroundColor = UIColor.lightGrayDochaColor()
    }
    
    
//MARK: UICollectionView - Data Source Methods
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("idNewGameCategorySelectionCollectionCell", forIndexPath: indexPath) as! InscriptionCategoryCollectionViewCell
        
        cell.categoryName = self.categoriesDisplayed![indexPath.item]
        cell.imageSelected = false
        cell.categoryImageView.image = UIImage(named: self.categoriesNamesImageView[self.categoriesDisplayed![indexPath.item]]!)
        
        return cell
    }
    

//MARK: UICollectionView - Delegate Methods
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = self.collectionView.cellForItemAtIndexPath(indexPath) as! InscriptionCategoryCollectionViewCell
        let categorySelected = cell.categoryName
        let launcherVC = self.storyboard?.instantiateViewControllerWithIdentifier("idGameplayLauncherViewController") as! GameplayLauncherViewController
        launcherVC.categoryNameSelected = categorySelected
        self.navigationController?.pushViewController(launcherVC, animated: true)
    }
    
    
//MARK: @IBActions Methods
    
    @IBAction func changeCategorieButtonTouched(sender: UIButton) {
        generateCategories()
    }
    
    @IBAction func backButtonTouched(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
//MARK: Helper Methods
    
    func generateCategories(number: Int? = 4) {
        var categoriesGenerated: [String] = []
        let categoriesAvailables = ["Lifestyle", "High-Tech", "Maison / déco", "Bijoux / Montres", "Électroménager", "Art", "Objets connectés", "Gastronomie", "Beauté", "Sport"]
        let categoriesShuffled = categoriesAvailables.shuffle()
        
        for i in 0...3 {
            categoriesGenerated.append(categoriesShuffled[i])
        }
        
        self.categoriesDisplayed = categoriesGenerated
        self.collectionView.reloadData()
    }
}