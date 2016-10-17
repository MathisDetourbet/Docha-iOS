//
//  NewGameFindOpponentViewController.swift
//  Docha
//
//  Created by Mathis D on 01/09/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

class NewGameFindOpponentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
}

class NewGameFriendsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var friendImageView: UIImageView!
    @IBOutlet weak var friendNameLabel: UILabel!
}

class NewGameFindOpponentViewController: GameViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let titlesArray = ["Amis Facebook", "Aléatoire", "Rechercher un joueur"]
    let subTitlesArray = ["Défie un de tes amis", "Défie une personne au hasard", "Défie une personne grâce à son email ou son pseudo"]
    let imagesViewsArray = ["facebook_icon", "random_icon", "search_icon"]
    let tableViewRowHeight: CGFloat = 70.0
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightTableViewConstraint: NSLayoutConstraint!
    
    
//MARK: Life View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func buildUI() {
        configNavigationBarWithTitle("Trouve un adversaire")
        self.view.backgroundColor = UIColor.lightGrayDochaColor()
        collectionView.backgroundColor = UIColor.lightGrayDochaColor()
        
        tableView.backgroundColor = UIColor.lightGrayDochaColor()
        heightTableViewConstraint.constant = tableViewRowHeight * CGFloat(titlesArray.count)
    }

    
//MARK: UICollectionView - Data Source Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "idNewGameFriendsCollectionViewCell", for: indexPath) as! NewGameFriendsCollectionViewCell
        
        return cell
    }
    
    
//MARK: UICollectionView - Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        return
    }
    

//MARK: UITableView - Data Source Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idNewGameFindOpponentTableViewCell", for: indexPath) as! NewGameFindOpponentTableViewCell
        cell.titleLabel.text = titlesArray[(indexPath as NSIndexPath).row]
        cell.subTitleLabel.text = subTitlesArray[(indexPath as NSIndexPath).row]
        cell.cellImageView.image = UIImage(named: imagesViewsArray[(indexPath as NSIndexPath).row])
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    
//MARK: UITableView - Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).row == 0 {
            let newGameFacebookFriendsVC = self.storyboard?.instantiateViewController(withIdentifier: "idNewGameFindFriendsViewController") as! NewGameFindFriendsViewController
            self.navigationController?.pushViewController(newGameFacebookFriendsVC, animated: true)
            
        } else if (indexPath as NSIndexPath).row == 1 {
            MatchManager.sharedInstance.postMatch(
                success: { (match) in
                    
                    let newGameCategorieSelectionVC = self.storyboard?.instantiateViewController(withIdentifier: "idNewGameCategorieSelectionViewController") as! NewGameCategorieSelectionViewController
                    MatchManager.sharedInstance.currentMatch = match
                    self.navigationController?.pushViewController(newGameCategorieSelectionVC, animated: true)
                    
            }) { (error) in
                PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorOccured)
            }
            
        } else if (indexPath as NSIndexPath).row == 2 {
            let newGameFindByPseudoVC = self.storyboard?.instantiateViewController(withIdentifier: "idNewGameFindByPseudoViewController") as! NewGameFindByPseudoViewController
            self.navigationController?.pushViewController(newGameFindByPseudoVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewRowHeight
    }
    
    
    @IBAction func backTouched(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
