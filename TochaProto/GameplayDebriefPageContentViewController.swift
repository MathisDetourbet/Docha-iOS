//
//  GameplayDebriefPageContentViewController.swift
//  Docha
//
//  Created by Mathis D on 13/09/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

protocol GameplayDebriefPageContentDelegate {
    func moreDetailsButtonTouched()
    func shareButtonTouched()
}

class GameplayDebriefPageContentViewController: UIViewController {
    
    var pageIndex: Int?
    var delegate: GameplayDebriefPageContentDelegate?
    
    @IBOutlet var counterContainerView: CounterContainerView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productBrandLabel: UILabel!
    @IBOutlet weak var sharingButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        productImageView.layer.cornerRadius = 18.0
        productImageView.layer.masksToBounds = false
        productImageView.clipsToBounds = true
    }
    
    @IBAction func shareButtonTouched(_ sender: UIButton) {
        self.delegate?.shareButtonTouched()
    }
    
    @IBAction func moreDetailsButtonTouched(_ sender: UIButton) {
        self.delegate?.moreDetailsButtonTouched()
    }
}
