//
//  CouponsStoreViewController.swift
//  DochaProto
//
//  Created by Mathis D on 28/01/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class CouponsStoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var couponsList: [Coupon] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillDatabase()
    }
    
    func fillDatabase() {
        couponsList.append(Coupon(name: "-20% sur l'électroménager et la hi-fi.", brandName: "Darty", brandImage: UIImage(named: "logo_darty")!, categories: "HI-FI, ELECTRO-MENAGER", price: 435, percentage: 20))
        couponsList.append(Coupon(name: "Livraison offerte sans minimum d'achat", brandName: "3 Suisses", brandImage: UIImage(named: "logo_3suisses")!, categories: "TEXTILE, MAISON, SPORT...", price: 63, percentage: 0))
        couponsList.append(Coupon(name: "10% de réduction sur tout le site", brandName: "Asos", brandImage: UIImage(named: "logo_asos")!, categories: "TEXTILE", price: 268, percentage: 10))
        couponsList.append(Coupon(name: "5€ offerts", brandName: "Yves Rocher", brandImage: UIImage(named: "logo_yves_rocher")!, categories: "BEAUTÉ", price: 323, percentage: 5))
        couponsList.append(Coupon(name: "5€ offerts", brandName: "FNAC", brandImage: UIImage(named: "logo_fnac")!, categories: "HI-FI, ELECTRO-MENAGER", price: 415, percentage: 5))
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.couponsList.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerView = UIView()
        headerView.backgroundColor = UIColor.clearColor()
        return headerView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idCouponTableViewCell", forIndexPath: indexPath)
        let coupon = self.couponsList[indexPath.row + indexPath.section]
        if let couponCell = cell as? CouponTableViewCell {
            couponCell.brandImageView.image = coupon.brandImage!
            couponCell.titleLabel.text = coupon.brandName! + " " + coupon.name!
            couponCell.categorieLabel.text = "CATÉGORIE: " + coupon.categories!
            couponCell.priceLabel.text = String(coupon.price!)
            
            return couponCell
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}
