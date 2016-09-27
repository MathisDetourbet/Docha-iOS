//
//  GameplayLauncherViewController.swift
//  Docha
//
//  Created by Mathis D on 05/09/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import Amplitude_iOS

class GameplayLauncherViewController: GameViewController {
    
    var productsArray: [Product]?
    let categoryImagesNames = ["art_picture_icon", "ball_icon", "burger_icon", "chair_icon", "drone_icon", "machine_icon", "palet_icon", "ring_icon", "screen_icon", "velo_icon"]
    var imagesArray: [UIImage]?
    var categoryNameSelected: String?
    
    var productsReady: Bool = false {
        didSet {
            if productsReady {
                self.counterImageView.stopAnimating()
                self.counterImageView.animationImages = nil
                self.counterImageView.image = UIImage(named: "gameplay_launching_3")
                self.loaderTitleLabel.isHidden = true
            }
        }
    }
    
    var timer: Timer?
    var timeleft: Double! = 4.0
    
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
        
        buildUI()
        startLoaderAnimation()
        initTimer()
        loadProducts()
    }
    
    func buildUI() {
        self.navigationController?.isNavigationBarHidden = true
        self.userImageView.applyCircleBorder()
        self.opponentImageView.applyCircleBorder()
    }
    
    func startLoaderAnimation() {
        imagesArray = []
        
        for imageName in categoryImagesNames {
            imagesArray?.append(UIImage(named: imageName)!)
        }
        imagesArray?.shuffle()
        
        counterImageView!.animationImages = self.imagesArray
        counterImageView!.animationDuration = 2.0
        counterImageView.startAnimating()
    }
    
    func loadProducts() {
        DispatchQueue.main.async(execute: {
            ProductManager.sharedInstance.getPackOfProducts({ (finished, packOfProducts) in
                
                if finished && packOfProducts != nil {
                    self.productsReady = true
                    self.productsArray = packOfProducts
                    
                } else {
                    PopupManager.sharedInstance.showErrorPopup("Oups !", message: "Une erreur est survenue... Tu seras redirigé vers le menu principal", viewController: nil, completion: nil, doneActionCompletion: {
                        self.goToHome()
                    })
                    print("Error when loading products...")
                }
            })
        })
    }
    
    
//MARK: Timer Methods
    
    func startTheGameWithProducts(_ products: [Product]!) {
        let gameplayMainVC = self.storyboard?.instantiateViewController(withIdentifier: "idGameplayMainViewController") as! GameplayMainViewController
        gameplayMainVC.productsData = products
        self.navigationController?.pushViewController(gameplayMainVC, animated: true)
    }
    
    func initTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GameplayMainViewController.updateTimer), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func updateTimer() {
        if productsReady {
            timeleft = timeleft - 1.0
            if timeleft <= 0 {
                stopTimer()
                startTheGameWithProducts(self.productsArray)
                
            } else {
                counterImageView.image = UIImage(named: "gameplay_launching_\(Int(self.timeleft))")
            }
        }
    }
}
