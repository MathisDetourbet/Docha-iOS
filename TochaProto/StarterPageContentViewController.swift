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
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var constraintBulleHowMuch: NSLayoutConstraint!
    @IBOutlet weak var bubbleHowMuchImageView: UIImageView!
    @IBOutlet weak var bubbleWomanPriceImageView: UIImageView!
    @IBOutlet weak var bubbleManPriceImageView: UIImageView!
    
    var pageIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        titleLabel.hidden = true
        subtitleLabel.hidden = true
        if let index = pageIndex {
            if index == 1 {
                bubbleHowMuchImageView.hidden = true
                
            } else if index == 2 {
                bubbleWomanPriceImageView.hidden = true
                bubbleManPriceImageView.hidden = true
            }
        }
    }
    
    func buildUI() {
        titleLabel.hidden = false
        subtitleLabel.hidden = false
        titleLabel.animatedLikeBubbleWithDelay(0.0, duration: 0.5)
        subtitleLabel.animatedLikeBubbleWithDelay(0.2, duration: 0.5)
        
        if let index = pageIndex {
            
            if index == 1 {
                bubbleHowMuchImageView.hidden = false
                bubbleHowMuchImageView.animatedLikeBubbleWithDelay(0.0, duration: 0.5)
                
            } else if index == 2 {
                bubbleManPriceImageView.hidden = false
                bubbleWomanPriceImageView.hidden = false
                bubbleWomanPriceImageView.animatedLikeBubbleWithDelay(0.5, duration: 0.5)
                bubbleManPriceImageView.animatedLikeBubbleWithDelay(0.7, duration: 0.5)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if pageIndex == 1 {
            //self.constraintBulleHowMuch.constant = 0.4 * self.backgroundImageView.frame.height
        }
    }
}