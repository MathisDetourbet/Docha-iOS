//
//  GameplayLauncherViewController.swift
//  Docha
//
//  Created by Mathis D on 05/09/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import Amplitude_iOS
import Kingfisher

class GameplayLauncherViewController: GameViewController, ProductImageDownloaderDelegate {
    
    var userPlayer: Player?
    var opponentPlayer: Player?
    var round: Round?
    
    var productsArray: [Product]?
    let categoryImagesNames = ["art_picture_icon", "ball_icon", "burger_icon", "chair_icon", "drone_icon", "machine_icon", "palet_icon", "ring_icon", "screen_icon", "velo_icon"]
    var imagesArray: [UIImage]?
    var categorySelected: Category?
    
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
    
    
//MARK: Life View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildUI()
        startLoaderAnimation()
        initTimer()
        loadProducts()
    }
    
    func buildUI() {
        let matchManager = MatchManager.sharedInstance
        
        userPlayer = matchManager.userPlayer
        opponentPlayer = matchManager.opponentPlayer
        
        if let userPlayer = self.userPlayer {
            userImageView.image = userPlayer.avatarImage?.roundCornersToCircle(withBorder: 10.0, color: UIColor.white)
            userNameLabel.text = userPlayer.pseudo
        }
        
        if let opponentPlayer = self.opponentPlayer {
            if let opponentAvatarImage = opponentPlayer.avatarImage {
                opponentImageView.image = opponentAvatarImage.roundCornersToCircle(withBorder: 10.0, color: UIColor.white)
                
            } else if opponentPlayer.playerType == .facebookPlayer {
                opponentImageView.kf.setImage(with: URL(string: opponentPlayer.avatarUrl)!,
                    completionHandler: { (image, error, _, _) in
                        if image != nil {
                            self.opponentImageView.image = image!.roundCornersToCircle()
                            matchManager.opponentPlayer = opponentPlayer
                        }
                    }
                )
                
            } else {
                opponentImageView.image = UIImage(named: "\(opponentPlayer.avatarUrl))_large")?.roundCornersToCircle(withBorder: 10.0, color: UIColor.white)
            }
            
            opponentNameLabel.text = opponentPlayer.pseudo
            
            if let level = opponentPlayer.level {
                opponentLevelLabel.text = "Niveau \(level)"
                
            } else {
                opponentLevelLabel.text = "Niveau ?"
            }
        }
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func startTheGame(withProducts products: [Product]!) {
        let gameplayMainVC = self.storyboard?.instantiateViewController(withIdentifier: "idGameplayMainViewController") as! GameplayMainViewController
        gameplayMainVC.round = round as! RoundFull
        gameplayMainVC.userPlayer = userPlayer
        gameplayMainVC.opponentPlayer = opponentPlayer
        self.navigationController?.pushViewController(gameplayMainVC, animated: true)
    }
    
    func startLoaderAnimation() {
        imagesArray = []
        
        for imageName in categoryImagesNames {
            imagesArray?.append(UIImage(named: imageName)!)
        }
        imagesArray?.shuffle()
        
        counterImageView!.animationImages = imagesArray
        counterImageView!.animationDuration = 2.0
        counterImageView.startAnimating()
    }
    
    
//MARK: Downloader Data Methods + Delegate
    
    func loadProducts() {
        let currentMatch = MatchManager.sharedInstance.currentMatch
        
        if let match = currentMatch {
            if let categorySelected = categorySelected, match.getCurrentRound().category == nil {
                let data = [RoundDataKey.kCategory: categorySelected.slugName, RoundDataKey.kPropositions: []] as [String : Any]
                put(round: match.rounds.last, withData: data, andMatchID: match.id)
                
            } else {
                get(round: match.getCurrentRound(), withMatchID: match.id)
            }
            
        } else {
            PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorOccured,
                doneActionCompletion: {
                    self.goToHome()
                }
            )
        }
    }
    
    func put(round: Round!, withData data: [String: Any]!, andMatchID matchID: Int!) {
        MatchManager.sharedInstance.putRound(withData: data!, ForMatchID: matchID, andRoundID: round.id,
            success: { (roundFull) in
                let roundFull = roundFull
                self.round = roundFull
                let products = roundFull.products
                
                if products.isEmpty == false {
                    let productDownloader = ProductImageDownloader()
                    productDownloader.productsDelegate = self
                    productDownloader.downloadImages(withProducts: products,
                        fail: { (error) in
                            PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorOccured,
                                doneActionCompletion: {
                                    self.goToHome()
                                }
                            )
                        }
                    )

                } else {
                    PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorOccuredHomeRedirection,
                        doneActionCompletion: {
                            self.goToHome()
                        }
                    )
                }
            }, fail: { (error) in
                
                PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorOccuredHomeRedirection, viewController: nil, completion: nil,
                    doneActionCompletion: {
                        self.goToHome()
                    }
                )
            }
        )
    }
    
    func get(round: Round!, withMatchID matchID: Int!) {
        MatchManager.sharedInstance.getRound(ForMatchID: matchID, andRoundID: round.id,
            success: { (roundFull) in
                
                let roundFull = roundFull
                self.round = roundFull
                let products = roundFull.products
                
                if products.isEmpty == false {
                    let productDownloader = ProductImageDownloader()
                    productDownloader.productsDelegate = self
                    productDownloader.downloadImages(withProducts: products,
                        fail: { (error) in
                            PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorOccured,
                                doneActionCompletion: {
                                    self.goToHome()
                                }
                            )
                        }
                    )
                    
                } else {
                    PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorOccuredHomeRedirection,
                        doneActionCompletion: {
                            self.goToHome()
                        }
                    )
                }
                                                
            }, fail: { (error) in
                PopupManager.sharedInstance.showErrorPopup(message: Constants.PopupMessage.ErrorMessage.kErrorOccuredHomeRedirection, viewController: nil, completion: nil,
                    doneActionCompletion: {
                        self.goToHome()
                    }
                )
            }
        )
    }
    
    func didFinishedDownloadImages(withProducts products: [Product]) {
        self.round?.products = products
        self.productsArray = products
        self.productsReady = true
    }
    
    
//MARK: Timer Methods
    
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
                startTheGame(withProducts: productsArray)
                
            } else {
                counterImageView.image = UIImage(named: "gameplay_launching_\(Int(self.timeleft))")
            }
        }
    }
}
