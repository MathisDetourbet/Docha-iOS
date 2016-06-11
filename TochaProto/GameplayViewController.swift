//
//  GameplayViewController.swift
//  Docha
//
//  Created by Mathis D on 10/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import MBCircularProgressBar
import SwiftyTimer

class GameplayViewController: RootViewController {
    
    var productsList: [Product]?
    
    let kTimeForPreview: Int = 2
    let kTimeForMain: Int = 5
    var timer: NSTimer?
    
    @IBOutlet weak var previewCircularProgress: MBCircularProgressBarView!
    @IBOutlet weak var productBrandLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var firstFeatureLabel: UILabel!
    @IBOutlet weak var secondFeatureLabel: UILabel!
    @IBOutlet weak var thirdFeatureLabel: UILabel!
    
    
    @IBOutlet weak var keyboardContainerView: KeyboardView!
    @IBOutlet weak var counterContainerView: CounterContainerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        configureView()
    }
    
    func configureView() {
        self.hidesBottomBarWhenPushed = true
    }
}