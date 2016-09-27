//
//  StorePagerViewController.swift
//  Docha
//
//  Created by Mathis D on 08/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class StorePagerViewController: GameViewController, CAPSPageMenuDelegate {
    
    var pageMenu: CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configGameNavigationBar()
        
        var controllerArray: [RootViewController] = []
        
        let storeGiftsViewController = self.storyboard?.instantiateViewController(withIdentifier: "idStoreGiftsViewController") as? StoreGiftsViewController
        storeGiftsViewController?.title = "Cadeaux"
        controllerArray.append(storeGiftsViewController!)
        
        let storePromotionsViewController = self.storyboard?.instantiateViewController(withIdentifier: "idStorePromotionsViewController") as? StorePromotionsViewController
        storePromotionsViewController?.title = "Promotions"
        controllerArray.append(storePromotionsViewController!)
        
        let storeOrdersViewController = self.storyboard?.instantiateViewController(withIdentifier: "idStoreOrdersViewController") as? StoreOrdersViewController
        storeOrdersViewController?.title = "Commandes"
        controllerArray.append(storeOrdersViewController!)
        
        let pageMenuOptions: [CAPSPageMenuOption] = [
            .menuItemSeparatorPercentageHeight(0.1),
            //.AddBottomMenuHairline(true),
            .useMenuLikeSegmentedControl(false),
            .scrollMenuBackgroundColor(UIColor.redDochaColor()),
            .selectionIndicatorColor(UIColor.blueDochaColor()),
            .selectedMenuItemLabelColor(UIColor.white),
            .unselectedMenuItemLabelColor(UIColor.white),
            .menuHeight(50),
            .menuItemWidth(self.view.frame.width/CGFloat(controllerArray.count)-20),
            .menuItemFont(UIFont(name: "Montserrat-SemiBold", size: 13.0)!)
        ]
        
        self.pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 44.0, width: self.view.frame.width, height: self.view.frame.height-44), pageMenuOptions: pageMenuOptions)
        
        self.view.addSubview(pageMenu!.view)
        self.pageMenu?.delegate = self
    }
}
