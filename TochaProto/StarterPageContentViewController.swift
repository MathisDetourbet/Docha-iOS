//
//  StarterPageContentViewController.swift
//  DochaProto
//
//  Created by Mathis D on 22/05/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class StarterPageContentViewController: RootViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet var allGiftImageViewCollection: [UIImageView]?
    //@IBOutlet weak var blurEffectView: UIVisualEffectView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var constraintBulleHowMuch: NSLayoutConstraint!
    @IBOutlet weak var bubbleHowMuchImageView: UIImageView!
    
    var pageIndex: Int? {
        didSet {
            self.buildUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func buildUI() {
        
        self.titleLabel.animatedButtonLikeBubbleWithDelay(0.2, duration: 0.5)
        self.subtitleLabel.animatedButtonLikeBubbleWithDelay(0.2, duration: 0.5)
        
        if let index = self.pageIndex {
            switch index {
            case 0:
                
                break;
            case 1:
                self.bubbleHowMuchImageView.animatedButtonLikeBubbleWithDelay(0.5, duration: 0.5)
                break;
            default:
                
                break;
            }
        }
        
        //self.blurEffectView.alpha = 1.0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if self.pageIndex == 1 {
            self.constraintBulleHowMuch.constant = 0.36667 * self.backgroundImageView.frame.height
        }
    }
}