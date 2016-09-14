//
//  GameplayDebriefPageContentViewController.swift
//  Docha
//
//  Created by Mathis D on 13/09/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

protocol GameplayDebriefPageContentDelegate {
    func moreDetailsButtonTouched()
    func shareButtonTouched()
}

class GameplayDebriefPageContentViewController: UIViewController {
    
    var pageIndex: Int?
    var delegate: GameplayDebriefPageContentDelegate?
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productBrandLabel: UILabel!
    
    
    @IBAction func shareButtonTouched(sender: UIButton) {
        self.delegate?.shareButtonTouched()
    }
    
    @IBAction func moreDetailsButtonTouched(sender: UIButton) {
        self.delegate?.moreDetailsButtonTouched()
    }
}