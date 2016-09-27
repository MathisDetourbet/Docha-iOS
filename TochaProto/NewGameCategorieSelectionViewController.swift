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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "idNewGameCategorySelectionCollectionCell", for: indexPath) as! InscriptionCategoryCollectionViewCell
        
        cell.categoryName = self.categoriesDisplayed![(indexPath as NSIndexPath).item]
        cell.imageSelected = false
        cell.categoryImageView.image = UIImage(named: self.categoriesNamesImageView[self.categoriesDisplayed![(indexPath as NSIndexPath).item]]!)
        
        return cell
    }
    

//MARK: UICollectionView - Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = self.collectionView.cellForItem(at: indexPath) as! InscriptionCategoryCollectionViewCell
        let categorySelected = cell.categoryName
        let launcherVC = self.storyboard?.instantiateViewController(withIdentifier: "idGameplayLauncherViewController") as! GameplayLauncherViewController
        launcherVC.categoryNameSelected = categorySelected
        self.navigationController?.pushViewController(launcherVC, animated: true)
    }
    
    
//MARK: @IBActions Methods
    
    @IBAction func changeCategorieButtonTouched(_ sender: UIButton) {
        generateCategories()
    }
    
    @IBAction func backButtonTouched(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
//MARK: Helper Methods
    
    func generateCategories(_ number: Int? = 4) {
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
