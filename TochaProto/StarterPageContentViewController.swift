//
//  StarterPageContentViewController.swift
//  DochaProto
//
//  Created by Mathis D on 22/05/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class StarterPageContentViewController: RootViewController {
    
    @IBOutlet weak var backgroundColoredView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var allGiftImageViewCollection: [UIImageView]?
    
    var pageIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildUI()
    }
    
    func buildUI() {
        
        // design image
        if let index = self.pageIndex {
            switch index {
            case 0:
                self.backgroundColoredView.backgroundColor = UIColor(red: 76, green: 162, blue: 255, alpha: 1)
                break;
            case 1:
                self.backgroundColoredView.backgroundColor = UIColor(red: 255, green: 112, blue: 101, alpha: 1)
                break;
            default:
                self.backgroundColoredView.backgroundColor = UIColor(red: 251, green: 196, blue: 73, alpha: 1)
                break;
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
}