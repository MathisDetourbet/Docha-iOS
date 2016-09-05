//
//  GameplayLauncherViewController.swift
//  Docha
//
//  Created by Mathis D on 05/09/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import Amplitude_iOS
import SwiftyTimer

class GameplayLauncherViewController: GameViewController {
    
    let categoryImagesNames = ["art_picture_icon", "ball_icon", "burger_icon", "chair_icon", "drone_icon", "machine_icon", "palet_icon", "ring_icon", "screen_icon", "velo_icon"]
    var imagesArray: [UIImage]?
    var categoryNameSelected: String?
    
    var timer: NSTimer?
    var timerFinished: Bool! = false
    var timeleft: Double! = 3.0
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userLevelLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var opponentNameLabel: UILabel!
    @IBOutlet weak var opponentLevelLabel: UILabel!
    @IBOutlet weak var opponentImageView: UIImageView!
    
    @IBOutlet weak var loaderTitleLabel: UILabel!
    @IBOutlet weak var counterImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startLoaderAnimation()
        buildUI()
        loadProducts()
    }
    
    func buildUI() {
        self.navigationController?.navigationBarHidden = true
        self.userImageView.applyCircleBorder()
        self.opponentImageView.applyCircleBorder()
    }
    
    func startLoaderAnimation() {
        self.imagesArray = []
        
        for imageName in self.categoryImagesNames {
            self.imagesArray?.append(UIImage(named: imageName)!)
        }
        
        counterImageView!.animationImages = self.imagesArray
        counterImageView!.animationDuration = 2.0
        counterImageView.startAnimating()
    }
    
    func loadProducts() {
        dispatch_async(dispatch_get_main_queue(), {
            ProductManager.sharedInstance.getPackOfProducts({ (finished, packOfProducts) in
                
                if finished && packOfProducts != nil {
                    self.startTimer()
                    
                } else {
                    print("Error when loading products...")
                }
            })
        })
    }
    
    
//MARK: Timer Methods
    
    func startTheGame() {
        
    }
    
    func startTimer() {
        self.counterImageView.stopAnimating()
        self.counterImageView.animationImages = nil
        self.counterImageView.image = UIImage(named: "gameplay_launching_3")
        self.loaderTitleLabel.hidden = true
        
        self.timerFinished = false
        timer = NSTimer.new(every: 0.01, { (timer: NSTimer) in
            if self.timerFinished == true {
                self.stopTimer()
                self.startTheGame()
                
            } else {
                self.updateTimer()
            }
        })
        self.timer?.start()
    }
    
    func stopTimer() {
        self.timer?.invalidate()
    }
    
    func updateTimer() {
        self.timeleft = self.timeleft - 1.0
        if self.timeleft <= 0 {
            self.timerFinished = true
            
        } else {
            self.counterImageView.image = UIImage(named: "gameplay_launching_\(Int(self.timeleft))")
        }
    }
}