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
        configTitleViewDocha()
        
        var controllerArray: [RootViewController] = []
        
        let storeGiftsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("idStoreGiftsViewController") as? StoreGiftsViewController
        storeGiftsViewController?.title = "Cadeaux"
        controllerArray.append(storeGiftsViewController!)
        
        let storePromotionsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("idStorePromotionsViewController") as? StorePromotionsViewController
        storePromotionsViewController?.title = "Promotions"
        controllerArray.append(storePromotionsViewController!)
        
        let storeOrdersViewController = self.storyboard?.instantiateViewControllerWithIdentifier("idStoreOrdersViewController") as? StoreOrdersViewController
        storeOrdersViewController?.title = "Commandes"
        controllerArray.append(storeOrdersViewController!)
        
        let pageMenuOptions: [CAPSPageMenuOption] = [
            .MenuItemSeparatorPercentageHeight(0.1),
            //.AddBottomMenuHairline(true),
            .UseMenuLikeSegmentedControl(false),
            .ScrollMenuBackgroundColor(UIColor.redDochaColor()),
            .SelectionIndicatorColor(UIColor.blueDochaColor()),
            .SelectedMenuItemLabelColor(UIColor.whiteColor()),
            .UnselectedMenuItemLabelColor(UIColor.whiteColor()),
            .MenuHeight(50),
            .MenuItemWidth(self.view.frame.width/CGFloat(controllerArray.count)-20),
            .MenuItemFont(UIFont(name: "Montserrat-SemiBold", size: 13.0)!)
        ]
        
        self.pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 44.0, self.view.frame.width, self.view.frame.height-44), pageMenuOptions: pageMenuOptions)
        
        self.view.addSubview(pageMenu!.view)
        self.pageMenu?.delegate = self
    }
}