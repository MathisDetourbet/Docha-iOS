//
//  NewGameFindOpponentViewController.swift
//  Docha
//
//  Created by Mathis D on 01/09/2016.
//  Copyright © 2016 LaTV. All rights reserved.
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = false
    }
    
    func buildUI() {
        configNavigationBarWithTitle("Trouve un adversaire")
        self.view.backgroundColor = UIColor.lightGrayDochaColor()
        self.collectionView.backgroundColor = UIColor.lightGrayDochaColor()
        
        self.tableView.backgroundColor = UIColor.lightGrayDochaColor()
        self.heightTableViewConstraint.constant = self.tableViewRowHeight * CGFloat(self.titlesArray.count)
    }

    
//MARK: UICollectionView - Data Source Methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("idNewGameFriendsCollectionViewCell", forIndexPath: indexPath) as! NewGameFriendsCollectionViewCell
        
        return cell
    }
    
    
//MARK: UICollectionView - Delegate Methods
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        return
    }
    

//MARK: UITableView - Data Source Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesArray.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("idNewGameFindOpponentTableViewCell", forIndexPath: indexPath) as! NewGameFindOpponentTableViewCell
        cell.titleLabel.text = self.titlesArray[indexPath.row]
        cell.subTitleLabel.text = self.subTitlesArray[indexPath.row]
        cell.cellImageView.image = UIImage(named: self.imagesViewsArray[indexPath.row])
        cell.accessoryType = .DisclosureIndicator
        
        return cell
    }
    
    
//MARK: UITableView - Delegate Methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            
            
        } else if indexPath.row == 1 {
            let newGameCategorieSelectionVC = self.storyboard?.instantiateViewControllerWithIdentifier("idNewGameCategorieSelectionViewController") as! NewGameCategorieSelectionViewController
            self.navigationController?.pushViewController(newGameCategorieSelectionVC, animated: true)
            
        } else if indexPath.row == 2 {
            
            
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.tableViewRowHeight
    }
    
    
    @IBAction func backTouched(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}