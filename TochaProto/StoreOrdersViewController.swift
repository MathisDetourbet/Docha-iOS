//
//  StoreOrdersViewController.swift
//  Docha
//
//  Created by Mathis D on 08/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import Amplitude_iOS

class StoreOrdersViewController: RootViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Amplitude
        Amplitude.instance().logEvent("StoreViewOrders")
    }
}