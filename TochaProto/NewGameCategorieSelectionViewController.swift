//
//  NewGameCategorieSelectionViewController.swift
//  Docha
//
//  Created by Mathis D on 01/09/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import SACountingLabel

class NewGameCategorieSelectionViewController: GameViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var categoriesDisplayed: [Category] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var userDochosLabel: SACountingLabel!
    @IBOutlet weak var renewCategoriesButton: UIButton!
    
//MARK: Life View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildUI()
        loadCategory(withCompletion: nil)
    }
    
    func buildUI() {
        configNavigationBarWithTitle("Choisis ta catégorie")
        self.navigationController?.isNavigationBarHidden = false
        self.view.backgroundColor = UIColor.lightGrayDochaColor()
        collectionView.backgroundColor = UIColor.lightGrayDochaColor()
        
        let user = UserSessionManager.sharedInstance.getUserInfosAndAvatarImage().user
        if let user = user {
            let dochos = Float(user.dochos)
            userDochosLabel.countFrom(0.0, to: dochos, withDuration: 1.0, andAnimationType: .easeInOut, andCountingType: .int)
            renewCategoriesButton.isEnabled = Int(dochos) <= 10 ? false : true
        }
    }
    
    func loadCategory(withCompletion completion: (() -> Void)?) {
        let match = MatchManager.sharedInstance.currentMatch
        
        if let match = match {
            MatchManager.sharedInstance.getRound(ForMatchID: match.id, andRoundID: match.rounds.last?.id,
                success: { (roundFull) in
                    
                    for categorie in roundFull.proposedCategories {
                        self.categoriesDisplayed.append(categorie)
                    }
                    
                    self.collectionView.reloadData()
                    
                }, fail: { (error) in
                    PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorOccured, doneActionCompletion: {
                            self.goToHome()
                        }
                    )
                }
            )
        }
    }
    
    
//MARK: UICollectionView - Data Source Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesDisplayed.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "idNewGameCategorySelectionCollectionCell", for: indexPath) as! InscriptionCategoryCollectionViewCell
        
        cell.categoryName = categoriesDisplayed[indexPath.item].name
        cell.imageSelected = false
        cell.categoryImageView.image = UIImage(named: categoriesDisplayed[indexPath.item].slugName)
        
        return cell
    }
    

//MARK: UICollectionView - Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (UIApplication.shared.delegate as! AppDelegate).hasLowNetworkConnection() {
            PopupManager.sharedInstance.showLoadingPopup(message: Constants.PopupMessage.LoadingMessage.kLoadingJustAMoment,
                completion: {
                    self.startTheGame(withCategoryIndexPath: indexPath)
                }
            )
        } else {
            startTheGame(withCategoryIndexPath: indexPath)
        }
    }
    
    private func startTheGame(withCategoryIndexPath indexPath: IndexPath) {
        MatchManager.sharedInstance.loadPlayersInfos(
            withCompletion: {
                
                PopupManager.sharedInstance.dismissPopup(true,
                    completion: {
                        
                        let categorySelected = self.categoriesDisplayed[indexPath.item]
                        let launcherVC = self.storyboard?.instantiateViewController(withIdentifier: "idGameplayLauncherViewController") as! GameplayLauncherViewController
                        launcherVC.categorySelected = categorySelected
                        self.navigationController?.pushViewController(launcherVC, animated: true)
                    }
                )
            }
        )
    }
    
    
//MARK: @IBActions Methods
    
    @IBAction func changeCategorieButtonTouched(_ sender: UIButton) {
        if let userDochos = UserSessionManager.sharedInstance.currentSession()?.dochos {
            if userDochos >= 10 {
                let match = MatchManager.sharedInstance.currentMatch
                let round = MatchManager.sharedInstance.currentRound
                
                UserSessionManager.sharedInstance.renewCategories(forMatchID: match?.id, andRoundID: round?.id,
                    success: { (categories) in
                        self.categoriesDisplayed = categories
                        
                        let newUserDochos = UserSessionManager.sharedInstance.currentSession()?.dochos
                        self.userDochosLabel.countFrom(Float(userDochos), to: Float(newUserDochos!), withDuration: 1.0, andAnimationType: .easeInOut, andCountingType: .int)
                        self.collectionView.reloadData()
                        
                        if newUserDochos < 10 {
                            self.renewCategoriesButton.isEnabled = false
                        }
                                                                    
                    }, fail: {(error) in
                        PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorOccured)
                    }
                )
            }
        }
    }
    
    @IBAction func backButtonTouched(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
//MARK: Helper Methods
    
//    func generateCategories(_ number: Int? = 4) {
//        var categoriesGenerated: [String] = []
//        let categoriesAvailables = ["Lifestyle", "High-Tech", "Maison / déco", "Bijoux / Montres", "Électroménager", "Art", "Objets connectés", "Gastronomie", "Beauté", "Sport"]
//        let categoriesShuffled = categoriesAvailables.shuffled()
//        
//        for i in 0...3 {
//            categoriesGenerated.append(categoriesShuffled[i])
//        }
//        
//        categoriesDisplayed = categoriesGenerated
//        collectionView.reloadData()
//    }
}
